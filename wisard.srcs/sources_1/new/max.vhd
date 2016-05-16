library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commons.all;


-- Returns the index of the highest element in input
entity max_with_indexes is
	
	generic (
		num_inputs  : natural; -- the number of elements in input
		len_inputs  : natural; -- the number of bits in each element
		len_indexes : natural  -- the number of bits in each index
	);
	
	port (
		clk     : in std_logic;
		inputs  : in matrix(num_inputs downto 1, len_inputs  downto 1); -- The input elements
		indexes : in matrix(num_inputs downto 1, len_indexes downto 1); -- The index of each element
		result  : out std_logic_vector(len_indexes downto 1)            -- The index of the highest element
	);
	
end entity max_with_indexes;

architecture RTL of max_with_indexes is
	
	component max_with_indexes
		generic(num_inputs  : natural;
			    len_inputs  : natural;
			    len_indexes : natural);
		port(clk     : in  std_logic;
			 inputs  : in  matrix(num_inputs downto 1, len_inputs downto 1);
			 indexes : in  matrix(num_inputs downto 1, len_indexes downto 1);
			 result  : out std_logic_vector(len_indexes downto 1));
	end component max_with_indexes;
	
	constant inner_num_inputs : natural := ceil(real(num_inputs)/2.0);
	
	signal inner_inputs  : matrix(inner_num_inputs downto 1, len_inputs downto 1);
	signal inner_indexes : matrix(inner_num_inputs downto 1, len_indexes downto 1); 
	
begin
	
	break_condition_1 : if num_inputs = 1 generate
		result <= getrow(indexes, 1);
	end generate break_condition_1;
	
	
	break_condition_2 : if num_inputs = 2 generate
		main : process(clk) is
            variable current   : natural;
            variable following : natural;
		begin
			if rising_edge(clk) then
				current   := 1;
				following := 2;
				
				if getrow(inputs, current) >= getrow(inputs, following) then
					result <= getrow(indexes, current  );
				else
					result <= getrow(indexes, following);
				end if;
			end if;
		end process main;
		
	end generate break_condition_2;
	
	
	continue_condition : if num_inputs > 2 generate
		
		recursive_part : max_with_indexes 
				generic map(inner_num_inputs, len_inputs, len_indexes) 
				port map(clk, inner_inputs, inner_indexes, result);
		
		main : process (clk) is
			variable current   : natural;
			variable following : natural;
		begin
			if rising_edge(clk) then
				if num_inputs mod 2 = 1 then
				    setrow(inner_inputs , inner_num_inputs, getrow(inputs , num_inputs));
					setrow(inner_indexes, inner_num_inputs, getrow(indexes, num_inputs));
				end if;
				
				for i in 1 to floor(real(num_inputs)/2.0) loop
					current   := (i - 1) * 2 + 1;
					following := (i - 1) * 2 + 2;
					
					if getrow(inputs, current) >= getrow(inputs,following) then
						setrow(inner_inputs , i, getrow(inputs , current));
						setrow(inner_indexes, i, getrow(indexes, current));
					else
						setrow(inner_inputs , i, getrow(inputs , following));
                        setrow(inner_indexes, i, getrow(indexes, following));
					end if;
				end loop;
			end if;
		end process main;
		
	end generate continue_condition;
	
end architecture RTL;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commons.all;


-- Returns the index of the highest element in input. 
-- Each element is assigned to a default index ranging 
-- from 1 to num_inputs
entity max is
	
	generic (
		num_inputs : natural; -- the number of elements in input
		len_inputs : natural  -- the number of bits in each element
	);
	
	port (
		clk    : in std_logic;
		inputs : in matrix(num_inputs downto 1, len_inputs downto 1); -- The input elements
		result : out std_logic_vector(log2_ceil(num_inputs) downto 1) -- The index of the highest element 
	);
	
end entity max;

architecture RTL of max is
	
	component max_with_indexes
		generic(num_inputs  : natural;
			    len_inputs  : natural;
			    len_indexes : natural);
		port(clk     : in  std_logic;
			 inputs  : in  matrix(num_inputs downto 1, len_inputs downto 1);
			 indexes : in  matrix(num_inputs downto 1, len_indexes downto 1);
			 result  : out std_logic_vector(len_indexes downto 1));
	end component max_with_indexes;
	
	signal indexes : matrix(num_inputs downto 1, log2_ceil(num_inputs) downto 1) 
			:= xrange(num_inputs, log2_ceil(num_inputs));
	
begin
	
	max : max_with_indexes generic map(num_inputs, len_inputs, log2_ceil(num_inputs)) port map(clk, inputs, indexes, result);
	
end architecture RTL;
