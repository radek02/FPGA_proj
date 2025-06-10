library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity time_counter is
    Port (
        clk_1hz : in STD_LOGIC; -- 1Hz
        clk_fast : in STD_LOGIC; -- 100Hz
        reset : in STD_LOGIC;
        hours_up : in STD_LOGIC;
        hours_down : in STD_LOGIC;
        minutes_up : in STD_LOGIC;
        minutes_down : in STD_LOGIC;
        hours_out : out INTEGER range 0 to 23;
        minutes_out : out INTEGER range 0 to 59
    );
end time_counter;

architecture Behavioral of time_counter is
    signal hours_reg : INTEGER range 0 to 23 := 0;
    signal minutes_reg : INTEGER range 0 to 59 := 0;
    signal seconds_reg : INTEGER range 0 to 59 := 0;
    
    signal hours_up_prev : STD_LOGIC := '0';
    signal hours_down_prev : STD_LOGIC := '0';
    signal minutes_up_prev : STD_LOGIC := '0';
    signal minutes_down_prev : STD_LOGIC := '0';
begin

    process(clk_fast)
    begin
        if rising_edge(clk_fast) then
            if reset = '1' then
                hours_reg <= 0;
                minutes_reg <= 0;
                seconds_reg <= 0;
            else
                -- Obsługa przycisków
                if hours_up = '1' and hours_up_prev = '0' then
                    hours_reg <= (hours_reg + 1) mod 24;
                end if;
                
                if hours_down = '1' and hours_down_prev = '0' then
                    hours_reg <= (hours_reg - 1) mod 24;
                end if;
                
                if minutes_up = '1' and minutes_up_prev = '0' then
                    minutes_reg <= (minutes_reg + 1) mod 60;
                end if;
                
                if minutes_down = '1' and minutes_down_prev = '0' then
                    minutes_reg <= (minutes_reg - 1) mod 60;
                end if;
            end if;

            hours_up_prev <= hours_up;
            hours_down_prev <= hours_down;
            minutes_up_prev <= minutes_up;
            minutes_down_prev <= minutes_down;
        end if;
    end process;

    process(clk_1hz)
    begin
        if rising_edge(clk_1hz) then      
            if hours_up = '0' and hours_down = '0' and minutes_up = '0' and minutes_down = '0' then
                seconds_reg <= (seconds_reg + 1) mod 60;
                if seconds_reg = 0 then
                    minutes_reg <= (minutes_reg + 1) mod 60;
                    if minutes_reg = 0 then
                        hours_reg <= (hours_reg + 1) mod 24;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    hours_out <= hours_reg;
    minutes_out <= minutes_reg;

end Behavioral;
