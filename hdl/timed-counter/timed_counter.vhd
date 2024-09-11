library ieee;
use ieee.std_logic_1164.all;

entity timed_counter is
    generic (
        clk_period : time := 20 ns;
        count_time : time := 100 ns
    );
    port (
        clk    : in  std_ulogic;
        enable : in  boolean;
        done   : out boolean
    );
end entity timed_counter;

architecture timed_counter_arch of timed_counter is

    constant COUNTER_LIMIT : integer := integer(count_time * 1/clk_period);
    signal   count         : integer range 0 to COUNTER_LIMIT := 0;

begin

    counter: process(clk)
    begin
        if rising_edge(clk) then
            if enable then
                if (count < COUNTER_LIMIT) then
                    count <= count + 1;
		    done <= False;
		elsif (count = COUNTER_LIMIT) then
                    done <= True;
	  	    count <= 0;
		end if;
	    else
		count <= 0;
		done <= False;
	    end if;
	end if;
    end process;

end architecture timed_counter_arch;