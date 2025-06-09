library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity time_counter_top_tb is
    -- Testbench has no ports
end time_counter_top_tb;

architecture Behavioral of time_counter_top_tb is
    signal CLK_test : STD_LOGIC := '0';
    signal BTN_test : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal sseg_ca_test : STD_LOGIC_VECTOR(7 downto 0);
    signal sseg_an_test : STD_LOGIC_VECTOR(3 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;  -- 100MHz = 10ns period
    
    component time_counter_top is
        Port (
            CLK : in STD_LOGIC;
            BTN : in STD_LOGIC_VECTOR(4 downto 0);
            sseg_ca : out STD_LOGIC_VECTOR(7 downto 0);
            sseg_an : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
begin
    UUT: time_counter_top
        port map (
            CLK => CLK_test,
            BTN => BTN_test,
            sseg_ca => sseg_ca_test,
            sseg_an => sseg_an_test
        );
    
    clock_generator: process
    begin
        wait for CLK_PERIOD/2;
        CLK_test <= not CLK_test;
    end process;
    
    test_sequence: process
    begin
        report "=== START OF TEST ===" severity note;
        
        -- Initial state - all buttons released
        BTN_test <= "00000";
        wait for 1 us;
        report "Initial state: all buttons released" severity note;
        
        -- Test hours up button (BTN(0) = BTNU)
        report "Testing hours up button..." severity note;
        BTN_test(0) <= '1';
        wait for 50 ms;  -- Hold button for debouncing
        BTN_test(0) <= '0';
        wait for 100 ms;
        
        -- Test hours down button (BTN(3) = BTND)
        report "Testing hours down button..." severity note;
        BTN_test(3) <= '1';
        wait for 50 ms;
        BTN_test(3) <= '0';
        wait for 100 ms;
        
        -- Test minutes up button (BTN(2) = BTNR)
        report "Testing minutes up button..." severity note;
        BTN_test(2) <= '1';
        wait for 50 ms;
        BTN_test(2) <= '0';
        wait for 100 ms;
        
        -- Test minutes down button (BTN(1) = BTNL)
        report "Testing minutes down button..." severity note;
        BTN_test(1) <= '1';
        wait for 50 ms;
        BTN_test(1) <= '0';
        wait for 100 ms;
        
        -- Test reset button (BTN(4) = BTNC)
        report "Testing reset button..." severity note;
        BTN_test(4) <= '1';
        wait for 50 ms;
        BTN_test(4) <= '0';
        wait for 100 ms;
        
        -- Test multiple button presses
        report "Testing multiple hours up presses..." severity note;
        for i in 1 to 5 loop
            BTN_test(0) <= '1';
            wait for 50 ms;
            BTN_test(0) <= '0';
            wait for 100 ms;
        end loop;
        
        -- Observe 7-segment multiplexing
        report "Observing 7-segment display multiplexing..." severity note;
        wait for 10 ms;  -- Watch the multiplexing in action
        
        -- Test time overflow (hours 23 -> 0)
        report "Testing time overflow..." severity note;
        -- Set time close to 23:59 and test rollover
        for i in 1 to 25 loop  -- Should cause hour overflow
            BTN_test(0) <= '1';
            wait for 50 ms;
            BTN_test(0) <= '0';
            wait for 100 ms;
        end loop;
        
        report "=== END OF TEST ===" severity note;
        
        -- Stop simulation
        wait;
    end process;
    
    -- Monitor process (optional - to display current state)
    monitor: process
    begin
        wait for 1 ms;
        while true loop
            report "LED state: " & 
                   integer'image(to_integer(unsigned(LED_test))) &
                   ", sseg_an: " & 
                   integer'image(to_integer(unsigned(sseg_an_test))) &
                   ", sseg_ca: " &
                   integer'image(to_integer(unsigned(sseg_ca_test)))
                   severity note;
            wait for 500 ms;  -- Report every 500ms
        end loop;
    end process;

end Behavioral;