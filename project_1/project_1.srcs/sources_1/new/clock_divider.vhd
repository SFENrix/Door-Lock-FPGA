library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity clock_divider is
    port (
        clk      : in std_logic;
        clk_slow : out std_logic
    );
end clock_divider;

architecture behavioral of clock_divider is
    signal count_slow : integer := 0;
begin
    process (clk) 
    begin
        if rising_edge(clk) then
            if count_slow = 1499999 then
                clk_slow <= '1';
                count_slow <= 0;
            else
                clk_slow <= '0';
                count_slow <= count_slow + 1;
            end if;
        end if;
    end process;
end behavioral;