library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
port (
    clk   : in  std_ulogic;
    async : in  std_ulogic;
    sync  : out std_ulogic
);
end entity synchronizer;

-- synchronizer input
signal async : std_logic;
-- flip flop connector
signal mid   : std_logic;
-- synchronizer output
signal sync  : std_logic;
-- clock signal
signal clk   : std_logic;

process(clk)
begin
    if rising_edge(clk) then
        mid <= async;
        synch <= mid;
    end if;
end process;