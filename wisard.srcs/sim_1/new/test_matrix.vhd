library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commons.all;

entity test_matrix is
	--port ( );
end entity test_matrix;


architecture RTL of test_matrix is
	
	constant items : natural := 5;
	constant bits  : natural := 5;
	
	signal clk : std_logic := '0';
	signal m  : matrix(items downto 1, bits downto 1);
	signal m2 : matrix(2 downto 1, bits+1 downto 1);
	
begin
	
	name : process is
	begin
		
		setrow(m, 1, std_logic_vector(to_unsigned(1, bits)));
		setrow(m, 2, std_logic_vector(to_unsigned(2, bits)));
		setrow(m, 3, std_logic_vector(to_unsigned(3, bits)));
        
		pulse(clk);
		
        setrow(m, 4, std_logic_vector(unsigned(getrow(m, 1))+unsigned(getrow(m, 2))));
        setrow(m, 5, std_logic_vector(unsigned(getrow(m, 3))+unsigned(getrow(m, 2))));
		
		setrow(m2, 1, std_logic_vector(unsigned('0' & getrow(m, 1))+unsigned('0' & getrow(m, 2))));
        setrow(m2, 2, std_logic_vector(unsigned('0' & getrow(m, 3))+unsigned('0' & getrow(m, 2))));
        
        pulse(clk);
        
		wait;
	end process name;
	
end architecture RTL;
