library ieee;
use ieee.std_logic_1164.all;


entity aprox_outputbuffer is
	port(
		clock_i: in std_logic;
		reset_i: in std_logic;
		en_i: in std_logic;
		y_o: out std_logic);
end aprox_outputbuffer;


architecture beh of aprox_outputbuffer is
	signal t: std_logic;
begin
	
	y_o <= clock_i and t;
	
	process(clock_i, reset_i)
	begin
		if reset_i = '1' then
			t <= '0';
		else
			if rising_edge(clock_i) then
				t <= en_i;
			end if;
		end if;
	end process;
	
end beh;
