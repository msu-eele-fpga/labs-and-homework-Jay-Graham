library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity async_conditioner_tb is
end entity async_conditioner_tb;

architecture async_conditioner_tb_arch of async_conditioner_tb is

    component async_conditioner is
        port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            async : in  std_logic;
            sync  : out std_logic
        );
    end component;

    signal clk_tb    : std_logic := '0';
    signal rst_tb    : std_logic := '0';
    signal async_tb : std_logic := '0';
    signal sync_tb   : std_logic;
    signal debounced_signal : std_logic;

    constant CLK_PERIOD : time := 20 ns;
    constant DEBOUNCE_DELAY : time := CLK_PERIOD * 4; -- Time for debouncer and one-pulse generator

begin

    -- Instantiate the DUT
    dut: async_conditioner
        port map (
            clk   => clk_tb,
            rst   => rst_tb,
            async => async_tb,
            sync  => sync_tb
        );

    -- Clock process
    clk_process : process
    begin
        clk_tb <= not clk_tb;
        wait for CLK_PERIOD / 2;
    end process;

    -- Stimulus process for testing signal transitions
    stimulus: process
    begin
        -- Apply reset
        rst_tb <= '1';
        async_tb <= '0';
        wait for CLK_PERIOD * 2;
        rst_tb <= '0';
        wait for CLK_PERIOD * 2;

        -- Test Case 1: Async to Sync
        async_tb <= '1';
        wait for CLK_PERIOD;
        assert sync_tb = '1'
            report "Async to Sync Test Failed: Sync output should be high when async input is high."
            severity error;

        wait for CLK_PERIOD;
        async_tb <= '0';
        wait for CLK_PERIOD;
        assert sync_tb = '0'
            report "Async to Sync Test Failed: Sync output should be low when async input is low."
            severity error;

        -- Allow time for debouncer and one-pulse generator
        wait for DEBOUNCE_DELAY;

        -- Test Case 2: Sync to Debounced
        async_tb <= '1';
        wait for CLK_PERIOD * 5; -- Ensure debounce time is met
        assert debounced_signal = '1'
            report "Sync to Debounced Test Failed: Debounced output should be high when sync signal is high."
            severity error;

        async_tb <= '0';
        wait for CLK_PERIOD * 5; -- Ensure debounce time is met
        assert debounced_signal = '0'
            report "Sync to Debounced Test Failed: Debounced output should be low when sync signal is low."
            severity error;

        -- Check for pulse generation
        wait for DEBOUNCE_DELAY;
        
        -- Test Case 3: Debounced to Pulse
        async_tb <= '1';
        wait for CLK_PERIOD * 2; -- Time for debouncer and one-pulse to stabilize
        assert sync_tb = '1'
            report "Debounced to Pulse Test Failed: One-pulse output should be high when debounced input is high."
            severity error;

        wait for CLK_PERIOD;
        async_tb <= '0';
        wait for CLK_PERIOD * 2;
        assert sync_tb = '0'
            report "Debounced to Pulse Test Failed: One-pulse output should be low when debounced input is low."
            severity error;

        -- End of simulation
        std.env.finish;
    end process;

end architecture async_conditioner_tb_arch;
