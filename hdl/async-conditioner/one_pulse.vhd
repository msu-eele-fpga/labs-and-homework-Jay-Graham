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

