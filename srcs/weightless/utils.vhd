----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2016 06:38:12 PM
-- Design Name: 
-- Module Name: utils - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

library IEEE_EXTRAS;
use IEEE_EXTRAS.MATH_REAL.all;

package utils is
    type matrix is array(natural range <>, natural range <>) of std_logic;
	type integers is array(natural range <>) of integer;
	
	function cycles_fwisard (num_raminputs, num_inputs, num_discriminators : natural) return natural;
	function cycles_fac_decoder(num_inputvalues : natural) return natural;
	function vsum (data : matrix) return unsigned;
	function vsum (data : std_logic_vector) return unsigned;
	procedure vsetrow (variable m : out matrix; constant RowNumber : in integer; constant row : in std_logic_vector);
	function fat (n : natural) return natural;
	function randperm (seed : POSITIVE; n : natural) return integers;
	function xrange (rows : natural; cols : natural) return matrix;
	function cycles_max (num_inputs : natural) return natural;
	function cycles_sum (num_inputs : natural) return natural;
	function cycles_discriminator (num_rams : natural) return natural;
	function cycles_wisard (num_inputbits, num_discriminators, num_rambits : natural) return natural;
	function round (n : real) return integer;
	function floor (n : real) return integer;
	function ceil(n : real) return integer;
	function getrow (m : matrix; i : natural) return std_logic_vector;
	procedure setrow(signal m : out matrix; constant RowNumber : in integer; constant row : in std_logic_vector);
	function log2_ceil(n : natural) return natural;
	procedure pulse(signal clk : out std_logic);
	procedure reset(signal clk : out std_logic; signal rst : out std_logic);
end package utils;

package body utils is
	
	function cycles_fwisard (num_raminputs, num_inputs, num_discriminators : natural)
		return natural is
		
	begin
		return 3 + 
				cycles_fac_decoder(num_raminputs) + 
				cycles_discriminator(num_inputs/num_raminputs) + 
				cycles_max(num_discriminators);
	end function cycles_fwisard;
	
	function cycles_fac_decoder(num_inputvalues : natural) return natural is
	begin
		return 2 + num_inputvalues-1;
	end function cycles_fac_decoder;
	
	function vsum(data : matrix) return unsigned is
		constant new_len : natural := ceil(real(data'high(1))/2.0);
		variable tmp : matrix(new_len downto 1, data'high(2)+1 downto 1);
		variable n1, n2 : unsigned(data'high(2)+1 downto 1);
	begin
		
		if data'high(1) = 1 then
			return unsigned(getrow(data, 1));
		else
			
			if data'high(1) mod 2 = 1 then
				vsetrow(tmp, new_len, '0' & getrow(data, data'high(1)));
			end if;
			
			for i in 0 to data'high(1)/2-1 loop
				n1 := '0' & unsigned(getrow(data, i*2+1));
				n2 := '0' & unsigned(getrow(data, i*2+2));
				vsetrow(tmp, i+1, std_logic_vector(n1 + n2));
			end loop;
			
			return vsum(tmp);
		end if;
	end function vsum;
	
	function vsum(data : std_logic_vector) return unsigned is
		variable tmp  : matrix(data'length downto 1, 1 to 1);
	begin
		for i in 0 to data'length-1 loop
			tmp(1+i, 1) := data(data'low+i);
		end loop;
		return vsum(tmp);
	end function vsum;
	
    procedure vsetrow(variable m : out matrix; constant RowNumber : in integer; constant row : in std_logic_vector) is
        variable tmp : STD_LOGIC_VECTOR(m'high(2) downto m'low(2));
    begin
        tmp := row;
        for j in tmp'range loop
            m(RowNumber, j) := tmp(j);
        end loop;
    end procedure;
	
	function fat (n : natural)
		return natural is
		variable result : natural;
	begin
		if n <= 1 then
			return 1;
		else
			result := n;
			for i in n-1 downto 2 loop
				result := result * i;
			end loop;
			return result;
		end if;
	end function fat;
	
	function randperm(seed : POSITIVE; n : natural) return integers is
		variable result   : integers(n downto 1);
		variable tmp      : integer;
		variable current  : integer;
		variable selected : integer;
		variable seed1    : POSITIVE := seed;
		variable seed2    : POSITIVE := 821616997;
		variable random   : real;
	begin
		for i in 1 to n loop
			result(i) := i-1;
		end loop;
		
		for current in n downto 2 loop
			uniform(seed1, seed2, random);
			selected := floor(random * real(current)) + 1;
			
			tmp := result(selected);
			result(selected) := result(current);
			result(current) := tmp;
		end loop;
		
		return result;
	end function randperm;
	
	function xrange (rows : natural; cols : natural) return matrix is
		variable temp_mem : matrix(rows downto 1, cols downto 1);
		variable tmp      : std_logic_vector(cols downto 1);
	begin
		for i in 1 to rows loop
			tmp := std_logic_vector(to_unsigned(i-1, cols));
			for j in 1 to cols loop
				temp_mem(i, j) := tmp(j);
			end loop;
		end loop;
		return temp_mem;
	end function xrange;
	
	function cycles_max (num_inputs : natural)
		return natural is
	begin
		return log2_ceil(num_inputs);
	end function cycles_max;
	
	function cycles_sum (num_inputs : natural)
		return natural is
	begin
		return log2_ceil(num_inputs);
	end function cycles_sum;
	
	function cycles_discriminator (num_rams : natural) 
		return natural is
	begin
		return 3 + log2_ceil(num_rams);
	end function cycles_discriminator;
	
	function cycles_wisard (num_inputbits, num_discriminators, num_rambits : natural)
		return natural is
	begin
		return 2 + 
				cycles_discriminator(num_inputbits / num_rambits) + 
				cycles_max(num_discriminators);
	end function cycles_wisard;
	
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
    
    function getrow (m : matrix; i : natural) return std_logic_vector is
    	variable value : std_logic_vector(m'high(2) downto m'low(2));
    begin
    	
    	for j in m'high(2) downto m'low(2) loop
    		value(j) := m(i, j);
    	end loop;
    	
    	return value;
    end function getrow;
    
    procedure setrow(signal m : out matrix; constant RowNumber : in integer; constant row : in std_logic_vector) is
    	variable tmp : STD_LOGIC_VECTOR(m'high(2) downto m'low(2));  -- Xilinx iSIM work-around, because 'range(2) evaluates to 'range(1); tested with ISE XST/iSim 14.2
	begin
		tmp := row;
		for j in tmp'range loop
		    m(RowNumber, j) <= tmp(j);
		end loop;
		
	end procedure;
	
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
	
end utils;
