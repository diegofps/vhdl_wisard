----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2016 04:40:32 PM
-- Design Name: 
-- Module Name: test_biggers - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.commons.all;

entity test_biggers is
--  Port ( );
end test_biggers;

architecture Behavioral of test_biggers is

    constant clk_time : time := 2ns;
		
	component biggers
		generic(id : natural);
		port(inputs  : in  byte_vector(4 downto 1);
			 address : out byte);
	end component biggers;

	signal clk : std_logic;
	
	signal inputs  : byte_vector(4 downto 1);
	signal results : byte_vector(4 downto 1);

begin

	fa1 : biggers generic map(1) port map (inputs, results(1));
	fa2 : biggers generic map(2) port map (inputs, results(2));
	fa3 : biggers generic map(3) port map (inputs, results(3));
	fa4 : biggers generic map(4) port map (inputs, results(4));

	name : process is
	begin
        clk <= '0'; wait for clk_time / 2;
        
        inputs(1) <= byte(to_unsigned(  10, 8 ));
        inputs(2) <= byte(to_unsigned( 20, 8 ));
        inputs(3) <= byte(to_unsigned(  30, 8 ));
        inputs(4) <= byte(to_unsigned( 40, 8 ));
        clk <= '1'; wait for clk_time / 2;
        clk <= '0'; wait for clk_time / 2;
        
        wait;
	end process name;
	
end Behavioral;
