library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity time_counter_top_tb is
    -- Testbench has no ports
end time_counter_top_tb;

architecture Behavioral of time_counter_top_tb is
    signal CLK_test : STD_LOGIC := '0';
    signal BTN_test : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal sseg_ca_test : STD_LOGIC_VECTOR(7 downto 0);
    signal sseg_an_test : STD_LOGIC_VECTOR(3 downto 0);
    signal LED_test : STD_LOGIC_VECTOR(5 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;  -- 100MHz = 10ns period
    
    component time_counter_top is
        Port (
            CLK : in STD_LOGIC;
            BTN : in STD_LOGIC_VECTOR(4 downto 0);
            sseg_ca : out STD_LOGIC_VECTOR(7 downto 0);
            sseg_an : out STD_LOGIC_VECTOR(3 downto 0);
            LED : out STD_LOGIC_VECTOR(5 downto 0)
        );
    end component;
    
begin
    UUT: time_counter_top
        port map (
            CLK => CLK_test,
            BTN => BTN_test,
            sseg_ca => sseg_ca_test,
            sseg_an => sseg_an_test,
            LED => LED_test
        );
    
    clock_generator: process
    begin
        wait for CLK_PERIOD/2;
        CLK_test <= not CLK_test;
    end process;
    
    test_sequence: process
    begin
    
        report "=== START OF BASIC TEST ===" severity note;
        
        BTN_test <= "00000";
        report "Initial state: all buttons released" severity note;
        
        report "Testing hours up button... (150ms)" severity note;
        BTN_test(0) <= '1';
        wait for 50 ms; 
        BTN_test(0) <= '0';
        wait for 100 ms;
        
        report "Testing minutes up button... (150ms)" severity note;
        BTN_test(2) <= '1';
        wait for 50 ms;
        BTN_test(2) <= '0';
        wait for 100 ms;
        
        report "Testing hours down button... (150ms)" severity note;
        BTN_test(3) <= '1';
        wait for 50 ms;
        BTN_test(3) <= '0';
        wait for 100 ms;
        
        report "Testing minutes down button... (150ms)" severity note;
        BTN_test(1) <= '1';
        wait for 50 ms;
        BTN_test(1) <= '0';
        wait for 100 ms;
        
        report "Testing reset button... (150ms)" severity note;
        BTN_test(4) <= '1';
        wait for 50 ms;
        BTN_test(4) <= '0';
        wait for 100 ms;
        
        report "=== END OF BASIC TEST ===" severity note;
        
        wait;
    end process;

end Behavioral;