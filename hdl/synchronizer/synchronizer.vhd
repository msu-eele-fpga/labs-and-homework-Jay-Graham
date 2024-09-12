library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
port (
    clk   : in  std_ulogic;
    async : in  std_ulogic;
    sync  : out std_ulogic
);
end entity synchronizer;

architecture synchronizer_arch of synchronizer is
    -- internal signal for flip-flop connection
    signal mid   : std_logic; 
begin

    process(clk)
    begin
        if rising_edge(clk) then
            mid <= async;
            sync <= mid;
        end if;
    end process;

end architecture synchronizer_arch;