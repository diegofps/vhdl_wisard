library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library weightless;
use weightless.utils.all;

entity rec_fat_decoder is
	
	generic (
		num_indexes : natural; -- Number of index numbers being received
		len_indexes : natural; -- Length of these numbers
		len_address : natural  -- Length of the resulting address
	);
	
	port (
		clk      : in  std_logic;
		rst      : in  std_logic;
		position : in  unsigned(len_address downto 1);
		indexes  : in  matrix(num_indexes downto 1, len_indexes downto 1);
		result   : out unsigned(len_address downto 1)
	);
	
end entity rec_fat_decoder;

architecture RTL of rec_fat_decoder is
	
	component rec_fat_decoder
		generic(num_indexes : natural;
			    len_indexes : natural;
			    len_address : natural);
		port(clk      : in  std_logic;
			 rst      : in  std_logic;
			 position : in  unsigned(len_address downto 1);
			 indexes  : in  matrix(num_indexes downto 1, len_indexes downto 1);
			 result   : out unsigned(len_address downto 1));
	end component rec_fat_decoder;
	
	signal inner_indexes  : matrix(num_indexes-1 downto 1, len_indexes downto 1);
	signal inner_position : unsigned(len_address downto 1);
	
begin
	
	break_condition : if num_indexes = 2 generate
	break_main : process(clk) is
		variable tmp : unsigned(len_indexes downto 1);
	begin
		if rising_edge(clk) then
			tmp := unsigned(getrow(indexes, num_indexes));
			result <= position + resize(tmp, len_address);
		end if;
	end process break_main;
	end generate break_condition;
	
	
	
	continue_condition : if num_indexes > 2 generate
	continue_main : process(clk) is 
		variable tmp : unsigned(len_indexes downto 1);
		variable f   : unsigned(len_address downto 1);
	begin
		if rising_edge(clk) then
			tmp := unsigned(getrow(indexes, num_indexes));
			f   := to_unsigned(fat(num_indexes-1), len_address);
			inner_position <= position + resize(resize(tmp, len_address) * f, len_address);
		end if;
	end process continue_main;
	
	continue_main2 : process(clk) is
	begin
		if rising_edge(clk) then
			for i in num_indexes-1 downto 1 loop
				if unsigned(getrow(indexes, i)) > unsigned(getrow(indexes, num_indexes)) then
					setrow(inner_indexes, i, std_logic_vector(unsigned(getrow(indexes, i))-1));
				else
					setrow(inner_indexes, i, getrow(indexes, i));
				end if;
			end loop;
		end if;
	end process continue_main2;
	
	inner_decoder : rec_fat_decoder 
			generic map(num_indexes-1, len_indexes, len_address)
			port map(clk, rst, 
			inner_position, 
			inner_indexes, 
			result);
	
	end generate continue_condition;
	
end architecture RTL;






library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library weightless;
use weightless.utils.all;

entity fat_decoder is
	
	generic (
		num_inputs : natural;
		len_inputs : natural
	);
	
	port (
		clk     : in  std_logic;
		rst     : in  std_logic;
		inputs  : in  matrix(num_inputs downto 1, len_inputs downto 1);
		address : out unsigned(log2_ceil(fat(num_inputs)) downto 1)
	);
	
end entity fat_decoder;

architecture RTL of fat_decoder is
	
	component rec_fat_decoder
		generic(num_indexes : natural;
			    len_indexes : natural;
			    len_address : natural);
		port(clk      : in  std_logic;
			 rst      : in  std_logic;
			 position : in  unsigned(len_address downto 1);
			 indexes  : in  matrix(num_indexes downto 1, len_indexes downto 1);
			 result   : out unsigned(len_address downto 1));
	end component rec_fat_decoder;
	
	signal biggers : matrix(num_inputs downto 1, num_inputs downto 1);
	signal indexes : matrix(num_inputs downto 1, 1+log2_ceil(num_inputs) downto 1);
	
begin
	
	detect_biggers : process (clk) is
	begin
		if rising_edge(clk) then
			for i in 1 to num_inputs loop
				for j in 1 to num_inputs loop 
					if getrow(inputs, i) = getrow(inputs, j) then
						if i < j then
							biggers(i, j) <= '1';
						else
							biggers(i, j) <= '0';
						end if;
					else
						if unsigned(getrow(inputs, i)) < unsigned(getrow(inputs, j)) then
							biggers(i, j) <= '1';
						else 
							biggers(i, j) <= '0';
						end if;
					end if;
				end loop;
			end loop;
		end if;
	end process detect_biggers;
	
	count_biggers : process(clk) is
	begin
		if rising_edge(clk) then
			for i in 1 to num_inputs loop
				setrow(indexes, i, std_logic_vector(vsum(getrow(biggers, i))));
			end loop;
		end if;
	end process count_biggers;
	
	decode_address : rec_fat_decoder 
			generic map(
				num_inputs, 
				1+log2_ceil(num_inputs),
				log2_ceil(fat(num_inputs)))
				 
			port map(
				clk, 
				rst, 
				to_unsigned(0, log2_ceil(fat(num_inputs))), 
				indexes,
				address);
	
end architecture RTL;
