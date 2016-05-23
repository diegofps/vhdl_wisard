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

use work.commons.all;

entity ram is
	
	generic (
		data_size : natural
	);
	
	Port (
		clk     : in  std_logic;
		rst     : in  std_logic;
	  	train   : in  std_logic;
	  	address : in  std_logic_vector;
	  	dataout : out std_logic_vector(data_size downto 1)
	);
	
end ram;

architecture RTL of ram is

	type memory_type is array(2**address'length-1 downto 0) of std_logic_vector(data_size downto 1);
	signal memory : memory_type;
	
begin

	main : process (clk) is
		variable n1, n2 : unsigned(data_size downto 1);
		
	begin
		if rising_edge(clk) then
			if rst = '1' then
				for i in 0 to 2**address'length-1 loop
					memory(i) <= std_logic_vector(to_unsigned(0, data_size));
				end loop;
				
			else 
				if train = '1' then
					if not (unsigned(memory(to_integer(unsigned(address)))) = 2 ** data_size-1) then
						n1 := unsigned(memory(to_integer(unsigned(address))));
						n2 := to_unsigned(1, data_size);
						memory(to_integer(unsigned(address))) <= std_logic_vector(n1 + n2);
					end if;
					dataout <= (others => 'U');
				else
					dataout <= memory(to_integer(unsigned(address)));
				end if;
			end if;
		end if;
	end process main;

end RTL;
