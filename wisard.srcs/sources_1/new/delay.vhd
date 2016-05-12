----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2016 02:13:52 PM
-- Design Name: 
-- Module Name: delay - Behavioral
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

entity delay is

	Port (
		clk     : in std_logic;
        datain  : in std_logic_vector;
        dataout : out std_logic_vector);

end delay;

architecture Behavioral of delay is
begin
	
	main : process(clk) is
	begin
		if (rising_edge(clk)) then
			dataout <= datain;
		end if;
	end process main;

end Behavioral;
