library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library weightless;
use weightless.utils.all;

entity discriminator is
	
	generic (
		num_rams    : natural;
		num_rambits : natural;
		data_size   : natural
	);
	
	port (
		clk        : in  std_logic;
		rst        : in  std_logic;
		train      : in  std_logic;
		addresses  : in  matrix(num_rams downto 1, num_rambits downto 1);
		activation : out std_logic_vector(data_size + log2_ceil(num_rams) downto 1)
	);
	
end entity discriminator;

architecture RTL of discriminator is
	
	component ram
		generic(data_size : natural);
		port(clk     : in  std_logic;
			 rst     : in  std_logic;
			 train   : in  std_logic;
			 address : in  std_logic_vector;
			 dataout : out std_logic_vector(data_size downto 1));
	end component ram;
	
	component sum
		generic(num_inputs : natural;
			    num_bits   : natural);
		port(clk    : in  std_logic;
			 inputs : in  matrix(num_inputs downto 1, num_bits downto 1);
			 result : out std_logic_vector(num_bits + log2_ceil(num_inputs) downto 1));
	end component sum;
	
	type array_type1 is array(num_rams downto 1) of std_logic_vector(data_size   downto 1);
	type array_type2 is array(num_rams downto 1) of std_logic_vector(num_rambits downto 1);
	
	signal train2       : std_logic; 
	signal addresses2   : array_type2;
	signal ram_outputs  : array_type1;
	signal ram_outputs2 : matrix(num_rams downto 1, data_size downto 1);
	
begin
	
	prepare_addresses : process (clk) is
	begin
		if rising_edge(clk) then
			train2 <= train;
			for i in 1 to num_rams loop
				addresses2(i) <= getrow(addresses, i);
			end loop;
		end if;
	end process prepare_addresses;
	
	generate_rams : for i in 1 to num_rams generate
		ram_i : ram 
				generic map (data_size) 
				port map (clk, rst, train2, addresses2(i), ram_outputs(i));
	end generate generate_rams;
	
	prepare_ram_outputs : process (clk) is
	begin
		if rising_edge(clk) then
			for i in 1 to num_rams loop
				setrow(ram_outputs2, i, ram_outputs(i));
			end loop;
		end if;
	end process prepare_ram_outputs;
	
	sum_all : sum 
			generic map(num_rams, data_size) 
			port map(clk, ram_outputs2, activation);
	
end architecture RTL;
