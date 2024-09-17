library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_conditioner_tb is
end entity async_conditioner_tb;

architecture async_conditioner_tb_arch of async_conditioner_tb is

    component async_conditioner is
        port (
            clk   : in  std_ulogic;
            rst   : in  std_ulogic;
            async : in  std_ulogic;
            sync  : out std_ulogic
        );
    end component;

    signal clk_tb    : std_ulogic := '0';
    signal rst_tb    : std_ulogic := '0';
    signal async_tb : std_ulogic := '0';
    signal sync_tb   : std_ulogic;

    constant CLK_PERIOD : time := 20ns;

begin

    dut: async_conditioner
        port map (
            clk   => clk_tb,
            rst   => rst_tb,
            async => async_tb,
            sync  => sync_tb
        );

    clk_process : process
    begin
        clk_tb <= not clk_tb;
        wait for CLK_PERIOD / 2;
    end process;

    stimulus: process
    begin
        rst_tb <= '1';
        async_tb <= '0';
        wait for CLK_PERIOD * 2;

        rst_tb <= '0';
        wait for CLK_PERIOD * 2;

        -- Test Case 1: Initial State Check
        assert sync_tb = '0'
            report "Initial State Check Failed: Output should be low when input is low"
            severity error;
        wait for CLK_PERIOD * 2;

        -- Test Case 2: Input Transition
        async_tb <= '1';
        wait for CLK_PERIOD;
        assert sync_tb = '1'
            report "Input Transition Test Failed: Output pulse should be high when input transitions from L2H"
            severity error;
        wait for CLK_PERIOD;
        async_tb <= '0';
        wait for CLK_PERIOD * 2;

        -- Test Case 3: Input Stability
        async_tb <= '1';
        wait for CLK_PERIOD;
        assert sync_tb = '0'
            report "Input Stability Test Failed: Output should not pulse again when input remains high"
            severity error;
        wait for CLK_PERIOD * 2;

        -- End of simulation
        wait;

    end process;

end architecture async_conditioner_tb_arch;