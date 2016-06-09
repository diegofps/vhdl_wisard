library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library weightless;
use weightless.utils.all;

entity test_fwisard is
	-- port ( );
end entity test_fwisard;

architecture RTL of test_fwisard is
	
	component fwisard
		generic(num_inputs         : natural;
			    num_discriminators : natural;
			    num_raminputs      : natural;
			    data_size          : natural;
			    len_inputs         : natural);
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 train       : in  std_logic;
			 target      : in  unsigned(log2_ceil(num_discriminators) downto 1);
			 pattern     : in  matrix(num_inputs downto 1, len_inputs downto 1);
			 ticket      : out std_logic_vector(log2_ceil(cycles_fwisard(num_raminputs, num_inputs, num_discriminators)) downto 1);
			 ticket_call : out std_logic_vector(log2_ceil(cycles_fwisard(num_raminputs, num_inputs, num_discriminators)) downto 1);
			 prediction  : out unsigned(log2_ceil(num_discriminators) downto 1));
	end component fwisard;
	
	constant num_discriminators : natural := 3;
	constant num_inputs         : natural := 6;
	constant num_raminputs      : natural := 3;
	constant len_inputs         : natural := 8;
	constant data_size          : natural := 1;
	constant len_target         : natural := log2_ceil(num_discriminators);
	
	signal clk         : std_logic := '0';
	signal rst         : std_logic := '0';
	signal train       : std_logic := '0';
	signal target      : unsigned(log2_ceil(num_discriminators) downto 1);
	signal pattern     : matrix(num_inputs downto 1, len_inputs downto 1);
	signal ticket      : std_logic_vector(log2_ceil(cycles_fwisard(num_raminputs, num_inputs, num_discriminators)) downto 1);
	signal ticket_call : std_logic_vector(log2_ceil(cycles_fwisard(num_raminputs, num_inputs, num_discriminators)) downto 1);
	signal prediction  : unsigned(log2_ceil(num_discriminators) downto 1);
	
	procedure assign_pattern1(signal pattern : out matrix(num_inputs downto 1, len_inputs downto 1)) is
	begin
		for i in 1 to num_inputs loop
			setrow(pattern, i, std_logic_vector(to_unsigned(i, len_inputs)));
		end loop;
	end procedure assign_pattern1;
	
	procedure assign_pattern2(signal pattern : out matrix(num_inputs downto 1, len_inputs downto 1)) is
	begin
		for i in 1 to num_inputs loop
			if i mod 2 = 0 then
				setrow(pattern, i, std_logic_vector(to_unsigned(0, len_inputs)));
			else 
				setrow(pattern, i, std_logic_vector(to_unsigned(1, len_inputs)));
			end if;
		end loop;
	end procedure assign_pattern2;
	
	procedure assign_pattern3(signal pattern : out matrix(num_inputs downto 1, len_inputs downto 1)) is
	begin
		for i in 1 to num_inputs loop
			setrow(pattern, i, std_logic_vector(to_unsigned(num_inputs-i+1, len_inputs)));
		end loop;
	end procedure assign_pattern3;
	
begin
	
	ifwisard : fwisard
		generic map(
			num_inputs         => num_inputs,
			num_discriminators => num_discriminators,
			num_raminputs      => num_raminputs,
			data_size          => data_size,
			len_inputs         => len_inputs
		)
		port map(
			clk         => clk,
			rst         => rst,
			train       => train,
			target      => target,
			pattern     => pattern,
			ticket      => ticket,
			ticket_call => ticket_call,
			prediction  => prediction
		);
	
	main_test : process is
	begin
		reset(clk, rst);
		
		
		-- Starts the training phase
		train  <= '1';
		
		target <= to_unsigned(0, len_target); assign_pattern1(pattern);
		pulse(clk);
		target <= to_unsigned(1, len_target); assign_pattern2(pattern);
		pulse(clk);
		target <= to_unsigned(2, len_target); assign_pattern3(pattern);
		pulse(clk);
		
		
		-- Ends the training phase
		train  <= '0';
		target <= to_unsigned(0, len_target);
		
		assign_pattern1(pattern); pulse(clk);
		assign_pattern2(pattern); pulse(clk);
		assign_pattern3(pattern); pulse(clk);
		
		assign_pattern1(pattern); pulse(clk);
		assign_pattern2(pattern); pulse(clk);
		assign_pattern3(pattern); pulse(clk);
		
		
		-- Final simulation cycles
		for i in 1 to 50 loop
			pulse(clk);
		end loop;
		
		
		-- End
		wait;
	end process main_test;
	
end architecture RTL;
