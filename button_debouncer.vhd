library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity button_debouncer is
    Port (
        clk : in STD_LOGIC; -- 1kHz
        btn_in : in STD_LOGIC;
        btn_out : out STD_LOGIC
    );
end button_debouncer;

architecture Behavioral of button_debouncer is
    constant DEBOUNCE_TIME : integer := 10; -- 10ms przy 1kHz
    signal counter : integer range 0 to DEBOUNCE_TIME := 0;
    signal btn_sync : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal btn_stable : STD_LOGIC := '0';
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            btn_sync <= btn_sync(1 downto 0) & btn_in;
            
            if btn_sync(2) = btn_sync(1) then
                if counter = DEBOUNCE_TIME then
                    btn_stable <= btn_sync(2);
                else
                    counter <= counter + 1;
                end if;
            else
                counter <= 0;
            end if;
        end if;
    end process;
    
    btn_out <= btn_stable;

end Behavioral;
