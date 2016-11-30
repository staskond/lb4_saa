library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;


entity aprox_toplevel is
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
end aprox_toplevel;


architecture struct of aprox_toplevel is
	-- Component declaration of the "aproximator(struct)" unit defined in
	-- file: "./src/aproximator.vhd"
	component aproximator
		generic(
			width : NATURAL := 8; 
			a: integer := 1;
			b: integer := 2;
			c: integer := 3;
			m: integer := 7);
		port(
			x_i : in std_logic;
			ready_o : out std_logic;
			clock_i : in std_logic;
			reset_i : in std_logic;
			y_o : out std_logic;
			sum_o: out std_logic_vector(width-1 downto 0));
	end component;
	
	-- Component declaration of the "inputbuffer(beh)" unit defined in
	-- file: "./src/inputbuffer.vhd"
	component aprox_inputbuffer
		generic(
			width : NATURAL := 8);
		port(
			x_i : in std_logic;
			clock_i : in std_logic;
			reset_i : in std_logic;
			ready_i : in std_logic;
			y_o : out std_logic);
	end component;
	
	-- Component declaration of the "outputbuffer(beh)" unit defined in
	-- file: "./src/outputbuffer.vhd"
	component aprox_outputbuffer
		port(
			clock_i : in std_logic;
			reset_i : in std_logic;
			en_i : in std_logic;
			y_o : out std_logic);
	end component;
	
	signal inputbuffer_out, aprox_out, ready, y_t: std_logic;  
	
	signal count_t: std_logic_vector(width-1 downto 0);
	signal sum_t: std_logic_vector(width-1 downto 0);
	
	
begin	   
	
	y_o <= y_t;
	
	InputBuffer_1 : aprox_inputbuffer
	generic map(
		width => width
		)
	port map(
		x_i => x_i,
		clock_i => clock_i,
		reset_i => reset_i,
		ready_i => ready,
		y_o => inputbuffer_out
		);
	
	Aproximator_1 : aproximator
	generic map(
		width => width,
		a => a,
		b => b,
		c => c,
		m => m
		)
	port map(
		x_i => inputbuffer_out,
		ready_o => ready,
		clock_i => clock_i,
		reset_i => reset_i,
		y_o => aprox_out,
		sum_o => sum_t
		);
	
	
	OutputBuffer_1 : aprox_outputbuffer
	port map(
		clock_i => clock_i,
		reset_i => reset_i,
		en_i => aprox_out,
		y_o => y_t
		);	  
	
	process(clock_i, reset_i)
	begin
		if reset_i = '1' then
			count_t <= (others => '0');
		else
			if rising_edge(clock_i) then
				if aprox_out = '1' then
					count_t <= count_t + 1;
				end if;
			end if;
		end if;
		
	end process;
	
	count <= count_t;
	
end struct;
