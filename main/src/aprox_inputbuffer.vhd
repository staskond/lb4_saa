library ieee;
use ieee.std_logic_1164.all;				 			 
use ieee.std_logic_arith.all;	  
use ieee.std_logic_unsigned.all;

entity aprox_inputbuffer is
	generic(
		width: natural := 8);
	port(
		x_i: in std_logic;
		clock_i: in std_logic;
		reset_i: in std_logic;
		ready_i: in std_logic;
		y_o: out std_logic);
end aprox_inputbuffer;


architecture beh of aprox_inputbuffer is 
	
	signal counter: std_logic_vector(width-1 downto 0);
	
	-- Value of x_i on the prevoius cycle
	signal prev_x: std_logic;			 
	
	-- Detected impulse
	signal impulse: std_logic;
	
begin
	
	y_o <= impulse;
	
	-- New impulse detector
	process(reset_i, clock_i)
	begin
		if (reset_i = '1') then
			prev_x <= '0';
		else
			if (rising_edge(clock_i)) then
				prev_x <= x_i;
			end if;
		end if;
	end process;
	
	impulse <= not prev_x and x_i;
	
end architecture;