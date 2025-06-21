library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity display_controller is
    port (
        clk         : in std_logic;
        state       : in std_logic_vector(2 downto 0);
        usr_in      : in std_logic_vector(15 downto 0);
        keys        : in std_logic_vector(15 downto 0);
        segments    : out std_logic_vector(6 downto 0);
        digits      : out std_logic_vector(7 downto 0);
        leds        : out std_logic_vector(15 downto 0)
    );
end display_controller;

architecture behavioral of display_controller is
    signal count_disp : std_logic_vector(15 downto 0);

    function bits_4_to_segment (
        usr_input : std_logic_vector(3 downto 0))
        return std_logic_vector is
        variable segment : std_logic_vector(6 downto 0);
    begin
        case(usr_input) is
            when "0000"  => segment  := "1000000"; 
            when "0001"  => segment  := "1111001"; 
            when "0010"  => segment  := "0100100"; 
            when "0011"  => segment  := "0110000"; 
            when "0100"  => segment  := "0011001"; 
            when "0101"  => segment  := "0010010"; 
            when "0110"  => segment  := "0000010"; 
            when "0111"  => segment  := "1111000"; 
            when "1000"  => segment  := "0000000"; 
            when "1001"  => segment  := "0010000"; 
            when others  => segment  := "1000000"; 
        end case;
        return segment;
    end;

begin
    process (clk)
    begin
        if rising_edge (clk) then
            count_disp <= count_disp + 1;
            if count_disp = "1110001101010000" then
                count_disp <= (others => '0');
            end if;
        end if;
    end process;

    output : process (state, count_disp, usr_in, keys)
        variable seg : std_logic_vector(6 downto 0);
        variable dig : std_logic_vector(7 downto 0);
    begin
        case state is
            when "000" =>  
                dig := "11111111";
                seg := "1111111";
                leds <= "0000000000000000";

            when "001" =>  
                case count_disp(15 downto 14) is
                    when "00" => 
                        dig := "01111111";
                        seg := bits_4_to_segment(usr_in(15 downto 12));
                    when others => 
                        dig := "11111111";
                        seg := "1111111";
                end case;

            when "010" =>  
                case count_disp(15 downto 14) is
                    when "00" => 
                        dig := "01111111";
                        seg := bits_4_to_segment(usr_in(15 downto 12));
                    when "01" => 
                        dig := "10111111";
                        seg := bits_4_to_segment(usr_in(11 downto 8));
                    when others => 
                        dig := "11111111";
                        seg := "1111111";
                end case;

            when "011" =>  
                case count_disp(15 downto 14) is
                    when "00" => 
                        dig := "01111111";
                        seg := bits_4_to_segment(usr_in(15 downto 12));
                    when "01" => 
                        dig := "10111111";
                        seg := bits_4_to_segment(usr_in(11 downto 8));
                    when "10" => 
                        dig := "11011111";
                        seg := bits_4_to_segment(usr_in(7 downto 4));
                    when others => 
                        dig := "11111111";
                        seg := "1111111";
                end case;

            when "100" =>  
                case count_disp(15 downto 14) is
                    when "00" => 
                        dig := "01111111";
                        seg := bits_4_to_segment(usr_in(15 downto 12));
                    when "01" => 
                        dig := "10111111";
                        seg := bits_4_to_segment(usr_in(11 downto 8));
                    when "10" => 
                        dig := "11011111";
                        seg := bits_4_to_segment(usr_in(7 downto 4));
                    when "11" => 
                        dig := "11101111";
                        seg := bits_4_to_segment(usr_in(3 downto 0));
                    when others => 
                        dig := "11111111";
                        seg := "1111111";
                end case;

            when "101" =>  
                if (usr_in = keys) then
                    leds <= "1111111111111111";
                    case count_disp(15 downto 14) is
                        when "00" => 
                            dig := "01111111";
                            seg := "1000000";  
                        when "01" => 
                            dig := "10111111";
                            seg := "0001100";  
                        when "10" => 
                            dig := "11011111";
                            seg := "0000110";  
                        when "11" => 
                            dig := "11101111";
                            seg := "0101011";  
                        when others => 
                            dig := "11111111";
                            seg := "1111111";
                    end case;
                else
                    case count_disp(15 downto 14) is
                        when "00" => 
                            dig := "11111011";
                            seg := "0000110";  
                        when "01" => 
                            dig := "11111100";
                            seg := "0101111";  
                        when others => 
                            dig := "11111111";
                            seg := "1111111";
                    end case;
                end if;

            when others =>
                dig := "11111111";
                seg := "1111111";
                leds <= "0000000000000000";
        end case;

        segments <= seg;
        digits <= dig;
    end process output;
end behavioral;