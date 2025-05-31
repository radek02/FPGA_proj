library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_controller is
    Port (
        clk : in STD_LOGIC;                      -- System clock
        clk_100hz : in STD_LOGIC;                -- 100Hz refresh clock
        reset : in STD_LOGIC;                    -- Reset signal
        hours : in INTEGER range 0 to 23;        -- Hours value (0-23)
        minutes : in INTEGER range 0 to 59;      -- Minutes value (0-59)
        seg : out STD_LOGIC_VECTOR(7 downto 0);  -- 7-segment control (including decimal point)
        an : out STD_LOGIC_VECTOR(3 downto 0)    -- Anode control
    );
end display_controller;

architecture Behavioral of display_controller is
    -- Internal signals
    signal digit_value : INTEGER range 0 to 9 := 0;
    signal digit_select : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal hours_tens, hours_ones : INTEGER range 0 to 9 := 0;
    signal mins_tens, mins_ones : INTEGER range 0 to 9 := 0;
    signal segments : STD_LOGIC_VECTOR(6 downto 0);
    signal decimal_point : STD_LOGIC;
begin
    -- Compute BCD digits
    hours_tens <= hours / 10;
    hours_ones <= hours mod 10;
    mins_tens <= minutes / 10;
    mins_ones <= minutes mod 10;
    
    -- Digit selection counter
    process(clk_100hz, reset)
    begin
        if reset = '1' then
            digit_select <= "00";
        elsif rising_edge(clk_100hz) then
            digit_select <= STD_LOGIC_VECTOR(unsigned(digit_select) + 1);
        end if;
    end process;
    
    -- Anode control and digit selection
    process(digit_select, hours_tens, hours_ones, mins_tens, mins_ones)
    begin
        case digit_select is
            when "00" =>
                an <= "1110";          -- Display rightmost digit (minutes ones)
                digit_value <= mins_ones;
                decimal_point <= '1';  -- Decimal point off
            when "01" =>
                an <= "1101";          -- Display second digit (minutes tens)
                digit_value <= mins_tens;
                decimal_point <= '1';  -- Decimal point off
            when "10" =>
                an <= "1011";          -- Display third digit (hours ones)
                digit_value <= hours_ones;
                decimal_point <= '0';  -- Decimal point on (for the colon effect)
            when "11" =>
                an <= "0111";          -- Display leftmost digit (hours tens)
                digit_value <= hours_tens;
                decimal_point <= '1';  -- Decimal point off
            when others =>
                an <= "1111";          -- All digits off
                digit_value <= 0;
                decimal_point <= '1';  -- Decimal point off
        end case;
    end process;
    
    -- 7-segment decoder (common anode - logic 0 turns segment on)
    process(digit_value)
    begin
        case digit_value is
            when 0 => segments <= "1000000";  -- "0"
            when 1 => segments <= "1111001";  -- "1"
            when 2 => segments <= "0100100";  -- "2"
            when 3 => segments <= "0110000";  -- "3"
            when 4 => segments <= "0011001";  -- "4"
            when 5 => segments <= "0010010";  -- "5"
            when 6 => segments <= "0000010";  -- "6"
            when 7 => segments <= "1111000";  -- "7"
            when 8 => segments <= "0000000";  -- "8"
            when 9 => segments <= "0010000";  -- "9"
            when others => segments <= "1111111";  -- All segments off
        end case;
    end process;
    
    -- Combine segments and decimal point
    seg <= decimal_point & segments;

end Behavioral;