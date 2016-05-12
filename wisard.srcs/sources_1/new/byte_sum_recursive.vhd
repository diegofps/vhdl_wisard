library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use WORK.commons.ALL;

entity byte_sum_recursive is
	
	generic (
		length : natural
	);
	
	port (
		clk    : in std_logic;
		list   : in word_vector(length downto 1);
		result : out word
	);

end entity byte_sum_recursive;

architecture RTL of byte_sum_recursive is
	
	component byte_sum_recursive
		generic(length : natural);
		port(clk    : in  std_logic;
			 list   : in  word_vector(length downto 1);
			 result : out word);
	end component byte_sum_recursive;
	
	signal tmp          : word_vector(ceil(real(length)/2.0) downto 1);
	 
begin
	
	end_case : if length = 1 generate
		name : process (clk) is
		begin
			if rising_edge(clk) then
				result <= list(1);
			end if;
		end process name;
	end generate end_case;
	
	continue_case : if not (length = 1) generate
    
            recursive_adder : byte_sum_recursive generic map(ceil(real(length)/2.0)) port map(
                  clk => clk, 
                  list => tmp, 
                  result => result);
            
            length_is_impar : if length mod 2 = 1 generate
                tmp(length/2+1) <= list(length);
            end generate length_is_impar;
            
            parallel_adder : for i in 1 to floor(real(length)/2.0) generate
            	name : process (clk) is
            	begin
            		if rising_edge(clk) then
            			tmp(i) <= list((i-1)*2+1) + list((i-1)*2+2);
            		end if;
            	end process name;
            end generate parallel_adder;
            
	end generate continue_case;
	
end architecture RTL;
