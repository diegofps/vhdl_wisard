----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2016 04:05:17 PM
-- Design Name: 
-- Module Name: test_fataddress - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.commons.all;

entity test_fataddress is
--  Port ( );
end test_fataddress;

architecture Behavioral of test_fataddress is

	signal inputs : vector_list(4 downto 1);
	
	signal result1 : std_logic_vector(7 downto 0);
	signal result2 : std_logic_vector(7 downto 0);
	signal result3 : std_logic_vector(7 downto 0);
	signal result4 : std_logic_vector(7 downto 0);

begin

	fa1 : biggers generic map(1) port map (inputs, result1);
	fa2 : biggers generic map(2) port map (inputs, result2);
	fa3 : biggers generic map(3) port map (inputs, result3);
	fa4 : biggers generic map(4) port map (inputs, result4);

	name : process is
		constant clk_time : time := 2ns;
		
	begin
		if rising_edge(clk) then
			
			clk <= '0'; wait for clk_time / 2;
			
			inputs(1) <= std_logic_vector(to_unsigned(  4, 8 ));
			inputs(2) <= std_logic_vector(to_unsigned( 20, 8 ));
			inputs(3) <= std_logic_vector(to_unsigned(  7, 8 ));
			inputs(4) <= std_logic_vector(to_unsigned( 50, 8 ));
			clk <= '1'; wait for clk_time / 2;
			clk <= '0'; wait for clk_time / 2;
			
		end if;
	end process name;
	
end Behavioral;
