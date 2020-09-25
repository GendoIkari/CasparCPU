LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Register16Bit_TB IS
END Register16Bit_TB;

ARCHITECTURE Rtl OF Register16Bit_TB IS
    COMPONENT Register16Bit
        PORT (
            Clock : IN std_logic;
            Enabled : IN std_logic;
            WriteEnabled : IN std_logic;
            DataIn : IN std_logic_vector(15 DOWNTO 0);
            DataOut : OUT std_logic_vector(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clock : std_logic := '0';
    SIGNAL enabled : std_logic := '0';
    SIGNAL writeEnabled : std_logic := '0';
    SIGNAL dataIn : std_logic_vector(15 DOWNTO 0) := x"0000";
    SIGNAL dataOut : std_logic_vector(15 DOWNTO 0);
BEGIN
    uut : Register16Bit PORT MAP(clock, enabled, writeEnabled, dataIn, dataOut);
    clock <= NOT clock AFTER 5 ns;

    PROCESS
    BEGIN
        -- Everything is disabled
        enabled <= '0';
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = "ZZZZZZZZZZZZZZZZ" SEVERITY failure;

        -- Write data
        enabled <= '1';
        writeEnabled <= '1';
        dataIn <= x"AA00";
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = "ZZZZZZZZZZZZZZZZ" SEVERITY failure;

        -- Read data
        writeEnabled <= '0';
        dataIn <= x"0000";
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"AA00" SEVERITY failure;

    END PROCESS;
END Rtl;
