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

architecture async_conditioner_arch of async_conditioner is

    component synchronizer is
        port (
            clk   : in  std_ulogic;
            async : in  std_ulogic;
            sync  : out std_ulogic
        );
    end component;

    component debouncer is
        port (
            clk       : in  std_ulogic;
            rst       : in  std_ulogic;
            input     : in  std_ulogic;
            debounced : out std_ulogic
        );
    end component;

    component one_pulse is
        port (
            clk   : in  std_ulogic;
            rst   : in  std_ulogic;
            input : in  std_ulogic;
            pulse : out std_ulogic
        );
    end component;

    signal sync_signal      : std_ulogic := '0';
    signal debounced_signal : std_ulogic := '0';

begin

    synchronizer_inst : synchronizer
        port map (
            clk   => clk,
            async => async,
            sync  => sync_signal
        );

    debouncer_inst : debouncer
        generic map (
            clk_period    => 20 ns,
            debounce_time => 100 ms
        )
        port map (
            clk       => clk,
            rst       => rst,
            input     => sync_signal,
            debounced => debounced_signal
        );

    one_pulse_inst : one_pulse
        port map (
            clk   => clk,
            rst   => rst,
            input => debounced_signal,
            pulse => sync
        );

end architecture async_conditioner_arch;
