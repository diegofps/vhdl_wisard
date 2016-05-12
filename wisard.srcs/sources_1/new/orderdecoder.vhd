library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity orderdecoder is

	generic (
		num_inputs : integer);

	port (
		clk : in std_logic;
		inputs : in ram_pattern(num_inputs downto 1);
		address : out std_logic_vector(8 downto 1));

end entity orderdecoder;

architecture RTL of orderdecoder is
	
	
	
begin
	
	main : process (clk) is
	begin
		if rising_edge(clk) then
			
		end if;
	end process main;
	
end architecture RTL;
