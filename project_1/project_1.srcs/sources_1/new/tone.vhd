library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity tone_generator is
    port (
        clk     : in std_logic;
        enable  : in std_logic;
        tone    : out std_logic
    );
end tone_generator;

architecture behavioral of tone_generator is
    -- For a 100MHz clock and 440Hz tone (A4 note):
    -- Counter max = 100MHz / (2 * 440Hz) = 113636
    constant max_count : integer := 113636;  -- This will create a 440Hz tone
    signal count : integer range 0 to max_count := 0;
    signal tone_temp : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                if count = max_count then
                    count <= 0;
                    tone_temp <= not tone_temp;  -- Toggle the output
                else
                    count <= count + 1;
                end if;
            else
                tone_temp <= '0';
                count <= 0;
            end if;
        end if;
    end process;

    tone <= tone_temp;
end behavioral;