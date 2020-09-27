LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Register16Bit IS
    PORT (
        Clock : IN std_logic;
        Enabled : IN std_logic;
        WriteEnabled : IN std_logic;
        DataIn : IN std_logic_vector(15 DOWNTO 0);
        DataOut : OUT std_logic_vector(15 DOWNTO 0)
    );
END Register16Bit;

ARCHITECTURE Rtl OF Register16Bit IS
    SIGNAL data : std_logic_vector(15 DOWNTO 0) := x"0000";
BEGIN
    DataOut <= data WHEN Enabled = '1' ELSE
        "ZZZZZZZZZZZZZZZZ";

    PROCESS (Clock, Enabled, WriteEnabled)
    BEGIN
        IF falling_edge(Clock) AND Enabled = '1' AND WriteEnabled = '1' THEN
            data <= DataIn;
        END IF;
    END PROCESS;
END Rtl;
