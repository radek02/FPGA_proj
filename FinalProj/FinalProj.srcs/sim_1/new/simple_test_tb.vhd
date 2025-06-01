-- filepath: /home/radek/MINI/FPGA/final_proj/testbench/simple_test_tb.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity simple_test_tb is
    -- Testbench nie ma portów!
end simple_test_tb;

architecture Behavioral of simple_test_tb is
    -- 1. SYGNAŁY TESTOWE (połączenia do modułu)
    signal clk_in_test : STD_LOGIC := '0';      -- Wejście zegara
    signal clk_1hz_test : STD_LOGIC;            -- Wyjście 1Hz
    signal clk_100hz_test : STD_LOGIC;          -- Wyjście 100Hz
    signal clk_1khz_test : STD_LOGIC;           -- Wyjście 1kHz
    
    -- 2. STAŁE CZASOWE
    constant CLK_PERIOD : time := 10 ns;        -- 100MHz = 10ns okres
    
    -- 3. KOMPONENT DO TESTOWANIA
    component clock_divider is
        Port (
            clk_in : in STD_LOGIC;
            clk_1hz : out STD_LOGIC;
            clk_100hz : out STD_LOGIC;
            clk_1khz : out STD_LOGIC
        );
    end component;
    
begin
    -- 4. PODŁĄCZENIE KOMPONENTU (jak w prawdziwym układzie)
    UUT: clock_divider  -- UUT = Unit Under Test
        port map (
            clk_in => clk_in_test,       -- Nasze sygnały testowe
            clk_1hz => clk_1hz_test,     -- podłączamy do modułu
            clk_100hz => clk_100hz_test,
            clk_1khz => clk_1khz_test
        );
    
    -- 5. GENERATOR ZEGARA (nieskończona pętla)
    clock_generator: process
    begin
        clk_in_test <= '0';              -- Ustaw 0
        wait for CLK_PERIOD/2;           -- Czekaj 5ns
        clk_in_test <= '1';              -- Ustaw 1
        wait for CLK_PERIOD/2;           -- Czekaj 5ns
        -- Proces automatycznie wraca na początek = pętla!
    end process;
    
    -- 6. PROCES TESTOWY (sterowanie testem)
    test_sequence: process
    begin
        -- Pokaż co się dzieje
        report "=== START TESTU ===" severity note;
        
        -- Czekaj 1 mikrosekundę i pokaż wyniki
        wait for 1 us;
        report "Po 1us - sprawdzamy czy zegary działają" severity note;
        
        -- Czekaj dłużej żeby zobaczyć zmiany
        wait for 10 us;
        report "Po 10us - obserwuj wykresy!" severity note;
        
        -- Czekaj jeszcze dłużej
        wait for 100 us;
        report "Po 100us - koniec testu" severity note;
        
        report "=== KONIEC TESTU ===" severity note;
        
        -- WAŻNE: zatrzymaj symulację!
        wait;  -- Bez tego symulacja będzie trwać w nieskończoność
    end process;

end Behavioral;