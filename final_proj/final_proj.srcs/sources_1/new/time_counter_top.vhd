library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity time_counter_top is
    Port ( 
        CLK : in STD_LOGIC;                          -- 100MHz system clock
        BTN : in STD_LOGIC_VECTOR(4 downto 0);       -- 5 buttons
        SSEG_CA : out STD_LOGIC_VECTOR(7 downto 0);  -- 7-segment display segments (including decimal point)
        SSEG_AN : out STD_LOGIC_VECTOR(3 downto 0)   -- 7-segment display anodes
    );
end time_counter_top;

architecture Behavioral of time_counter_top is
    -- Internal signals
    signal clk_1hz : STD_LOGIC := '0';              -- 1Hz clock for time counting
    signal clk_100hz : STD_LOGIC := '0';            -- 100Hz clock for display multiplexing
    signal minutes : INTEGER range 0 to 59 := 0;    -- Minutes counter (0-59)
    signal hours : INTEGER range 0 to 23 := 0;      -- Hours counter (0-23)
    
    -- Reset signal
    signal reset : STD_LOGIC;                       -- Center button for reset
    
    -- Hour and minute setting buttons
    signal set_hour : STD_LOGIC;                    -- Up button to increment hours
    signal set_minute : STD_LOGIC;                  -- Left button to increment minutes
    
    -- Button debouncing
    signal set_hour_reg : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal set_minute_reg : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal set_hour_pulse : STD_LOGIC := '0';
    signal set_minute_pulse : STD_LOGIC := '0';
    
    -- Component declarations
    component clock_divider is
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk_1hz : out STD_LOGIC;
            clk_100hz : out STD_LOGIC
        );
    end component;
    
    component display_controller is
        Port (
            clk : in STD_LOGIC;
            clk_100hz : in STD_LOGIC;
            reset : in STD_LOGIC;
            hours : in INTEGER range 0 to 23;
            minutes : in INTEGER range 0 to 59;
            seg : out STD_LOGIC_VECTOR(7 downto 0);
            an : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
begin
    -- Button assignments
    reset <= BTN(4);          -- Center button for reset
    set_hour <= BTN(0);       -- Up button to increment hours
    set_minute <= BTN(1);     -- Left button to increment minutes
    
    -- Button debouncing
    process(CLK)
    begin
        if rising_edge(CLK) then
            set_hour_reg <= set_hour_reg(0) & set_hour;
            set_minute_reg <= set_minute_reg(0) & set_minute;
        end if;
    end process;
    
    set_hour_pulse <= '1' when set_hour_reg = "01" else '0';    -- Rising edge detection
    set_minute_pulse <= '1' when set_minute_reg = "01" else '0'; -- Rising edge detection
    
    -- Clock divider instantiation
    clk_div_inst: clock_divider
    port map (
        clk => CLK,
        reset => reset,
        clk_1hz => clk_1hz,
        clk_100hz => clk_100hz
    );
    
    -- Time counter process
    process(clk_1hz, reset, set_hour_pulse, set_minute_pulse)
    begin
        if reset = '1' then
            minutes <= 0;
            hours <= 0;
        elsif rising_edge(set_hour_pulse) then
            -- Increment hours when button pressed
            if hours = 23 then
                hours <= 0;
            else
                hours <= hours + 1;
            end if;
        elsif rising_edge(set_minute_pulse) then
            -- Increment minutes when button pressed
            if minutes = 59 then
                minutes <= 0;
                if hours = 23 then
                    hours <= 0;
                else
                    hours <= hours + 1;
                end if;
            else
                minutes <= minutes + 1;
            end if;
        elsif rising_edge(clk_1hz) then
            -- Normal time counting
            if minutes = 59 then
                minutes <= 0;
                if hours = 23 then
                    hours <= 0;
                else
                    hours <= hours + 1;
                end if;
            else
                minutes <= minutes + 1;
            end if;
        end if;
    end process;
    
    -- Display controller instantiation
    disp_ctrl: display_controller
    port map (
        clk => CLK,
        clk_100hz => clk_100hz,
        reset => reset,
        hours => hours,
        minutes => minutes,
        seg => SSEG_CA,
        an => SSEG_AN
    );

end Behavioral;