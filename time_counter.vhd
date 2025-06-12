library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity time_counter is
  port (
    clk_100hz     : in  std_logic;
    reset         : in  std_logic;
    hours_up      : in  std_logic;
    hours_down    : in  std_logic;
    minutes_up    : in  std_logic;
    minutes_down  : in  std_logic;
    hours_out     : out integer range 0 to 23;
    minutes_out   : out integer range 0 to 59;
    seconds_out   : out integer range 0 to 59
  );
end;
 
architecture rtl of time_counter is
  constant CLK_FREQ : integer := 100;           -- 100 Hz
  signal div_cnt    : integer range 0 to CLK_FREQ-1 := 0;
 
  signal hr_reg  : integer range 0 to 23 := 0;
  signal min_reg : integer range 0 to 59 := 0;
  signal sec_reg : integer range 0 to 59 := 0;
 
  signal h_up_d, h_dn_d,
         m_up_d, m_dn_d : std_logic := '0';     -- detektory zbocza
begin
  process (clk_100hz)
    variable hr_next  : integer range 0 to 23;
    variable min_next : integer range 0 to 59;
    variable sec_next : integer range 0 to 59;
  begin
    if rising_edge(clk_100hz) then
 
      if reset = '1' then
        hr_reg  <= 0;
        min_reg <= 0;
        sec_reg <= 0;
      else
 
        if (hours_up  = '1' and h_up_d = '0') then
          hr_reg <= (hr_reg + 1) mod 24;
        elsif (hours_down = '1' and h_dn_d = '0') then
          hr_reg <= (hr_reg + 23) mod 24;       --  -1 bez liczb ujemnych
        end if;
 
        if (minutes_up = '1' and m_up_d = '0') then
          min_reg <= (min_reg + 1) mod 60;
        elsif (minutes_down = '1' and m_dn_d = '0') then
          min_reg <= (min_reg + 59) mod 60;     --  -1 bez liczb ujemnych
        end if;
 
        if div_cnt = CLK_FREQ-1 then
          div_cnt <= 0;
 
          -- tylko gdy żaden przycisk nie jest wciśnięty
          if hours_up='0' and hours_down='0' and
             minutes_up='0' and minutes_down='0' then
 
            -- najpierw decyzja o przeniesieniu...
            sec_next := sec_reg + 1;
            min_next := min_reg;
            hr_next  := hr_reg;
 
            if sec_next = 60 then
              sec_next := 0;
              min_next := min_next + 1;
 
              if min_next = 60 then
                min_next := 0;
                hr_next  := (hr_next + 1) mod 24;
              end if;
            end if;
 
            -- ...potem jednorazowa aktualizacja rejestrów
            sec_reg <= sec_next;
            min_reg <= min_next;
            hr_reg  <= hr_next;
          end if;
 
        else
          div_cnt <= div_cnt + 1;
        end if;
      end if;
 
      -- rejestracja stanów przycisków (detekcja zbocza)
      h_up_d <= hours_up;
      h_dn_d <= hours_down;
      m_up_d <= minutes_up;
      m_dn_d <= minutes_down;
    end if;
  end process;
 
  -- wyjścia
  hours_out   <= hr_reg;
  minutes_out <= min_reg;
  seconds_out <= sec_reg;
end rtl;