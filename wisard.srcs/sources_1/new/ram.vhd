----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2016 05:11:14 PM
-- Design Name: 
-- Module Name: ram - Behavioral
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

entity ram is
	
	generic (
		address_bits : integer
	);
	
	Port (
		clk : in std_logic;
	  	w : in std_logic;
	  	address : in std_logic_vector(address_bits downto 1);
	  	datain : in std_logic_vector;
	  	dataout : out std_logic_vector
	);
	
end ram;

architecture Behavioral of ram is

	type memory_type is array(2**address_bits-1 downto 0) of std_logic_vector(datain'length downto 1);
	signal memory : memory_type;
	
begin

	main : process (clk) is
	begin
		if rising_edge(clk) then
			if w = '1' then
				memory(to_integer(unsigned(address))) <= datain;
				dataout <= datain;
			else
				dataout <= memory(to_integer(unsigned(address)));
			end if;
		end if;
	end process main;

end Behavioral;
