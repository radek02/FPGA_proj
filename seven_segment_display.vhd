-- filepath: /home/radek/MINI/FPGA/final_proj/src/seven_segment_display.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_segment_display is
    Port (
        clk : in STD_LOGIC;
        hours : in INTEGER range 0 to 23;
        minutes : in INTEGER range 0 to 59;
        sseg_ca : out STD_LOGIC_VECTOR(7 downto 0);
        sseg_an : out STD_LOGIC_VECTOR(3 downto 0)
    );
end seven_segment_display;

architecture Behavioral of seven_segment_display is
    signal digit_select : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal counter : integer range 0 to 249 := 0; -- Dla 100Hz przy 25kHz
    signal current_digit : integer range 0 to 9;
    
    -- Funkcja konwersji cyfry na kod 7-segmentowy (wspólna anoda)
    function digit_to_sseg(digit : integer) return STD_LOGIC_VECTOR is
    begin
        case digit is
            when 0 => return "11000000"; -- 0
            when 1 => return "11111001"; -- 1
            when 2 => return "10100100"; -- 2
            when 3 => return "10110000"; -- 3
            when 4 => return "10011001"; -- 4
            when 5 => return "10010010"; -- 5
            when 6 => return "10000010"; -- 6
            when 7 => return "11111000"; -- 7
            when 8 => return "10000000"; -- 8
            when 9 => return "10010000"; -- 9
            when others => return "11111111"; -- wyłączone
        end case;
    end function;
    
begin
    -- Multiplexer dla wyświetlacza
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = 249 then -- Przełączanie co 2.5ms (przy 100Hz clk)
                counter <= 0;
                digit_select <= std_logic_vector(unsigned(digit_select) + 1);
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    -- Wybór aktywnego wyświetlacza i cyfry
    process(digit_select, hours, minutes)
    begin
        case digit_select is
            when "00" => -- Pierwsza cyfra godzin
                sseg_an <= "0111";
                current_digit <= hours / 10;
            when "01" => -- Druga cyfra godzin
                sseg_an <= "1011";
                current_digit <= hours mod 10;
            when "10" => -- Pierwsza cyfra minut
                sseg_an <= "1101";
                current_digit <= minutes / 10;
            when "11" => -- Druga cyfra minut
                sseg_an <= "1110";
                current_digit <= minutes mod 10;
            when others =>
                sseg_an <= "1111";
                current_digit <= 0;
        end case;
    end process;
    
    -- Kodowanie cyfry na wyświetlacz
    sseg_ca <= digit_to_sseg(current_digit);

end Behavioral;
