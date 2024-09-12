library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine is
    port(
        clk      : in  std_ulogic;
        rst      : in  std_ulogic;
        nickel   : in  std_ulogic;
        dime     : in  std_ulogic;
        dispense : out std_ulogic;
        amount   : out natural range 0 to 15
    );
end entity vending_machine;

architecture vending_machine_arch of vending_machine is

    type state_type is (S0, S5, S10, S15, S20);

    signal state           : state_type;
    signal next_state      : state_type;
    signal current_amount  : natural range 0 to 15 := 0;
    signal next_amount     : natural range 0 to 15 := 0;  -- Temporary signal for next amount

begin

    -- State register process (synchronous)
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= S0; 
                current_amount <= 0;  -- Ensure amount is reset to 0
            else    
                state <= next_state;
                current_amount <= next_amount;  -- Update current_amount only here
            end if;
        end if;
    end process;

    -- Next state logic and output logic (combinational)
    process (state, nickel, dime)
    begin
        next_state <= state;
        dispense <= '0';
        next_amount <= current_amount;  -- Start by assigning the current amount to next_amount

        case state is
            when S0 =>
                -- Ensure amount is 0 when in S0 state
                if nickel = '1' and dime = '0' then
                    next_state <= S5;
                    next_amount <= 5;
                elsif dime = '1' then
                    next_state <= S10;
                    next_amount <= 10;
                end if;
            when S5 =>
                if nickel = '1' and dime = '0' then
                    next_state <= S10;
                    next_amount <= 10;
                elsif dime = '1' then
                    next_state <= S15;
                    next_amount <= 15;
                end if;
            when S10 =>
                if nickel = '1' and dime = '0' then
                    next_state <= S15;
                    next_amount <= 15;
                elsif dime = '1' then
                    next_state <= S20;
                    next_amount <= 15;  -- Cap at 15 since the machine doesn't return change
                end if;
            when S15 =>
                dispense <= '1';
                next_state <= S0;
                next_amount <= 0;  -- Reset amount after dispensing
            when S20 =>
                dispense <= '1';
                next_state <= S0;
                next_amount <= 0;  -- Reset amount after dispensing
            when others =>
                next_state <= S0;
                next_amount <= 0;  -- Ensure reset on any other state
        end case;
    end process;

    -- Output amount
    amount <= current_amount;

end architecture vending_machine_arch;

