library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;


entity aproximator_oa is
	generic(
		width: natural := 8;
		a: integer := 1;  
		b: integer := 2; 
		c: integer := 3;
		m: integer := 7
		);
	port(
		clock_i: in std_logic;
		reset_i: in std_logic;
		sum_plus_a_i: in std_logic;
		sum_minus_b_i: in std_logic;
		sum_less_zero_o: out std_logic;
		sum_o: out std_logic_vector(width-1 downto 0));
end aproximator_oa;


architecture beh of aproximator_oa is
	
	signal sum: std_logic_vector(width-1 downto 0);
	signal counter: std_logic_vector(width-1 downto 0);
	
begin
	
	sum_o <= sum;
	
	sum_less_zero_o <= '1' when (sum < 0) else '0';
	
	process (clock_i, reset_i)
	begin
		if (reset_i = '1') then
			sum <= CONV_STD_LOGIC_VECTOR(c - m, width); 
			counter <= CONV_STD_LOGIC_VECTOR(a+b, width);
		else
			if (falling_edge(clock_i)) then
				if (sum_plus_a_i = '1') then 
					sum <= sum + counter + counter; 
					counter <= counter + 2*a;	  -- add our constant
				else
					if (sum_minus_b_i = '1') then
						sum <= sum - 2*m; 
					end if;
				end if;
			end if;
		end if;
	end process;
	
end beh;
