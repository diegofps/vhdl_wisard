----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2016 03:21:12 PM
-- Design Name: 
-- Module Name: biggers - Behavioral
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

entity biggers is
	
	generic (
		 id : natural
	);
	
	Port (
		inputs : in byte_vector(4 downto 1);
		address : out byte
	);
	
end biggers;

architecture Behavioral of biggers is

	signal outputs : byte_vector(4 downto 1);
	signal sum1 : byte;
	signal sum2 : byte;
	signal sum3 : byte;
    signal teste : matrix(3 downto 1, 8 downto 1);
    signal teste2 : testype(3 downto 1); 
    signal tmp : std_logic_vector(8 downto 1);
    
begin

    tmp <= std_logic_vector(to_unsigned(log2_ceil(1025), 8));
    --tmp <= std_logic_vector(unsigned(getrow(teste, 1)) + unsigned(getrow(teste,2)));
    setrow(teste, 3, tmp);
    
	outputs(1) <= compare(id, 1, inputs);
	outputs(2) <= compare(id, 2, inputs);
	outputs(3) <= compare(id, 3, inputs);
	outputs(4) <= compare(id, 4, inputs);
	--generate_label : for i in 1 to 4 generate
	--	outputs(i) <= compare(id, i, inputs);
	--end generate generate_label;

	sum1 <= outputs(1) + outputs(2);
	sum2 <= outputs(3) + outputs(4);
	--sum3 <= sum1 + sum2;
    sum3 <= std_logic_vector(unsigned(teste(1,:)) + unsigned(teste(2,:)));


	address <= sum3;
	
end Behavioral;
