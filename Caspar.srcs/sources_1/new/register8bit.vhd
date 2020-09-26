LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Register8Bit IS
    PORT (
        Clock : IN std_logic;
        Enabled : IN std_logic;
        WriteEnabled : IN std_logic;
        DataIn : IN std_logic_vector(7 DOWNTO 0);
        DataOut : OUT std_logic_vector(7 DOWNTO 0)
    );
END Register8Bit;

ARCHITECTURE Rtl OF Register8Bit IS
    SIGNAL data : std_logic_vector(7 DOWNTO 0) := x"00";
BEGIN
    DataOut <= data WHEN Enabled = '1' AND WriteEnabled = '0' ELSE
        "ZZZZZZZZ";

    PROCESS (Clock, WriteEnabled)
    BEGIN
        IF rising_edge(Clock) AND Enabled = '1' AND WriteEnabled = '1' THEN
            data <= DataIn;
        END IF;
    END PROCESS;
END Rtl;
