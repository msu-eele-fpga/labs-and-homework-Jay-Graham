library ieee;
use ieee.std_logic_1164.all;
use work.print_pkg.all;
use work.assert_pkg.all;
use work.tb_pkg.all;

entity timed_counter_tb is
end entity timed_counter_tb;

architecture testbench of timed_counter_tb is

    component timed_counter is
        generic(
            clk_period : time;
            count_time : time
        );
        port (
            clk    : in  std_ulogic;
            enable : in  boolean;
            done   : out boolean
        );
    end component timed_counter;

    signal clk_tb : std_ulogic := '0';

    signal enable_100ns_tb : boolean := false;
    signal done_100ns_tb   : boolean;
    signal enable_240ns_tb : boolean := false;
    signal done_240ns_tb   : boolean;

    constant HUNDRED_NS : time := 100ns;
    constant TWO_HUNDRED_FORTY_NS : time := 240ns;

    procedure predict_counter_done (
        constant count_time : in time;
        signal enable       : in boolean;
        signal done         : in boolean;
        constant count_iter : in natural
    ) is

    begin

        if enable then
            if count_iter < (count_time / CLK_PERIOD) then
                assert_false(done, "counter not done");
            else 
                assert_true(done, "counter is done");
            end if;
        end if;
    
    end procedure predict_counter_done;

begin

    dut_100ns_counter : component timed_counter
        generic map(
            clk_period => CLK_PERIOD,
            count_time => HUNDRED_NS
        )
        port map (
            clk    => clk_tb,
            enable => enable_100ns_tb,
            done   => done_100ns_tb
        );

    dut_240ns_counter : component timed_counter
        generic map(
            clk_period => CLK_PERIOD,
            count_time => TWO_HUNDRED_FORTY_NS
        )
        port map (
            clk    => clk_tb,
            enable => enable_240ns_tb,
            done   => done_240ns_tb
        );

    clk_tb <= not clk_tb after CLK_PERIOD / 2;

    stimuli_and_checker : process is
    begin
	
        -- test 100ns timer when it's enabled
        print("testing 100ns timer: enabled");
        wait_for_clock_edge(clk_tb);
        enable_100ns_tb <= true;

        -- loop for the number of clock cycles that is equal to the timer's clk_period
        for i in 0 to (HUNDRED_NS / CLK_PERIOD) loop
            wait_for_clock_edge(clk_tb);
            predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
        end loop;

        -- test 100ns timer when it's disabled for two periods
        print("testing 100ns timer: disabled for two periods");
        wait_for_clock_edge(clk_tb);
        enable_100ns_tb <= false;

        -- loop for 2 * count_time periods to ensure 'done' never assert_false
        for i in 0 to 2 * (HUNDRED_NS / CLK_PERIOD) loop
            wait_for_clock_edge(clk_tb);
            assert_false(done_100ns_tb, "counter done unexpextedly while disabled");
        end loop;

        -- test 100ns timer: enabled for multiple periods
        print("testing 100ns timer: enabled for multiple periods");
        wait_for_clock_edge(clk_tb);
        enable_100ns_tb <= true;

        for j in 1 to 3 loop
            for i in 0 to (HUNDRED_NS / CLK_PERIOD) loop
                wait_for_clock_edge(clk_tb);
                predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
            end loop;
        end loop;

        enable_100ns_tb <= false;

        -- test 240ns timer when its enabled
        print("testing 240ns timer: enabled");
        wait_for_clock_edge(clk_tb);
        enable_240ns_tb <= true;

        -- loop for the number of clock cycles that is equal to the timer's clk_period
        for i in 0 to (TWO_HUNDRED_FORTY_NS / CLK_PERIOD) loop
            wait_for_clock_edge(clk_tb);
            predict_counter_done(TWO_HUNDRED_FORTY_NS, enable_240ns_tb, done_240ns_tb, i);
        end loop;
        enable_240ns_tb <= false;

        -- test 240ns timer when its disabled for two periods
        print("testing 240ns timer: disabled for two periods");
        wait_for_clock_edge(clk_tb);
        enable_240ns_tb <= false;

        -- loop for 2 * count_time periods to ensure 'done' never assert_false
        for i in 0 to 2 * (TWO_HUNDRED_FORTY_NS / CLK_PERIOD) loop
            wait_for_clock_edge(clk_tb);
            assert_false(done_240ns_tb, "counter done unexpextedly while disabled");
        end loop;

        -- test 240ns timer: enabled for multiple periods
        print("testing 240ns timer: enabled for multiple periods");
        wait_for_clock_edge(clk_tb);
        enable_240ns_tb <= true;

        for j in 1 to 3 loop
            for i in 0 to (TWO_HUNDRED_FORTY_NS / CLK_PERIOD) loop
                wait_for_clock_edge(clk_tb);
                predict_counter_done(TWO_HUNDRED_FORTY_NS, enable_240ns_tb, done_240ns_tb, i);
            end loop;
        end loop;

        enable_240ns_tb <= false;

        -- test bench is done
        std.env.finish;

    end process stimuli_and_checker;

end architecture testbench;

