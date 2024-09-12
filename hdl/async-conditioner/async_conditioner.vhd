library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_conditioner is
    port (
        clk   : in  std_ulogic;
        rst   : in  std_ulogic;
        async : in  std_ulogic;
        sync  : out std_ulogic
    );
end entity async_conditioner;