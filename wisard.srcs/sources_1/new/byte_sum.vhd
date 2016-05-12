library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use WORK.commons.ALL;

entity byte_sum is
	
	generic (
		length : natural
	);
	
	port (
		clk    : in std_logic;
		list   : in byte_vector(length downto 1);
		result : out word
	);
	
end entity byte_sum;

architecture RTL of byte_sum is
	
	component byte_sum_recursive
		generic(length : natural);
		port(clk    : in  std_logic;
			 list   : in  word_vector(length downto 1);
			 result : out word);
	end component byte_sum_recursive;
	
	signal tmp : word_vector(length downto 1);
	
begin
	
	recursive_adder : byte_sum_recursive generic map(length) port map(clk, tmp, result);
	
	expand_all : for i in 1 to length generate
		process (clk) is
		begin
			if rising_edge(clk) then
				tmp(i) <= byte(to_unsigned(0, 8)) & list(i);
			end if;
		end process name;
	end generate expand_all;
	
end architecture RTL;

