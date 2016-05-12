library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commons.all;

entity test_commons is
	-- port ( );
end entity test_commons;

architecture RTL of test_commons is
	
begin
	
	name : process is
	begin
		
		assert log2_ceil(1) = 0 report "log2(1)!=0";
		assert log2_ceil(2) = 1 report "log2(2)!=1";
		assert log2_ceil(3) = 2 report "log2(3)!=2";
		assert log2_ceil(4) = 2 report "log2(4)!=2";
		assert log2_ceil(5) = 3 report "log2(5)!=3";
		assert log2_ceil(8) = 3 report "log2(8)!=3";
		
		assert floor(1.00) = 1 report "floor(1.00)!=1";
		assert floor(1.10) = 1 report "floor(1.10)!=1";
		assert floor(1.50) = 1 report "floor(1.50)!=1";
		assert floor(1.99) = 1 report "floor(1.99)!=1";
		assert floor(2.00) = 2 report "floor(2.00)!=2";
		
		assert ceil(1.00) = 1 report "ceil(1.00)!=1";
		assert ceil(1.10) = 2 report "ceil(1.10)!=2";
		assert ceil(1.50) = 2 report "ceil(1.50)!=2";
		assert ceil(1.99) = 2 report "ceil(1.99)!=2";
		assert ceil(2.00) = 2 report "ceil(2.00)!=2";
		
		wait;
	end process name;
	
end architecture RTL;
