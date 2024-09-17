library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
    generic (
        clk_period    : time := 20 ns;
        debounce_time : time
    );
    port (
        clk           : in  std_ulogic;
        rst           : in  std_ulogic;
        input         : in  std_ulogic;
        debounced     : out std_ulogic
    );
end entity debouncer;

architecture debouncer_arch of debouncer is

    type state_type is (sWait, sHigh, sLow);
    signal current_state, next_state : state_type;
    signal counter : integer := 0;
    constant COUNTER_LIMIT : integer := integer(debounce_time / clk_period);

begin

    STATE_MEMORY : process(clk, rst)
    begin
        if rst = '1' then
            current_state <= sWait;
            counter <= 0;
        elsif rising_edge(clk) then
            current_state <= next_state;
            if current_state = sHigh or current_state = sLow then
                if counter < COUNTER_LIMIT then
                    counter <= counter + 1;
                end if;
            else
                counter <= 0;
            end if;
        end if;
    end process;

    NEXT_STATE_LOGIC : process(current_state, input)
    begin
        case current_state is
            when sWait =>
                if input = '1' then
                    next_state <= sHigh;
                else
                    next_state <= sWait;
                end if;
            when sHigh =>
                if counter = COUNTER_LIMIT then
                    next_state <= sLow;
                else   
                    next_state <= sHigh;
                end if;
            when sLow =>
                if input = '1' then
                    if counter = COUNTER_LIMIT then
                        next_state <= sLow;
                    else
                        next_state <= sWait;
                    end if;
                else
                    next_state <= sWait;
                end if;
            when others =>
                next_state <= sWait;
        end case;
    end process;

    OUTPUT_LOGIC : process(current_state, input)
    begin
        case current_state is
            when sWait => 
                debounced <= '0';
            when sHigh =>
                debounced <= '1';
            when sLow =>
                debounced <= '0';
            when others =>
                debounced <= '0';
        end case;
    end process;

end architecture debouncer_arch;
