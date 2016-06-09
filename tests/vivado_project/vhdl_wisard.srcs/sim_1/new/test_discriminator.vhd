library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library weightless;
use weightless.utils.all;

entity test_discriminator is
	-- port (	);
end entity test_discriminator;

architecture RTL of test_discriminator is
	
	component discriminator
		generic(num_rams    : natural;
			    num_rambits : natural;
			    data_size   : natural);
		port(clk        : in  std_logic;
			 rst        : in  std_logic;
			 train      : in  std_logic;
			 addresses  : in  matrix(num_rams downto 1, num_rambits downto 1);
			 activation : out std_logic_vector(data_size + log2_ceil(num_rams) downto 1));
	end component discriminator;
	
	constant num_rams    : natural := 4;
	constant num_rambits : natural := 5;
	constant data_size   : natural := 3;
	
	signal clk   : std_logic := '0';
	signal rst   : std_logic := '0';
	signal train : std_logic := '0';
	signal addresses  : matrix(num_rams downto 1, num_rambits downto 1);
	signal activation : std_logic_vector(data_size + log2_ceil(num_rams) downto 1);
	
begin
	
	test_unit : discriminator 
			generic map(num_rams, num_rambits, data_size)
			port map(clk, rst, train, addresses, activation);
	
	main : process is
	begin
		
		--report cycles_discriminator()
		
		reset(clk, rst);
		setrow(addresses, 1, std_logic_vector(to_unsigned(0, num_rambits)));
		setrow(addresses, 2, std_logic_vector(to_unsigned(1, num_rambits)));
		setrow(addresses, 3, std_logic_vector(to_unsigned(2, num_rambits)));
		setrow(addresses, 4, std_logic_vector(to_unsigned(3, num_rambits)));
		
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		
		train <= '1';
		pulse(clk);
		train <= '0';
		
		setrow(addresses, 1, std_logic_vector(to_unsigned(0, num_rambits)));
		setrow(addresses, 2, std_logic_vector(to_unsigned(0, num_rambits)));
		setrow(addresses, 3, std_logic_vector(to_unsigned(0, num_rambits)));
		setrow(addresses, 4, std_logic_vector(to_unsigned(0, num_rambits)));
		
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		
		setrow(addresses, 1, std_logic_vector(to_unsigned(0, num_rambits)));
		setrow(addresses, 2, std_logic_vector(to_unsigned(1, num_rambits)));
		setrow(addresses, 3, std_logic_vector(to_unsigned(2, num_rambits)));
		setrow(addresses, 4, std_logic_vector(to_unsigned(0, num_rambits)));
		
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		pulse(clk);
		
		setrow(addresses, 1, std_logic_vector(to_unsigned(0, num_rambits)));
		setrow(addresses, 2, std_logic_vector(to_unsigned(1, num_rambits)));
		setrow(addresses, 3, std_logic_vector(to_unsigned(2, num_rambits)));
		setrow(addresses, 4, std_logic_vector(to_unsigned(3, num_rambits)));
		
		pulse(clk);
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
