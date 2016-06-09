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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library weightless;
use weightless.utils.all;

entity test_vector_delay is
--  Port ( );
end test_vector_delay;

architecture Behavioral of test_vector_delay is

	component vector_delay
		generic(size : natural);
		port(clk     : in  STD_LOGIC;
			 rst     : in  STD_LOGIC;
			 datain  : in  STD_LOGIC_VECTOR;
			 dataout : out STD_LOGIC_VECTOR);
	end component vector_delay;

	constant length : natural := 10;

	signal clk     : std_logic := '0';
	signal rst     : std_logic := '0';
	signal datain  : std_logic_vector(length downto 1);
	signal dataout : std_logic_vector(length downto 1);
	
begin

	vectordelay : vector_delay generic map(5) port map(clk, rst, datain, dataout);

	main_test : process is
	begin
		reset(clk, rst);
		
		datain <= std_logic_vector(to_unsigned(00, length)); pulse(clk);
		datain <= std_logic_vector(to_unsigned(11, length)); pulse(clk);
		datain <= std_logic_vector(to_unsigned(22, length)); pulse(clk);
		datain <= std_logic_vector(to_unsigned(33, length)); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= std_logic_vector(to_unsigned(00, length)); pulse(clk);
		datain <= std_logic_vector(to_unsigned(00, length)); pulse(clk);
		datain <= std_logic_vector(to_unsigned(00, length)); pulse(clk);
		datain <= std_logic_vector(to_unsigned(07, length)); pulse(clk);
		datain <= std_logic_vector(to_unsigned(07, length)); pulse(clk);
		datain <= std_logic_vector(to_unsigned(07, length)); pulse(clk);
		datain <= std_logic_vector(to_unsigned(07, length)); pulse(clk);
		datain <= std_logic_vector(to_unsigned(07, length)); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		datain <= (others => 'U'); pulse(clk);
		
		wait;
		
	end process main_test;

end Behavioral;
