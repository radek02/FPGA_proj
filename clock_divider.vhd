library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port (
        clk_in : in STD_LOGIC;
        clk_1hz : out STD_LOGIC;
        clk_100hz : out STD_LOGIC;
        clk_1khz : out STD_LOGIC
    );
end clock_divider;

architecture Behavioral of clock_divider is
    constant CLK_FREQ : integer := 100000000/2; -- 100MHz
    
    signal counter_1hz : integer range 0 to CLK_FREQ-1 := 0;
    signal counter_100hz : integer range 0 to (CLK_FREQ/100)-1 := 0;
    signal counter_1khz : integer range 0 to (CLK_FREQ/1000)-1 := 0;
    
    signal clk_1hz_int : STD_LOGIC := '0';
    signal clk_100hz_int : STD_LOGIC := '0';
    signal clk_1khz_int : STD_LOGIC := '0';
    
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            -- Dzielnik dla 1Hz
            if counter_1hz = CLK_FREQ-1 then
                counter_1hz <= 0;
                clk_1hz_int <= not clk_1hz_int;
            else
                counter_1hz <= counter_1hz + 1;
            end if;
            
            -- Dzielnik dla 100Hz
            if counter_100hz = (CLK_FREQ/100)-1 then
                counter_100hz <= 0;
                clk_100hz_int <= not clk_100hz_int;
            else
                counter_100hz <= counter_100hz + 1;
            end if;
            
            -- Dzielnik dla 1kHz
            if counter_1khz = (CLK_FREQ/1000)-1 then
                counter_1khz <= 0;
                clk_1khz_int <= not clk_1khz_int;
            else
                counter_1khz <= counter_1khz + 1;
            end if;
        end if;
    end process;
    
    clk_1hz <= clk_1hz_int;
    clk_100hz <= clk_100hz_int;
    clk_1khz <= clk_1khz_int;

end Behavioral;
