library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.commons.all;

entity test_sum is
	-- port ( );
end entity test_sum;

architecture RTL of test_sum is
	
	component sum
		generic(num_inputs : natural;
			    num_bits   : natural);
		port(clk    : in  std_logic;
			 inputs : in  matrix(num_inputs downto 1, num_bits downto 1);
			 result : out std_logic_vector(num_bits + log2_ceil(num_inputs) downto 1));
	end component sum;
	
	constant inputs : integer := 3;
    constant bits   : integer := 5;
    
	signal clk    : std_logic := '0';
	signal list   : matrix(3 downto 1, bits downto 1);
	signal result : std_logic_vector(bits + log2_ceil(inputs) downto 1);
--	signal result : matrix(2 downto 1, bits+1 downto 1);
	
begin
	
	adder : sum generic map (inputs, bits) port map(clk, list, result);
	
	main : process is
--	   variable n1, n2, n3 : std_logic_vector(bits downto 1);
	begin
--	    n1 := std_logic_vector(to_unsigned( 1, bits));
--	    n2 := std_logic_vector(to_unsigned( 2, bits));
--	    n3 := std_logic_vector(to_unsigned( 3, bits));
--	    
--        setrow(list, 1, n1);
--        setrow(list, 2, n2);
--        setrow(list, 3, n3);
        
		setrow(list, 1, std_logic_vector(to_unsigned( 1, bits)));
		setrow(list, 2, std_logic_vector(to_unsigned( 2, bits)));
		setrow(list, 3, std_logic_vector(to_unsigned( 3, bits)));
--		setrow(list, 4, std_logic_vector(to_unsigned( 4, bits)));
--		setrow(list, 5, std_logic_vector(to_unsigned( 5, bits)));
		
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		
        pulse(clk);
        pulse(clk);
        pulse(clk);
        pulse(clk);
        
		wait;
		
	end process main;
	
	
end architecture RTL;

