library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;


entity aproximator is
	generic(
		width: natural := 8;
		a: integer := 1;
		b: integer := 2;
		c: integer := 3;
		m: integer := 7
		);
	port(
		x_i: in std_logic;
		ready_o: out std_logic;
		clock_i: in std_logic;
		reset_i: in std_logic;
		y_o: out std_logic;
		sum_o: out std_logic_vector(width-1 downto 0));
end entity aproximator;


architecture struct of aproximator is
	
	-- Component declaration of the "aproximator_ua(beh)" unit defined in
	-- file: "./src/aproximator_ua.vhd"
	component aproximator_ua
		port(
			clock_i : in std_logic;
			reset_i : in std_logic;
			x_i : in std_logic;
			y_o : out std_logic;
			ready_o : out std_logic;
			sum_less_zero_i : in std_logic;
			sum_plus_a_o : out std_logic;
			sum_minus_b_o : out std_logic;
			states: out std_logic_vector(1 downto 0));
	end component;
	
	-- Component declaration of the "aproximator_oa(beh)" unit defined in
	-- file: "./src/aproximator_oa.vhd"
	component aproximator_oa
		generic(
			width : NATURAL := 8;
			a: integer := 1;
			b: integer := 2;
			c: integer := 3;
			m : INTEGER := 7);
		port(
			clock_i : in std_logic;
			reset_i : in std_logic;
			sum_plus_a_i : in std_logic;
			sum_minus_b_i : in std_logic;
			sum_less_zero_o : out std_logic;
			sum_o: out std_logic_vector(width-1 downto 0));
	end component;
	
	signal sum_less_zero, sum_plus_a, sum_minus_b: std_logic;
	
	signal t: std_logic_vector(1 downto 0);
	
	signal sum_temp: std_logic_vector (width-1 downto 0);
	
begin
	
	--sum_o <= "000000" & t;
	
	CONTROL_UNIT : aproximator_ua
	port map(
		clock_i => clock_i,
		reset_i => reset_i,
		x_i => x_i,
		y_o => y_o,
		ready_o => ready_o,
		sum_less_zero_i => sum_less_zero,
		sum_plus_a_o => sum_plus_a,
		sum_minus_b_o => sum_minus_b,
		states => t
		);
	
	DATA_FLOW : aproximator_oa
	generic map(
		width => width,
		a => a,
		b => b,
		c => c,
		m => m
		)
	port map(
		clock_i => clock_i,
		reset_i => reset_i,
		sum_plus_a_i => sum_plus_a,
		sum_minus_b_i => sum_minus_b,
		sum_less_zero_o => sum_less_zero,
		sum_o => sum_o
		);
	
	
	
end struct;
