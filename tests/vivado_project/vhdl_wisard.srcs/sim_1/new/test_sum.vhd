library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library weightless;
use weightless.utils.all;

entity test_sum is
	-- port ( );
end entity test_sum;

architecture RTL of test_sum is
	
	component sum
		generic(num_inputs : natural;
			    num_bits   : natural);
		port(clk    : in  std_logic;
			 inputs : in  matrix(num_inputs downto 1, num_bits downto 1);
			 result : out std_logic_vector(num_bits + log2_ceil(num_inputs) downto 1));
	end component sum;
	
	constant num_inputs : natural := 3;
	constant num_bits   : natural := 1;
	
	signal clk    : std_logic := '0';
	signal rst    : std_logic := '0';
	signal inputs : matrix(num_inputs downto 1, num_bits downto 1);
	signal result : std_logic_vector(num_bits + log2_ceil(num_inputs) downto 1);
	
begin
	
	isum : sum
		generic map(
			num_inputs => num_inputs,
			num_bits   => num_bits
		)
		port map(
			clk    => clk,
			inputs => inputs,
			result => result
		);
	
	test : process is
	begin
		reset(clk, rst);
		
		setrow(inputs, 1, std_logic_vector(to_unsigned(1, num_bits)));
		setrow(inputs, 2, std_logic_vector(to_unsigned(1, num_bits)));
		setrow(inputs, 3, std_logic_vector(to_unsigned(0, num_bits)));
		
		pulse(clk);
		pulse(clk);
		pulse(clk);
		
		wait;
	end process test;
	
	
end architecture RTL;
