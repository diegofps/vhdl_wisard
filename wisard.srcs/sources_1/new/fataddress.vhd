----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2016 02:40:51 PM
-- Design Name: 
-- Module Name: fataddress - Behavioral
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

use WORK.commons.ALL;

entity fataddress is
	
	generic (
		num_inputs : integer
	);
	
	Port (
		clk     : in std_logic;
        inputs  : in vector_list(num_inputs downto 1);
        address : out std_logic_vector(31 downto 1)
    );

end fataddress;

architecture Behavioral of fataddress is

	signal counts : vector_list(num_inputs downto 1); 

begin

	name : process (clk) is
	begin
		if rising_edge(clk) then
			
		end if;
	end process name;
	

end Behavioral;


