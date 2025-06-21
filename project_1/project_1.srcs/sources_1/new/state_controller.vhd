library ieee;
use ieee.std_logic_1164.all;

entity state_controller is
    port (
        clk_slow    : in std_logic;
        reset_btn   : in std_logic;
        enter_btn   : in std_logic;
        override    : in std_logic;
        switches    : in std_logic_vector(3 downto 0);
        state      : out std_logic_vector(2 downto 0);
        usr_in     : out std_logic_vector(15 downto 0);
        tone_enable : out std_logic
    );
end state_controller;

architecture behavioral of state_controller is
    type states is (ini, a, b, c, d, res);
    signal current_state : states;
    signal usr_in_reg : std_logic_vector(15 downto 0);
    signal auto_lock_counter : integer range 0 to 200 := 0;  
    signal auto_lock_active : std_logic := '0';
    signal tone_counter : integer range 0 to 67 := 0;  
    constant keys : std_logic_vector(15 downto 0) := "0001001000110100";
    
begin
    
    process(current_state)
    begin
        case current_state is
            when ini => state <= "000";
            when a   => state <= "001";
            when b   => state <= "010";
            when c   => state <= "011";
            when d   => state <= "100";
            when res => state <= "101";
        end case;
    end process;

    
    process(clk_slow)
    begin
        if rising_edge(clk_slow) then
            
            if current_state = res then
                if auto_lock_counter < 200 then
                    auto_lock_counter <= auto_lock_counter + 1;
                    auto_lock_active <= '0';
                else
                    auto_lock_active <= '1';
                end if;
                
                
                if usr_in_reg = keys then
                    if tone_counter < 67 then
                        tone_enable <= '1';
                        tone_counter <= tone_counter + 1;
                    else
                        tone_enable <= '0';
                    end if;
                else
                    tone_enable <= '0';
                    tone_counter <= 0;
                end if;
            else
                auto_lock_counter <= 0;
                auto_lock_active <= '0';
                tone_enable <= '0';
                tone_counter <= 0;
            end if;
        end if;
    end process;

    
    process (clk_slow, reset_btn)
    begin
        if rising_edge(clk_slow) then
            if reset_btn = '1' or auto_lock_active = '1' then
                usr_in_reg <= (others => '0');
                current_state <= ini;
                
            elsif override = '1' then
                usr_in_reg <= keys;
                current_state <= res;
                
            elsif enter_btn = '1' then
                case current_state is
                    when ini =>
                        usr_in_reg(15 downto 12) <= switches;
                        current_state <= a;
                    when a =>
                        usr_in_reg(11 downto 8) <= switches;
                        current_state <= b;
                    when b =>
                        usr_in_reg(7 downto 4) <= switches;
                        current_state <= c;
                    when c =>
                        usr_in_reg(3 downto 0) <= switches;
                        current_state <= d;
                    when d =>
                        current_state <= res;
                    when res => 
                        current_state <= res;
                end case;
            end if;
        end if;
    end process;

    usr_in <= usr_in_reg;
end behavioral;