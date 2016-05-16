library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commons.all;

entity test_max is
	-- port ( );
end entity test_max;

architecture RTL of test_max is
	
	component max
		generic(num_inputs : natural;
			    len_inputs : natural);
		port(clk    : in  std_logic;
			 inputs : in  matrix(num_inputs downto 1, len_inputs downto 1);
			 result : out std_logic_vector(log2_ceil(num_inputs) downto 1));
	end component max;
	
	constant num_inputs : natural :=  5;
	constant len_inputs : natural := 10;
	
	signal clk    : std_logic := '0';
	signal inputs : matrix(num_inputs downto 1, len_inputs downto 1) := xrange(num_inputs, len_inputs);
	signal result : std_logic_vector(log2_ceil(num_inputs) downto 1);
	
begin
	
	name : max generic map(num_inputs, len_inputs) port map(clk, inputs, result);
	
	test : process is
	begin
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		
		inputs <= randperm(844397721, num_inputs, len_inputs);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		
		inputs <= randperm(844498720, num_inputs, len_inputs);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		
		inputs <= randperm(844599720, num_inputs, len_inputs);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		
	end process test;
	
end architecture RTL;

