library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library weightless;
use weightless.utils.all;

entity test_utils is
	-- port ( );
end entity test_utils;

architecture RTL of test_utils is
	
	signal clk : std_logic;
	signal rst : std_logic;
	signal tmp : unsigned(log2_ceil(7)+1 downto 1);
	
begin
	
	test : process is
	begin
		
		reset(clk, rst);
		
		assert vsum("0011010") = 3 report "1";
		assert vsum("1111111") = 7 report "2";
		assert vsum("0000000") = 0 report "3";
		assert vsum("0011011") = 4 report "4";
		assert vsum("1010101") = 4 report "5";
		
		tmp <= vsum("0011010");
		
		wait;
		
	end process test;
	
	
end architecture RTL;
