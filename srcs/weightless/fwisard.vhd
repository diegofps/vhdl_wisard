library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library weightless;
use weightless.utils.all;

entity fwisard is
	
	generic (
		num_inputs         : natural; -- Number of values entering this fwisard
		num_discriminators : natural; -- Number of discriminators inside this fwisard
		num_raminputs      : natural; -- Number of values entering each ram
		data_size          : natural; -- Number of bits in each ram, to count the number of accesses
		len_inputs         : natural  -- Length of the input values received
	);
	
	port (
		clk         : in  std_logic;
		rst         : in  std_logic;
		train       : in  std_logic;
		target      : in  unsigned(log2_ceil(num_discriminators) downto 1);
		pattern     : in  matrix(num_inputs downto 1, len_inputs downto 1);
		ticket      : out std_logic_vector(log2_ceil(cycles_fwisard(num_raminputs, num_inputs, num_discriminators)) downto 1);
		ticket_call : out std_logic_vector(log2_ceil(cycles_fwisard(num_raminputs, num_inputs, num_discriminators)) downto 1);
		prediction  : out unsigned(log2_ceil(num_discriminators) downto 1)
	);
	
end entity fwisard;

architecture RTL of fwisard is
	
	component bit_delay
		generic(size : natural);
		port(clk     : in  STD_LOGIC;
			 rst     : in  STD_LOGIC;
			 datain  : in  STD_LOGIC;
			 dataout : out STD_LOGIC);
	end component bit_delay;
	
	component vector_delay
		generic(size : natural);
		port(clk     : in  STD_LOGIC;
			 rst     : in  STD_LOGIC;
			 datain  : in  std_logic_vector;
			 dataout : out std_logic_vector);
	end component vector_delay;
	
	component discriminator
		generic(num_rams    : natural;
			    num_rambits : natural;
			    data_size   : natural);
		port(clk        : in  std_logic;
			 rst        : in  std_logic;
			 train      : in  std_logic;
			 addresses  : in  matrix(num_rams downto 1, num_rambits downto 1);
			 activation : out std_logic_vector(data_size + log2_ceil(num_rams) downto 1));
	end component discriminator;
	
	component max
		generic(num_inputs : natural;
			    len_inputs : natural);
		port(clk    : in  std_logic;
			 inputs : in  matrix(num_inputs downto 1, len_inputs downto 1);
			 result : out std_logic_vector(log2_ceil(num_inputs) downto 1));
	end component max;
	
	component fat_decoder
		generic(num_inputs : natural;
			    len_inputs : natural);
		port(clk     : in  std_logic;
			 rst     : in  std_logic;
			 inputs  : in  matrix(num_inputs downto 1, len_inputs downto 1);
			 address : out unsigned(log2_ceil(fat(num_inputs)) downto 1));
	end component fat_decoder;
	
	constant num_rams   : natural := num_inputs / num_raminputs;
	constant random_map : integers(num_inputs downto 1) := randperm(42, num_inputs);
	
	type activations_type is array(num_discriminators downto 1) of std_logic_vector(data_size + log2_ceil(num_rams) downto 1);
	signal activations  : activations_type;
	signal activations2 : matrix(num_discriminators downto 1, data_size + log2_ceil(num_rams) downto 1);
	
	signal trains       : std_logic_vector(num_discriminators downto 1);
	signal wastraining  : std_logic;
	signal inner_train  : std_logic;
	signal inner_target : std_logic_vector(target'range);
	signal prediction2  : std_logic_vector(prediction'range);
	signal inner_ticket : std_logic_vector(ticket'range) := (others => '0');
	
	type type_ram_inputs is array(num_rams downto 1) of matrix(num_raminputs downto 1, len_inputs downto 1);
	signal ram_inputs : type_ram_inputs; 
	
	type type_addresses1 is array(num_rams downto 1) of unsigned(log2_ceil(fat(num_raminputs)) downto 1);
	signal addresses1 : type_addresses1;
	
	signal addresses2 : matrix(num_rams downto 1, log2_ceil(fat(num_raminputs)) downto 1);
	
begin
	
	prepare_ram_inputs : process (clk) is
		--variable tmp : matrix(num_raminputs downto 1, len_inputs downto 1);
	begin
		if rising_edge (clk) then
			for i in 0 to (num_inputs/num_raminputs)*num_raminputs-1 loop
				setrow(
						ram_inputs((i/num_raminputs)+1), 
						(i mod num_raminputs)+1, 
						getrow(pattern, random_map(i+1)+1));
			end loop;
		end if;
	end process prepare_ram_inputs;
	
	fac_decoder_array : for i in 1 to num_rams generate
		ifac_decoder : fat_decoder
			generic map(
				num_inputs => num_raminputs,
				len_inputs => len_inputs
			)
			port map(
				clk     => clk,
				rst     => rst,
				inputs  => ram_inputs(i),
				address => addresses1(i)
			);
	end generate fac_decoder_array;
	
	train_delay1 : bit_delay
		generic map(
			size => cycles_fac_decoder(num_raminputs)
		)
		port map(
			clk     => clk,
			rst     => rst,
			datain  => train,
			dataout => inner_train
		);
	
	target_delay : vector_delay
		generic map(
			size => cycles_fac_decoder(num_raminputs)
		)
		port map(
			clk     => clk,
			rst     => rst,
			datain  => std_logic_vector(target),
			dataout => inner_target
		);
	
	addresses_to_matrix : process (clk) is
	begin
		if rising_edge(clk) then
			for i in 1 to num_rams loop
				setrow(addresses2, i, std_logic_vector(addresses1(i)));
			end loop;
		end if;
	end process addresses_to_matrix;
	
	set_trains : process(clk) is
	begin
		if rising_edge(clk) then
			if (inner_train = '1') then
				for i in 0 to num_discriminators-1 loop
					if to_unsigned(i, inner_target'length) = unsigned(inner_target) then
						trains(i+1) <= '1';
					else
						trains(i+1) <= '0';
					end if;
				end loop;
			else
				trains <= (others => '0');
			end if;
		end if;
	end process set_trains;
	
	train_delay2 : component bit_delay
		generic map(
			size => cycles_fwisard(num_raminputs, num_inputs, num_discriminators)-cycles_fac_decoder(num_raminputs)-2
		)
		port map(
			clk     => clk,
			rst     => rst,
			datain  => inner_train,
			dataout => wastraining
		);
	
	discriminator_array : for i in 1 to num_discriminators generate
		idiscriminator : component discriminator
			generic map(
				num_rams    => num_rams,
				num_rambits => log2_ceil(fat(num_raminputs)),
				data_size   => data_size
			)
			port map(
				clk        => clk,
				rst        => rst,
				train      => trains(i),
				addresses  => addresses2,
				activation => activations(i)
			);
	end generate discriminator_array;
	
	activations_to_matrix : process (clk) is
	begin
		if rising_edge(clk) then
			for i in 1 to num_discriminators loop
				setrow(activations2, i, activations(i));
			end loop;
		end if;
	end process activations_to_matrix;
	
	select_answer : max
		generic map(
			num_inputs => num_discriminators,
			len_inputs => data_size + log2_ceil(num_rams)
		)
		port map(
			clk    => clk,
			inputs => activations2,
			result => prediction2
		);
	
	answer : process (clk) is
	begin
		if rising_edge(clk) then
			if wastraining = '0' then
				prediction <= unsigned(prediction2);
			else
				prediction <= (others => 'U');
			end if;
		end if;
	end process answer;
	
	inc_ticket : process (clk) is
	begin
		if rst = '1' then
			inner_ticket <= (others => '0');
		else
			if rising_edge(clk) then
				ticket <= inner_ticket;
				inner_ticket <= std_logic_vector(unsigned(inner_ticket) + 1);
			end if;
		end if;
	end process inc_ticket;
	
	id_delay : vector_delay
		generic map(
			size => cycles_fwisard(num_raminputs, num_inputs, num_discriminators)
		)
		port map(
			clk     => clk,
			rst     => rst,
			datain  => inner_ticket,
			dataout => ticket_call
		);
		
end architecture RTL;
