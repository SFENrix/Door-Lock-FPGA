library ieee;
use ieee.std_logic_1164.all;

entity lock is
    port (
        reset_btn   : in std_logic;
        enter_btn   : in std_logic;
        override    : in std_logic;
        segments    : out std_logic_vector(6 downto 0);
        digits      : out std_logic_vector(7 downto 0);
        switches    : in std_logic_vector(3 downto 0);
        leds        : out std_logic_vector(15 downto 0);
        tone_out    : out std_logic;
        clk         : in std_logic
    );
end lock;

architecture behavioral of lock is

    component clock_divider is
        port (
            clk      : in std_logic;
            clk_slow : out std_logic
        );
    end component;

    component button_debouncer is
        port (
            clk_slow   : in std_logic;
            button_in  : in std_logic;
            button_out : out std_logic
        );
    end component;

    component state_controller is
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
    end component;

    component tone_generator is
        port (
            clk     : in std_logic;
            enable  : in std_logic;
            tone    : out std_logic
        );
    end component;

    component display_controller is
        port (
            clk      : in std_logic;
            state    : in std_logic_vector(2 downto 0);
            usr_in   : in std_logic_vector(15 downto 0);
            keys     : in std_logic_vector(15 downto 0);
            segments : out std_logic_vector(6 downto 0);
            digits   : out std_logic_vector(7 downto 0);
            leds     : out std_logic_vector(15 downto 0)
        );
    end component;

    signal clk_slow : std_logic;
    signal debounced_enter : std_logic;
    signal current_state : std_logic_vector(2 downto 0);
    signal usr_in : std_logic_vector(15 downto 0);
    signal tone_enable : std_logic;
    constant keys : std_logic_vector(15 downto 0) := "0001001000110100";

begin
    clk_div: clock_divider
        port map (
            clk => clk,
            clk_slow => clk_slow
        );

    btn_debouncer: button_debouncer
        port map (
            clk_slow => clk_slow,
            button_in => enter_btn,
            button_out => debounced_enter
        );

    state_ctrl: state_controller
        port map (
            clk_slow => clk_slow,
            reset_btn => reset_btn,
            enter_btn => debounced_enter,
            override => override,
            switches => switches,
            state => current_state,
            usr_in => usr_in,
            tone_enable => tone_enable
        );

    tone_gen: tone_generator
        port map (
            clk => clk,
            enable => tone_enable,
            tone => tone_out
        );

    display_ctrl: display_controller
        port map (
            clk => clk,
            state => current_state,
            usr_in => usr_in,
            keys => keys,
            segments => segments,
            digits => digits,
            leds => leds
        );

end behavioral;
