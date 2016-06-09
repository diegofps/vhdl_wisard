----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/27/2016 07:24:23 PM
-- Design Name: 
-- Module Name: bit_delay - Behavioral
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

entity bit_delay is
	
	generic (
		size : natural
	);
    
    Port (
    	clk     : in STD_LOGIC;
    	rst     : in STD_LOGIC;
    	datain  : in STD_LOGIC;
    	dataout : out STD_LOGIC
	);
	
end bit_delay;

architecture Behavioral of bit_delay is

	type type_pipe is array(size downto 1) of std_logic;
	signal pipe : type_pipe;

begin
	
	zero_delay : if size = 0 generate
	main : process (clk) is
	begin
		if rising_edge(clk) then
			dataout <= datain;
		end if;
	end process main;
	end generate zero_delay;
	
	not_zero_delay : if not (size = 0) generate
	main : process (clk) is
	begin
		if rising_edge(clk) then
			if rst = '1' then
				for i in 1 to size loop
					pipe(i) <= 'U';
				end loop;
			else
				dataout <= pipe(size);
				for i in size downto 2 loop
					pipe(i) <= pipe(i-1);
				end loop;
				pipe(1) <= datain;
			end if;
		end if;
	end process main;	
	end generate not_zero_delay;

end Behavioral;
