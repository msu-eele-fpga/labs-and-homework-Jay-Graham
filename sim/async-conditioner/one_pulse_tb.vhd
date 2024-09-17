library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity one_pulse_tb is
end entity one_pulse_tb;

architecture one_pulse_tb_arch of one_pulse_tb is

    component one_pulse is
        port (
            clk   : in  std_ulogic;
            rst   : in  std_ulogic;
            input : in  std_ulogic;
            pulse : out std_ulogic
        );
    end component;

    signal clk_tb   : std_ulogic := '0';
    signal rst_tb   : std_ulogic := '0';
    signal input_tb : std_ulogic := '0';
    signal pulse_tb : std_ulogic;

    constant CLK_PERIOD : time := 20 ns;

begin

    dut: one_pulse
        port map (
            clk => clk_tb,
            rst => rst_tb,
            input => input_tb,
            pulse => pulse_tb
        );

    clk_process : process
    begin
        clk_tb <= not clk_tb;
        wait for CLK_PERIOD / 2;
    end process;

    stimulus: process
    begin
        rst_tb <= '0';
        input_tb <= '0';
        wait for CLK_PERIOD * 2;

        -- Test Case 1: Single pulse when input transitions from L to H
        input_tb <= '1';
        wait for CLK_PERIOD;
	input_tb <= '0';
        assert pulse_tb = '1'
            report "Test Case 1 Failed: Pulse was not generated on rising edge"
            severity error;
        wait for CLK_PERIOD * 2;

        -- Test Case 2: No additional pulse when input remains high
        input_tb <= '1';
        wait for CLK_PERIOD;
        assert pulse_tb = '1'
            report "Test Case 2 Failed: Pulse was not generated on rising edge"
            severity error;
        wait for CLK_PERIOD;
	assert pulse_tb = '0'
            report "Test Case 2 Failed: Pulse did not go low after 1 clock cycle"
            severity error;
	wait for CLK_PERIOD;	
	assert pulse_tb = '0'
            report "Test Case 2 Failed: 2nd pulse was generated on one input high"
            severity error;
	input_tb <= '0';
        wait for CLK_PERIOD * 2;

        --Test Case 3: Reset Behavior
	input_tb <= '1';
        rst_tb <= '1';
        wait for CLK_PERIOD;
        assert pulse_tb = '0'
            report "Test Case 3 Failed: Pusle was generated during reset"
            severity error;
	input_tb <= '0';
        rst_tb <= '0';
        wait for CLK_PERIOD;

        -- End of simulation
        wait;

    end process;

end architecture one_pulse_tb_arch;
