----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/27/2016 07:33:41 PM
-- Design Name: 
-- Module Name: test_bit_delay - Behavioral
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

library weightless;
use weightless.utils.all;

entity test_bit_delay is
--  Port ( );
end test_bit_delay;

architecture Behavioral of test_bit_delay is

	component bit_delay
		generic(size : natural);
		port(clk     : in  STD_LOGIC;
			 rst     : in  STD_LOGIC;
			 datain  : in  STD_LOGIC;
			 dataout : out STD_LOGIC);
	end component bit_delay;

	signal clk     : std_logic := '0';
	signal rst     : std_logic := '0';
	signal datain  : std_logic := '0';
	signal dataout : std_logic := '0';
	
begin

	bitdelay : bit_delay generic map(5) port map(clk, rst, datain, dataout);

	main_test : process is
	begin
		reset(clk, rst);
		
		datain <= '1'; pulse(clk);
		datain <= '0'; pulse(clk);
		datain <= '1'; pulse(clk);
		datain <= '0'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= '0'; pulse(clk);
		datain <= '0'; pulse(clk);
		datain <= '0'; pulse(clk);
		datain <= '1'; pulse(clk);
		datain <= '1'; pulse(clk);
		datain <= '1'; pulse(clk);
		datain <= '1'; pulse(clk);
		datain <= '1'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		datain <= 'U'; pulse(clk);
		
		wait;
		
	end process main_test;

end Behavioral;
