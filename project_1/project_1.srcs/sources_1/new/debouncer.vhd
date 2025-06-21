library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity button_debouncer is
    port (
        clk_slow    : in std_logic;
        button_in   : in std_logic;
        button_out  : out std_logic
    );
end button_debouncer;

architecture behavioral of button_debouncer is
    type deb_states is (deb_ini, shift_state);
    signal deb_state   : deb_states;
    signal count_shift : integer := 0;
begin
    process (clk_slow)
    begin
        if rising_edge(clk_slow) then
            case(deb_state) is
                when deb_ini =>
                    if (button_in = '1') then
                        deb_state <= shift_state;
                    else
                        deb_state <= deb_ini;
                    end if;
                    button_out <= '0';
                    
                when shift_state =>
                    if (count_shift = 8) then
                        count_shift <= 0;
                        if (button_in = '1') then
                            button_out <= '1';
                        end if;
                        deb_state <= deb_ini;
                    else
                        count_shift <= count_shift + 1;
                    end if;
            end case;
        end if;
    end process;
end behavioral;