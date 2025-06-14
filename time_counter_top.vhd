library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity time_counter_top is
    Port ( 
        CLK : in STD_LOGIC;
        BTN : in STD_LOGIC_VECTOR(4 downto 0);
        SSEG_CA : out STD_LOGIC_VECTOR(7 downto 0);
        SSEG_AN : out STD_LOGIC_VECTOR(3 downto 0);
        LED : out STD_LOGIC_VECTOR(5 downto 0)
    );
end time_counter_top;

architecture Behavioral of time_counter_top is
    -- Internal signals
    signal clk_1hz : STD_LOGIC;
    signal clk_100hz : STD_LOGIC;
    signal clk_1khz : STD_LOGIC;
    
    signal hours : INTEGER range 0 to 23 := 0;
    signal minutes : INTEGER range 0 to 59 := 0;
    signal seconds : INTEGER range 0 to 59 := 0;
    
    signal btn_hours_up_db : STD_LOGIC;
    signal btn_hours_down_db : STD_LOGIC;
    signal btn_minutes_up_db : STD_LOGIC;
    signal btn_minutes_down_db : STD_LOGIC;
    signal btn_reset_db : STD_LOGIC;
    
    signal display_data : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Components
    component clock_divider is
        Port (
            clk_in : in STD_LOGIC;
            clk_1hz : out STD_LOGIC;
            clk_100hz : out STD_LOGIC;
            clk_1khz : out STD_LOGIC
        );
    end component;
    
    component time_counter is
        Port (
            clk_100hz : in STD_LOGIC;
            reset : in STD_LOGIC;
            hours_up : in STD_LOGIC;
            hours_down : in STD_LOGIC;
            minutes_up : in STD_LOGIC;
            minutes_down : in STD_LOGIC;
            hours_out : out INTEGER range 0 to 23;
            minutes_out : out INTEGER range 0 to 59;
            seconds_out : out INTEGER range 0 to 59
        );
    end component;
    
    component button_debouncer is
        Port (
            clk : in STD_LOGIC;
            btn_in : in STD_LOGIC;
            btn_out : out STD_LOGIC
        );
    end component;
    
    component seven_segment_display is
        Port (
            clk : in STD_LOGIC;
            hours : in INTEGER range 0 to 23;
            minutes : in INTEGER range 0 to 59;
            sseg_ca : out STD_LOGIC_VECTOR(7 downto 0);
            sseg_an : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
begin

    clk_div_inst : clock_divider
        port map (
            clk_in => CLK,
            clk_1hz => clk_1hz,
            clk_100hz => clk_100hz,
            clk_1khz => clk_1khz
        );
    
    debouncer_hours_up : button_debouncer
        port map (
            clk => clk_1khz,
            btn_in => BTN(0),  -- BTNU
            btn_out => btn_hours_up_db
        );
    
    debouncer_hours_down : button_debouncer
        port map (
            clk => clk_1khz,
            btn_in => BTN(3),  -- BTND
            btn_out => btn_hours_down_db
        );
    
    debouncer_minutes_up : button_debouncer
        port map (
            clk => clk_1khz,
            btn_in => BTN(2),  -- BTNR
            btn_out => btn_minutes_up_db
        );
    
    debouncer_minutes_down : button_debouncer
        port map (
            clk => clk_1khz,
            btn_in => BTN(1),  -- BTNL
            btn_out => btn_minutes_down_db
        );
    
    debouncer_reset : button_debouncer
        port map (
            clk => clk_1khz,
            btn_in => BTN(4),  -- BTNC
            btn_out => btn_reset_db
        );
    
    time_counter_inst : time_counter
        port map (
            clk_100hz => clk_100hz,
            reset => btn_reset_db,
            hours_up => btn_hours_up_db,
            hours_down => btn_hours_down_db,
            minutes_up => btn_minutes_up_db,
            minutes_down => btn_minutes_down_db,
            hours_out => hours,
            minutes_out => minutes,
            seconds_out => seconds
        );
    
    seven_seg_inst : seven_segment_display
        port map (
            clk => clk_1khz,
            hours => hours,
            minutes => minutes,
            sseg_ca => SSEG_CA,
            sseg_an => SSEG_AN
        );

    LED(5 downto 0) <= std_logic_vector(to_unsigned(seconds, 6));

end Behavioral;
