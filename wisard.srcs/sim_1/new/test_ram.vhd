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

	constant bits : integer := 4;
	constant clk_time : time := 2 ns;
	
	
	component ram is
	
		generic(
			address_bits : integer
		);
		
		port(
			clk : in std_logic;
		  	w : in std_logic;
		  	address : in std_logic_vector;
		  	datain : in std_logic_vector;
		  	dataout : out std_logic_vector);
	  	
	end component;
	
	signal clk: std_logic;
	signal w : std_logic;
	signal address : std_logic_vector(bits downto 1);
	signal written : std_logic_vector(8 downto 1);
	signal read : std_logic_vector(8 downto 1);
	signal clock: clock := ('0', 2ns);
	
begin

	my_memory : ram generic map (bits) port map (clk, w, address, written, read);

	main : process is
	begin

        --cycle(clock);
		clk <= '0'; wait for clk_time/2;
		w <= '1';
		
		address <= std_logic_vector(to_unsigned(0, address'length));
		written <= std_logic_vector(to_unsigned(0, written'length));
		clk <= '1'; wait for clk_time/2;
        clk <= '0'; wait for clk_time/2;
        
		address <= std_logic_vector(to_unsigned(1, address'length));
        written <= std_logic_vector(to_unsigned(1, written'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(2, address'length));
        written <= std_logic_vector(to_unsigned(2, written'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(3, address'length));
        written <= std_logic_vector(to_unsigned(3, written'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(4, address'length));
        written <= std_logic_vector(to_unsigned(4, written'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(5, address'length));
        written <= std_logic_vector(to_unsigned(5, written'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(6, address'length));
        written <= std_logic_vector(to_unsigned(6, written'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
        address <= std_logic_vector(to_unsigned(7, address'length));
        written <= std_logic_vector(to_unsigned(7, written'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		w <= '0';
		
		address <= std_logic_vector(to_unsigned(0, address'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(1, address'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(2, address'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(3, address'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(4, address'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(5, address'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(6, address'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		address <= std_logic_vector(to_unsigned(7, address'length));
		clk <= '1'; wait for clk_time/2;
		clk <= '0'; wait for clk_time/2;
		
		wait;
		
	end process main;
	
end Behavioral;
