----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2016 10:40:47 PM
-- Design Name: 
-- Module Name: test_adder - Behavioral
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

library WORK;
use WORK.COMMONS.ALL;

entity test_ram is
--  Port ( );
end test_ram;

architecture Behavioral of test_ram is

	constant address_bits : integer := 2;
	constant storage_bits : integer := 3;
	 
	component ram
		generic(data_size : natural);
		port(clk     : in  std_logic;
			 rst     : in  std_logic;
			 train   : in  std_logic;
			 address : in  std_logic_vector;
			 dataout : out std_logic_vector(data_size downto 1));
	end component ram;
	
	signal clk     : std_logic := '0';
	signal rst     : std_logic := '0';
	signal train   : std_logic := '0';
	signal address : std_logic_vector(address_bits downto 1);
	signal dataout : std_logic_vector(storage_bits downto 1);
	
begin

	my_memory : ram generic map (storage_bits) port map (clk, rst, train, address, dataout);

	main : process is
	begin
		
		reset(clk, rst);
		
		address <= std_logic_vector(to_unsigned(0, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(1, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(2, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(3, address_bits)); pulse(clk); pulse(clk);
		
        train <= '1';
        pulse(clk);
		pulse(clk);
        pulse(clk);
		pulse(clk);
        pulse(clk);
		pulse(clk);
        pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
        pulse(clk);
		pulse(clk);
		
        train <= '0';
		address <= std_logic_vector(to_unsigned(0, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(1, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(2, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(3, address_bits)); pulse(clk); pulse(clk);
		
		train <= '1';
		address <= std_logic_vector(to_unsigned(1, address_bits)); pulse(clk);
		address <= std_logic_vector(to_unsigned(2, address_bits)); pulse(clk); pulse(clk);
		
        train <= '0';
		address <= std_logic_vector(to_unsigned(0, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(1, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(2, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(3, address_bits)); pulse(clk); pulse(clk);
		
		reset(clk, rst);
		address <= std_logic_vector(to_unsigned(0, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(1, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(2, address_bits)); pulse(clk); pulse(clk);
		address <= std_logic_vector(to_unsigned(3, address_bits)); pulse(clk); pulse(clk);
		
		wait;
		
	end process main;
	
end Behavioral;
