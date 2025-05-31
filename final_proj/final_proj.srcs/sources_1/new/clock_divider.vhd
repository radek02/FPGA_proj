library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port (
        clk : in STD_LOGIC;         -- 100MHz system clock
        reset : in STD_LOGIC;        -- Reset signal
        clk_1hz : out STD_LOGIC;     -- 1Hz output clock
        clk_100hz : out STD_LOGIC    -- 100Hz output clock
    );
end clock_divider;

architecture Behavioral of clock_divider is
    -- For 100MHz to 1Hz: 100,000,000 / 2 = 50,000,000 cycles
    -- For 100MHz to 100Hz: 100,000,000 / 200 = 500,000 cycles
    signal counter_1hz : INTEGER range 0 to 50000000 := 0;
    signal counter_100hz : INTEGER range 0 to 500000 := 0;
    signal clk_1hz_reg : STD_LOGIC := '0';
    signal clk_100hz_reg : STD_LOGIC := '0';
begin
    -- Generate 1Hz clock
    process(clk, reset)
    begin
        if reset = '1' then
            counter_1hz <= 0;
            clk_1hz_reg <= '0';
        elsif rising_edge(clk) then
            if counter_1hz = 50000000 - 1 then
                counter_1hz <= 0;
                clk_1hz_reg <= not clk_1hz_reg;
            else
                counter_1hz <= counter_1hz + 1;
            end if;
        end if;
    end process;
    
    -- Generate 100Hz clock
    process(clk, reset)
    begin
        if reset = '1' then
            counter_100hz <= 0;
            clk_100hz_reg <= '0';
        elsif rising_edge(clk) then
            if counter_100hz = 500000 - 1 then
                counter_100hz <= 0;
                clk_100hz_reg <= not clk_100hz_reg;
            else
                counter_100hz <= counter_100hz + 1;
            end if;
        end if;
    end process;
    
    -- Assign output
    clk_1hz <= clk_1hz_reg;
    clk_100hz <= clk_100hz_reg;

end Behavioral;