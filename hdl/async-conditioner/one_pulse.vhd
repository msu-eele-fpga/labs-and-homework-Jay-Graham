library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity one_pulse is
    port (
        clk   : in  std_ulogic;
        rst   : in  std_ulogic;
        input : in  std_ulogic;
        pulse : out std_ulogic
    );
end entity one_pulse;

architecture one_pulse_arch of one_pulse is

    signal prev_input : std_logic := '0';
    signal pulse_temp : std_logic := '0';

begin

    process (clk, rst)
    begin   
        if rst = '1' then
            prev_input <= '0';
            pulse_temp <= '0';
        elsif rising_edge(clk) then
            if input = '1' and prev_input = '0' then
                pulse_temp <= '1';
            else
                pulse_temp <= '0'; 
            end if;
            prev_input <= input;
        end if;
    end process;

    pulse <= pulse_temp;

end architecture one_pulse_arch;