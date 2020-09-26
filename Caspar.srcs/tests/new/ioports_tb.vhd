LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY IOPorts_TB IS
END IOPorts_TB;

ARCHITECTURE Rtl OF IOPorts_TB IS
    COMPONENT IOPorts IS
        PORT (
            Clock : IN std_logic;
            Enabled : IN std_logic;
            WriteEnabled : IN std_logic;
            Address : IN std_logic_vector(7 DOWNTO 0);
            DataIn : IN std_logic_vector(7 DOWNTO 0);
            DataOut : OUT std_logic_vector(7 DOWNTO 0);
            Port00In : IN std_logic_vector(7 DOWNTO 0);
            Port01In : IN std_logic_vector(7 DOWNTO 0);
            Port02Out : OUT std_logic_vector(7 DOWNTO 0);
            Port03Out : OUT std_logic_vector(7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clock : std_logic := '0';
    SIGNAL enabled : std_logic := '0';
    SIGNAL writeEnabled : std_logic := '0';
    SIGNAL address : std_logic_vector(7 DOWNTO 0) := x"00";
    SIGNAL dataIn : std_logic_vector(7 DOWNTO 0) := x"00";
    SIGNAL dataOut : std_logic_vector(7 DOWNTO 0);
    SIGNAL port00In : std_logic_vector(7 DOWNTO 0) := x"AA";
    SIGNAL port01In : std_logic_vector(7 DOWNTO 0) := x"BB";
    SIGNAL port02Out : std_logic_vector(7 DOWNTO 0);
    SIGNAL port03Out : std_logic_vector(7 DOWNTO 0);
BEGIN
    clock <= NOT clock AFTER 5 ns;
    uut : IOPorts PORT MAP(clock, enabled, writeEnabled, address, dataIn, dataOut, port00In, port01In, port02Out, port03Out);

    PROCESS BEGIN
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = "ZZZZZZZZ" SEVERITY failure;

        enabled <= '1';
        writeEnabled <= '0';
        -- Read from input ports
        address <= x"00";
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"AA" SEVERITY failure;
        address <= x"01";
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"BB" SEVERITY failure;
        -- Read from output ports
        address <= x"02";
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"00" SEVERITY failure;
        address <= x"03";
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"00" SEVERITY failure;

        -- Write and then read to input ports
        dataIn <= x"FF";
        address <= x"00";
        writeEnabled <= '1';
        WAIT UNTIL falling_edge(clock);
        writeEnabled <= '0';
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"AA" SEVERITY failure;
        address <= x"01";
        writeEnabled <= '1';
        WAIT UNTIL falling_edge(clock);
        writeEnabled <= '0';
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"BB" SEVERITY failure;

        -- Write and then read to output ports
        address <= x"02";
        writeEnabled <= '1';
        WAIT UNTIL falling_edge(clock);
        writeEnabled <= '0';
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"FF" SEVERITY failure;
        address <= x"03";
        writeEnabled <= '1';
        WAIT UNTIL falling_edge(clock);
        writeEnabled <= '0';
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"FF" SEVERITY failure;

        -- Read to disconnected port
        address <= x"04";
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"00" SEVERITY failure;

        -- Write to disconnected port
        address <= x"04";
        writeEnabled <= '1';
        WAIT UNTIL falling_edge(clock);
        writeEnabled <= '0';
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"00" SEVERITY failure;

        WAIT;
    END PROCESS;
END Rtl;
