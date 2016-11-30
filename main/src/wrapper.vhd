library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;

entity wrapper is
	generic(
		width: natural := 8;
		a: integer := 1;
		b: integer := 2;
		c: integer := 3;
		m: integer := 7);
	port(
		rst, St, clk: in STD_LOGIC;
		LED: out STD_LOGIC_VECTOR(7 downto 0)
		);
end wrapper;


architecture behav of wrapper is
	component aprox_toplevel is
	generic(
		width: natural := 8;
		a: integer := 1;
		b: integer := 2;
		c: integer := 3;
		m: integer := 7);
	port(
		reset_i: in std_logic;
		clock_i: in std_logic;
		x_i: in std_logic;
		y_o: out std_logic;
		count: out std_logic_vector(width-1 downto 0));
	end component;
	
	constant N : INTEGER := 17;
	signal COUNT_INT : STD_LOGIC_VECTOR(N-1 downto 0);
	
	signal s1, s2, s3, St_in, clk_out: std_logic;
	signal y_out : std_logic;
begin
	KVAD1: aprox_toplevel
	generic map(
		width => width,
		a => a,
		b => b,
		c => c,
		m => m
		)
	port map(
		reset_i => rst,
		clock_i => clk,
		x_i => St_in,
		y_o => y_out,
		count => LED);	
	
	process(rst, clk) 
	begin
		if rst = '1' then
			COUNT_INT <= (others => '0');
		elsif clk'event and clk = '1' then
			COUNT_INT <= COUNT_INT + 1;
		end if;
	end process;
	
	clk_out <= '1' when COUNT_INT(N-1) = '1' else '0';
	
	process (clk_out)
	begin
		if (clk_out'event and clk_out = '1') then	
			s1<=St;
			s2<=s1;
			s3<=s2;
		end if;
	end process;
	
	St_in <= s1 and s2 and not s3;		
end behav;
