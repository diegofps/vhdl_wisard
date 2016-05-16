library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.commons.all;

entity test_sum is
	-- port ( );
end entity test_sum;

architecture RTL of test_bytesum is
	
	component byte_sum
		generic(length : natural);
		port(clk    : in  std_logic;
			 list   : in  byte_vector(length downto 1);
			 result : out word);
	end component byte_sum;
	
	constant delay : time := 2ns;
	
	signal clk : std_logic;
	signal list : byte_vector(5 downto 1);
	signal result : word;
	
begin
	
	adder : byte_sum generic map (5) port map(clk, list, result);
	
	main : process is
	begin
		clk <= '0'; wait for delay / 2;
		
		list(1) <= byte(to_unsigned( 1, 8));
		list(2) <= byte(to_unsigned( 2, 8));
		list(3) <= byte(to_unsigned( 3, 8));
		list(4) <= byte(to_unsigned( 4, 8));
		list(5) <= byte(to_unsigned(10, 8));
		clk <= '1'; wait for delay / 2;
		clk <= '0'; wait for delay / 2;
		
		clk <= '1'; wait for delay / 2;
        clk <= '0'; wait for delay / 2;
        
		clk <= '1'; wait for delay / 2;
        clk <= '0'; wait for delay / 2;
        
		clk <= '1'; wait for delay / 2;
        clk <= '0'; wait for delay / 2;
        
		clk <= '1'; wait for delay / 2;
        clk <= '0'; wait for delay / 2;
        
		clk <= '1'; wait for delay / 2;
        clk <= '0'; wait for delay / 2;
        
		wait;
		
	end process main;
	
	
end architecture RTL;
