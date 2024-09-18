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
    signal state : state_type := sWait;
    signal counter : integer := 0;
    constant COUNTER_LIMIT : integer := integer(debounce_time / clk_period) - 1;

begin

    DEBOUNCER_LOGIC : process(clk, rst)
    begin
        if rst = '1' then
            state <= sWait;
            counter <= 0;
            debounced <= '0';
        elsif rising_edge(clk) then
            case state is
                when sWait =>
                    debounced <= '0';
                    if input = '1' then
                        state <= sHigh;
                    end if;
                when sHigh =>
                    debounced <= '1';
                    if counter = COUNTER_LIMIT then
                        if input = '0' then
                            state <= sLow;
                            counter <= 0;
                        end if;
                    else
                        counter <= counter + 1;
                    end if;
                when sLow =>
                    debounced <= '0';
                    if counter = COUNTER_LIMIT then
                        if input = '0' then
                            state <= sWait;
                            counter <= 0;
                        end if;
                    else
                        counter <= counter + 1;
                    end if;
                when others =>
                    state <= sWait;
                    counter <= 0;
                    debounced <= '0';
            end case;
        end if;
    end process;

    --OUTPUT_LOGIC : process(state, input)
    --begin
    --    case state is
    --        when sWait => 
    --            debounced <= '0';
    --        when sHigh =>
    --            debounced <= '1';
    --        when sLow =>
    --            debounced <= '0';
    --        when others =>
    --            debounced <= '0';
    --    end case;
    --end process;

end architecture debouncer_arch;