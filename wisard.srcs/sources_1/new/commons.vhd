----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2016 06:38:12 PM
-- Design Name: 
-- Module Name: commons - Behavioral
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

library IEEE_EXTRAS;
use IEEE_EXTRAS.MATH_REAL.all;

package commons is
    
    type matrix is array(natural range <>, natural range <>) of std_logic;
    
    subtype byte    is std_logic_vector( 7 downto 0);
    subtype word    is std_logic_vector(15 downto 0);
    subtype number  is std_logic_vector(31 downto 0);
    subtype long    is std_logic_vector(63 downto 0);
    
    type byte_vector    is array(natural range <>) of byte  ;
    type word_vector    is array(natural range <>) of word  ;
    type integer_vector is array(natural range <>) of number;
    type long_vector    is array(natural range <>) of long  ;
    
    function  getrow  (m          : matrix; i : natural) return std_logic_vector;
    procedure setrow  (signal m   : out matrix; constant RowNumber : in integer; constant row : in std_logic_vector);
    procedure vsetrow (variable m : out matrix; constant RowNumber : in integer; constant row : in std_logic_vector);

    function "+"  (in1, in2 : in std_logic_vector) return std_logic_vector;
	function ">=" (in1, in2 : in std_logic_vector) return boolean;
    
    function compare(
		id, current : in natural; 
		inputs      : in byte_vector) return byte;
    
    function ceil      (n : real   ) return integer;
    function floor     (n : real   ) return integer;
    function round     (n : real   ) return integer;
    function log2_ceil (n : natural) return natural;
	function xrange    (rows : natural; cols : natural) return matrix;
	function randperm  (seed : POSITIVE; rows : natural; cols : natural) return matrix;
	
	procedure pulse(signal clk : out std_logic);
	procedure reset(signal clk : out std_logic; signal rst : out std_logic);
	
end package commons;

package body commons is

	function randperm(seed : POSITIVE; rows : natural; cols : natural) return matrix is
		variable result   : matrix(rows downto 1, cols downto 1);
		variable tmp      : std_logic_vector(cols downto 1);
		variable current  : natural;
		variable selected : natural;
		variable seed1    : POSITIVE := seed;
		variable seed2    : POSITIVE := 821616997;
		variable random   : real;
	begin
		for i in 1 to rows loop
			tmp := std_logic_vector(to_unsigned(i, cols));
			for j in 1 to cols loop
				result(i, j) := tmp(j);
			end loop;
		end loop;
		
		for current in rows downto 2 loop
			uniform(seed1, seed2, random);
			selected := floor(random * real(current)) + 1;
			
--			tmp := result(selected);
			for j in 1 to cols loop
				tmp(j) := result(selected, j);
			end loop;
			
--			result(selected) := result(current);
			for j in 1 to cols loop
				result(selected, j) := result(current, j);
			end loop;
			
--			result(current) := tmp;
			for j in 1 to cols loop
				result(current, j) := tmp(j);
			end loop;
		end loop;
		
		return result;
	end function randperm;
	
	function xrange (rows : natural; cols : natural) return matrix is
		variable temp_mem : matrix(rows downto 1, cols downto 1);
		variable tmp      : std_logic_vector(cols downto 1);
	begin
		for i in 1 to rows loop
			tmp := std_logic_vector(to_unsigned(i, cols));
			for j in 1 to cols loop
				temp_mem(i, j) := tmp(j);
			end loop;
		end loop;
		return temp_mem;
	end function xrange;
	
	procedure pulse(signal clk : out std_logic) is
	begin
		clk <= '1'; wait for 1ns;
		clk <= '0'; wait for 1ns;
	end procedure pulse;
	
	procedure reset(signal clk : out std_logic; signal rst : out std_logic) is
	begin
		rst <= '1';
		pulse(clk);
		rst <= '0';
	end procedure reset;
	
    function log2_ceil(n : natural) return natural is
        variable current : real := real(n);
        variable result  : natural := 0;
    begin
        while current > 1.0 loop
            current := current / 2.0;
            result := result + 1;
        end loop;
        
        return result;
    end function log2_ceil;
    
    function getrow (m : matrix; i : natural) return std_logic_vector is
    	variable value : std_logic_vector(m'high(2) downto m'low(2));
    begin
    	
    	for j in m'high(2) downto m'low(2) loop
    		value(j) := m(i, j);
    	end loop;
    	
    	return value;
    end function getrow;
    
    procedure setrow(signal m : out matrix; constant RowNumber : in integer; constant row : in std_logic_vector) is
--    	variable k : natural;
    	variable tmp : STD_LOGIC_VECTOR(m'high(2) downto m'low(2));  -- Xilinx iSIM work-around, because 'range(2) evaluates to 'range(1); tested with ISE XST/iSim 14.2
	begin
--		tmp := row;
--		k := m'high(2);
--		for j in m'high(2) downto m'low(2) loop
--			m(i, j) <= tmp(k);
--			k := k - 1;
--		end loop;
		
		tmp := row;
		for j in tmp'range loop
		    m(RowNumber, j) <= tmp(j);
		end loop;
		
	end procedure;

    procedure vsetrow(variable m : out matrix; constant RowNumber : in integer; constant row : in std_logic_vector) is
        variable tmp : STD_LOGIC_VECTOR(m'high(2) downto m'low(2));
    begin
        tmp := row;
        for j in tmp'range loop
            m(RowNumber, j) := tmp(j);
        end loop;
    end procedure;

	function "+" (in1, in2 : in std_logic_vector) return std_logic_vector is
    begin
    	return std_logic_vector(unsigned(in1) + unsigned(in2));
    end function "+";
    
    function ">=" (in1, in2 : in std_logic_vector) return boolean is
    begin
    	return unsigned(in1) >= unsigned(in2);
	end function ">=";
    
    function compare(
		id, current : in natural; 
		inputs      : in byte_vector) return byte is
	begin
		if inputs(current) = inputs(id) then
			if current <= id then
				return byte(to_unsigned( 0, byte'length ));
			else
				return byte(to_unsigned( 1, byte'length ));
			end if;
		else
			if inputs(id) < inputs(current) then
				return byte(to_unsigned( 0, byte'length ));
			else
				return byte(to_unsigned( 1, byte'length ));
			end if;
		end if;
	end function compare;
    
    function round (n : real) return integer is
    begin
        return integer(n);
    end function round;

    function floor (n : real) return integer is
    begin
        return integer(n-0.5);
    end function floor;
    
	function ceil(n : real) return integer is
	   variable tmp : integer;
	begin
		tmp := integer(n-0.5);
		if real(tmp) < n then
			return tmp + 1;
		else
			return tmp;
		end if;
	end function ceil;
    
end commons;
