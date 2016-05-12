----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2016 02:16:47 PM
-- Design Name: 
-- Module Name: test_delay - Behavioral
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

entity test_delay is
--  Port ( );
end test_delay;

architecture Behavioral of test_delay is

    signal clk : std_logic;
	signal a : std_logic_vector(4 downto 1);
	signal b : std_logic_vector(4 downto 1);
	signal c : std_logic_vector(4 downto 1);
	signal d : std_logic_vector(4 downto 1);
	
	component delay is
    
        Port (
            clk     : in std_logic;
            datain  : in std_logic_vector;
            dataout : out std_logic_vector);
            
    end component;
	
	constant tempo : time := 1ns;
	
begin

	d1 : delay port map (clk, a, b);
	d2 : delay port map (clk, b, c);
	d3 : delay port map (clk, c, d);

	main : process is
	begin

        clk <= '0'; wait for tempo;
        
        a <= "0000";
        clk <= '1'; wait for tempo;
        clk <= '0'; wait for tempo;
        
        a <= "0001";
        clk <= '1'; wait for tempo;
        clk <= '0'; wait for tempo;
        
        a <= "0010";
        clk <= '1'; wait for tempo;
        clk <= '0'; wait for tempo;
        
        a <= "0011";
        clk <= '1'; wait for tempo;
        clk <= '0'; wait for tempo;
        
        a <= "0100";
        clk <= '1'; wait for tempo;
        clk <= '0'; wait for tempo;
        
        a <= "0011";
        clk <= '1'; wait for tempo;
        clk <= '0'; wait for tempo;
        
        a <= "0010";
        clk <= '1'; wait for tempo;
        clk <= '0'; wait for tempo;
        
        a <= "0001";
        clk <= '1'; wait for tempo;
        --clk <= '0'; wait for tempo;
        
		--wait;
		
	end process main;
	
end Behavioral;
