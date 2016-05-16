library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commons.all;

library ieee_extras;
use ieee_extras.math_real.all;

entity test_commons is
	-- port ( );
end entity test_commons;

architecture RTL of test_commons is
	
	constant bits : natural := 8;
	
	signal range_matrix : matrix(10 downto 1, 5 downto 1) := xrange(10, 5);
	
	signal randperm_matrix1 : matrix(10 downto 1, 5 downto 1) := randperm(844396720, 10, 5);
	signal randperm_matrix2 : matrix(10 downto 1, 5 downto 1) := randperm(845396720 , 10, 5);
	signal randperm_matrix3 : matrix(10 downto 1, 5 downto 1) := randperm(846396720  , 10, 5);
	
	signal a : std_logic_vector(bits downto 1);
	signal b : std_logic_vector(bits downto 1);
	signal c : std_logic_vector(bits downto 1);
	
	
begin
	
	name : process is
		variable seed1 : POSITIVE := 844396720;
		variable seed2 : POSITIVE := 821616997;
		variable tmp : real;
	begin
	
		uniform(seed1, seed2, tmp);
		a <= std_logic_vector(to_unsigned(floor(tmp * real(2**bits)), bits));
		
		uniform(seed1, seed2, tmp);
		b <= std_logic_vector(to_unsigned(floor(tmp * real(2**bits)), bits));
		
		uniform(seed1, seed2, tmp);
		c <= std_logic_vector(to_unsigned(floor(tmp * real(2**bits)), bits));
		
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
