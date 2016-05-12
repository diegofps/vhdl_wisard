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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_adder is
--  Port ( );
end test_adder;

architecture Behavioral of test_adder is

	signal a : std_logic_vector(4 downto 1);
	signal b : std_logic_vector(4 downto 1);
	signal s : std_logic_vector(4 downto 1);
	
	component adder is
	port(
			in0: in std_logic_vector(4 downto 1);
            in1: in std_logic_vector(4 downto 1);
            out0: out std_logic_vector(4 downto 1));
	end component;
	
	constant tempo : time := 1ns;
	
begin

	myadder : adder port map (a, b, s);

	main : process is
	begin

		a <= "0001";
		b <= "0001";
		wait for tempo;
		
		a <= "0000";
		b <= "0000";
		wait for tempo;

		a <= "0000";
		b <= "0001";
		wait for tempo;

		a <= "0001";
		b <= "0000";
		wait for tempo;

		a <= "0001";
		b <= "0011";
		wait for tempo;

		a <= "0001";
		b <= "0101";
		wait for tempo;
		
		wait;
		
	end process main;
	
end Behavioral;
