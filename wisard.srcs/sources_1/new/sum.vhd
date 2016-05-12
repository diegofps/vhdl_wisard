library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commons.all;

entity sum is
	
	generic (
		num_inputs : natural;
		num_bits   : natural
	);
	
	port (
		clk : in std_logic;
		inputs : in matrix(num_inputs downto 1, num_bits downto 1);
		result : out std_logic_vector(num_bits + log2_ceil(num_inputs) downto 1)
	);
	
end entity sum;

architecture RTL of sum is
	
	component sum
		generic(num_inputs : natural;
			    num_bits   : natural);
		port(clk    : in  std_logic;
			 inputs : in  matrix(num_inputs downto 1, num_bits downto 1);
			 result : out std_logic_vector(num_bits + log2_ceil(num_inputs) downto 1));
	end component sum;
		
	signal inner_layer  : matrix(ceil(real(num_inputs)/2.0) downto 1, num_bits+1 downto 1);
	
begin
	
	break_condition_1 : if num_inputs = 1 generate
	
        name : process (clk) is
        begin
            if rising_edge(clk) then
                result <= getrow(inputs, 1);
            end if;
        end process name;
        
	end generate break_condition_1;
	
	
    break_condition_2 : if num_inputs = 2 generate
    
        name : process (clk) is
        begin
            if rising_edge(clk) then
                result <= std_logic_vector(
                        unsigned('0' & getrow(inputs, 1)) + 
                        unsigned('0' & getrow(inputs, 2)));
            end if;
        end process name;
        
    end generate break_condition_2;
    
	
	continue_case : if num_inputs > 2 generate
	
        name : process (clk) is
        begin
            if rising_edge(clk) then
                if (num_inputs mod 2) = 1 then
                    setrow(
                        inner_layer, 
                        floor(real(num_inputs)/2.0)+1, 
                        '0' & getrow(inputs, num_inputs)
                    );
                end if;
                
                for i in 1 to floor(real(num_inputs)/2.0) loop
                    setrow(inner_layer, i, std_logic_vector(
                        unsigned('0' & getrow(inputs, (i-1)*2+1)) + 
                        unsigned('0' & getrow(inputs, (i-1)*2+2))
                    ));
                end loop;
                
            end if;
        end process name;
        
        recursive_adder : sum generic map(ceil(real(num_inputs)/2.0), num_bits+1) port map(clk, inner_layer, result);
	end generate continue_case;
	
end architecture RTL;
