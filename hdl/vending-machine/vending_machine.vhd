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
    signal next_state     : state_type;
    signal current_amount : natural range 0 to 15 := 0;

begin

    process (clk)
    begin
        if rising_edge(clk)
            if rst = '1' then
                state <= S0; 
                current_ammount <= 0;
            else    
                state <= next_state;
            end if;
        end if;
    end process

    process (state, nickel, dime)
    begin
        next_state <= state;
        dispense <= '0';
        current_amount <= '0';

        case state is
            when S0 =>
                current_ammount <= 0;
                if nickel = '1' and dime = '0' then
                    next_state <= S5;
                elsif dime = '0' then
                    next_state <= S10;
                end if;
            when S5 =>
                current_ammount <= 5;
                if nickel = '1' and dime = '0' then
                    next_state <= S10;
                elsif dime = '1' then
                    next_state <= S15;
                end if;
            when S10 =>
                current_ammount <= 10;
                if nickel = '1' and dime = '0' then
                    next_state <= S15;
                elsif dime = '1' then
                    next_state <= S20;
                end if;
            when S15 =>
                current_ammount <= 15;
                dispense <= '1'; 
                next_state <= S0;
            when S20 =>
                current_ammount <= 15;
                dispense <= '1';
                next_state <= S0;
            when others =>
                next_state <= S0;
        end case;
    end process;

    amount <= current_ammount;

end architecture vending_machine_arch;
