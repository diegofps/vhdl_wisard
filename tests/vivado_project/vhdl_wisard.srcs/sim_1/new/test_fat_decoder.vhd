library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library weightless;
use weightless.utils.all;

entity test_fat_decoder is
	-- port ( );
end entity test_fat_decoder;

architecture RTL of test_fat_decoder is
	
	constant num_inputs : natural := 4;
	constant len_inputs : natural := 8;
	
	component fat_decoder
		generic(num_inputs : natural;
			    len_inputs : natural);
		port(clk     : in  std_logic;
			 rst     : in  std_logic;
			 inputs  : in  matrix(num_inputs downto 1, len_inputs downto 1);
			 address : out unsigned(log2_ceil(fat(num_inputs)) downto 1));
	end component fat_decoder;
	
	signal clk     : std_logic;
	signal rst     : std_logic;
	signal inputs  : matrix(num_inputs downto 1, len_inputs downto 1);
	signal address : unsigned(log2_ceil(fat(num_inputs)) downto 1);
	
begin
	
	ifat_decoder : fat_decoder 
			generic map(num_inputs, len_inputs) 
			port map(clk, rst, inputs, address);
	
	test : process is
	begin
		reset(clk, rst);
		
		setrow(inputs, 1, std_logic_vector(to_unsigned(070, len_inputs)));
		setrow(inputs, 2, std_logic_vector(to_unsigned(120, len_inputs)));
		setrow(inputs, 3, std_logic_vector(to_unsigned(255, len_inputs)));
		setrow(inputs, 4, std_logic_vector(to_unsigned(200, len_inputs)));
		
		for i in 1 to 20 loop
			pulse(clk);
		end loop;
		
		wait;
	end process test;
	
	
end architecture RTL;
