library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library weightless;
use weightless.utils.all;

entity wisard is
	
	generic (
		num_inputbits      : natural; -- Number of bits entering this wisard
		num_discriminators : natural; -- Number of discriminators inside this wisard
		num_rambits        : natural; -- Number of bits entering each ram
		data_size          : natural  -- Number of bits in each ram to count the number of accesses
	);
	
	port (
		clk         : in  std_logic;
		rst         : in  std_logic;
		train       : in  std_logic;
		target      : in  unsigned(log2_ceil(num_discriminators) downto 1);
		pattern     : in  std_logic_vector(num_inputbits downto 1);
		ticket      : out std_logic_vector(log2_ceil(cycles_wisard(num_inputbits, num_discriminators, num_rambits)) downto 1);
		ticket_call : out std_logic_vector(log2_ceil(cycles_wisard(num_inputbits, num_discriminators, num_rambits)) downto 1);
		prediction  : out unsigned(log2_ceil(num_discriminators) downto 1) 
	);
	
end entity wisard;

architecture RTL of wisard is
	
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
	
	constant num_rams   : natural := num_inputbits / num_rambits;
	constant random_map : integers(num_inputbits downto 1) := randperm(42, num_inputbits);
	
	signal addresses    : matrix(num_inputbits/num_rambits downto 1, num_rambits downto 1);
	
	type activations_type is array(num_discriminators downto 1) of std_logic_vector(data_size + log2_ceil(num_rams) downto 1);
	signal activations  : activations_type;
	signal activations2 : matrix(num_discriminators downto 1, data_size + log2_ceil(num_rams) downto 1);
	
	signal trains       : std_logic_vector(num_discriminators downto 1);
	signal wastraining  : std_logic;
	signal prediction2  : std_logic_vector(log2_ceil(num_discriminators) downto 1);
	signal inner_ticket : std_logic_vector(log2_ceil(cycles_wisard(num_inputbits, num_discriminators, num_rambits)) downto 1) := (others => '0');
	
begin
	
	id_delay : vector_delay 
			generic map (cycles_wisard(num_inputbits, num_discriminators, num_rambits))
			port map(clk, rst, inner_ticket, ticket_call);
	
	train_delay : bit_delay
			generic map (cycles_wisard(num_inputbits, num_discriminators, num_rambits)-1)
			port map(clk, rst, train, wastraining);
	
	set_trains : process(clk) is
	begin
		if rising_edge(clk) then
			if (train = '1') then
				for i in 0 to num_discriminators-1 loop
					if to_unsigned(i, target'length) = target then
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
	
	random_mapping : process (clk) is
		variable x, y : natural;
		variable b  : std_logic;
	begin
		if rising_edge(clk) then
			for i in 1 to (num_inputbits/num_rambits)*num_rambits-1 loop
				b := pattern(random_map(i)+1);
				addresses(i/num_rambits+1, 1 + (i mod num_rambits)) <= b;
			end loop;
		end if;
	end process random_mapping;
	
	discriminator_array : for i in 1 to num_discriminators generate
		idiscriminator : discriminator
				generic map(num_rams, num_rambits, data_size)
				port map(clk, rst, trains(i), addresses, activations(i));
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
			generic map(num_discriminators, data_size + log2_ceil(num_rams)) 
			port map(clk, activations2, prediction2);
	
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
	
end architecture RTL;
