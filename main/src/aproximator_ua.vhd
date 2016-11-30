library ieee;
use ieee.std_logic_1164.all;


entity aproximator_ua is
	port(
		clock_i: in std_logic;
		reset_i: in std_logic;
		x_i: in std_logic;
		y_o: out std_logic;
		ready_o: out std_logic;
		sum_less_zero_i: in std_logic;
		sum_plus_a_o: out std_logic;
		sum_minus_b_o: out std_logic;
		states: out std_logic_vector(1 downto 0));
end aproximator_ua;


architecture beh of aproximator_ua is
	
	type state_type is (a_0, a_1, a_2); 
	
	signal state, next_state: state_type;
	
	signal control: std_logic_vector(3 downto 0);
	
begin
	
	process(clock_i, reset_i)
	begin
		if (reset_i = '1') then
			state <= a_0;
		else
			if (rising_edge(clock_i)) then	 
				state <= next_state;
			end if;
		end if;
	end process;
	
	
	process(state, x_i, sum_less_zero_i)
	begin
		case (state) is
			when a_0 =>
				if x_i = '1' then
					next_state <= a_1;
				else
					next_state <= a_0;
			end if;
			when a_1 =>
				if sum_less_zero_i = '1' then
					next_state <= a_0;
				else
					next_state <= a_2;
			end if;
			when a_2 =>
				if sum_less_zero_i = '1' then
					next_state <= a_0;
				else
					next_state <= a_2;
			end if;
			when others =>
			next_state <= a_0;
		end case;
	end process;
	
	(ready_o, sum_plus_a_o, sum_minus_b_o, y_o) <= control;
	
	with state select
	control <= "1000" when a_0,
	"0100" when a_1,
	"0011" when a_2,
	"0000" when others;
	
	with state select
	states <= "11" when a_0,
	"10" when a_1,
	"01" when a_2,
	"00" when others;
	
end beh;
