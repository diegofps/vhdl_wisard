library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library weightless;
use weightless.utils.all;

entity test_wisard is
	-- port ( );
end entity test_wisard;

architecture RTL of test_wisard is
	
	constant num_inputbits      : natural := 10;
    constant num_discriminators : natural := 03;
    constant num_rambits        : natural := 03;
    constant data_size          : natural := 05;
	constant len_target         : natural := log2_ceil(num_discriminators);
	
	constant pattern0 : std_logic_vector(num_inputbits downto 1) := "0011001100";
	constant pattern1 : std_logic_vector(num_inputbits downto 1) := "1111001111";
	constant pattern2 : std_logic_vector(num_inputbits downto 1) := "0011111100";
	
	component wisard
		generic(num_inputbits      : natural;
			    num_discriminators : natural;
			    num_rambits        : natural;
			    data_size          : natural);
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 train       : in  std_logic;
			 target      : in  unsigned(len_target downto 1);
			 pattern     : in  std_logic_vector(num_inputbits downto 1);
			 ticket      : out std_logic_vector(log2_ceil(cycles_wisard(num_inputbits, num_discriminators, num_rambits)) downto 1);
			 ticket_call : out std_logic_vector(log2_ceil(cycles_wisard(num_inputbits, num_discriminators, num_rambits)) downto 1);
			 prediction  : out unsigned(len_target downto 1));
	end component wisard;
	
	signal clk         : std_logic := '0';
	signal rst         : std_logic := '0';
	signal train       : std_logic := '0';
	signal target      : unsigned(len_target downto 1);
	signal pattern     : std_logic_vector(num_inputbits downto 1);
	signal ticket      : std_logic_vector(log2_ceil(cycles_wisard(num_inputbits, num_discriminators, num_rambits)) downto 1);
	signal ticket_call : std_logic_vector(log2_ceil(cycles_wisard(num_inputbits, num_discriminators, num_rambits)) downto 1);
	signal prediction  : unsigned(len_target downto 1);
	
begin
	
	iwisard : wisard
			generic map(num_inputbits, num_discriminators, num_rambits, data_size)
			port map(clk, rst, train, target, pattern, ticket, ticket_call, prediction);
	
	test : process is
	begin
		reset(clk, rst);
		
		-- Start the training
		train <= '1';
		
		-- Training
		target  <= to_unsigned(0, len_target); pattern <= pattern0;
		pulse(clk);
		
		target  <= to_unsigned(1, len_target); pattern <= pattern1;
		pulse(clk);
		
		target  <= to_unsigned(2, len_target); pattern <= pattern2;
		pulse(clk);
		
		-- End the training
		train  <= '0';
		
		-- Classification
		pattern <= pattern0; pulse(clk);
		pattern <= pattern1; pulse(clk);
		pattern <= pattern2; pulse(clk);
		
		pattern <= "0011001101"; pulse(clk);
		pattern <= "1111001110"; pulse(clk);
		pattern <= "0011110100"; pulse(clk);
		
		for i in 1 to 20 loop
			pulse(clk);
		end loop;
		
		wait;
	end process test;

end architecture RTL;
