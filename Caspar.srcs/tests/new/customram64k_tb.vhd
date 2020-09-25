LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CustomRam64k_TB IS
END CustomRam64k_TB;

ARCHITECTURE Rtl OF CustomRam64k_TB IS
    COMPONENT CustomRam64K
        PORT (
            Clock : IN std_logic;
            Enabled : IN std_logic;
            WriteEnabled : IN std_logic;
            Address : IN std_logic_vector(15 DOWNTO 0);
            DataIn : IN std_logic_vector(7 DOWNTO 0);
            DataOut : OUT std_logic_vector(7 DOWNTO 0);
            PC : IN std_logic_vector(15 DOWNTO 0);
            OpCode : OUT std_logic_vector(7 DOWNTO 0);
            OpCodeDataData : OUT std_logic_vector(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clock : std_logic := '0';
    SIGNAL enabled : std_logic := '0';
    SIGNAL writeEnabled : std_logic := '0';
    SIGNAL address : std_logic_vector(15 DOWNTO 0) := x"0000";
    SIGNAL dataIn : std_logic_vector(7 DOWNTO 0) := x"00";
    SIGNAL dataOut : std_logic_vector(7 DOWNTO 0);
    SIGNAL pc : std_logic_vector(15 DOWNTO 0) := x"0000";
    SIGNAL opCode : std_logic_vector(7 DOWNTO 0);
    SIGNAL OpCodeDataData : std_logic_vector(15 DOWNTO 0);

BEGIN
    uut : CustomRam64K PORT MAP(clock, enabled, writeEnabled, address, dataIn, dataOut, pc, opCode, OpCodeDataData);
    clock <= NOT clock AFTER 5 ns;

    PROCESS
    BEGIN
        -- Everything muted if disabled
        enabled <= '0';
        WAIT UNTIL falling_edge(Clock);
        ASSERT dataOut = x"ZZ" SEVERITY failure;
        ASSERT opCode = x"UU" SEVERITY failure;
        ASSERT OpCodeDataData = x"UUUU" SEVERITY failure;

        -- Write byte
        enabled <= '1';
        writeEnabled <= '1';
        address <= x"0000";
        pc <= x"0000";
        dataIn <= x"A0";
        WAIT UNTIL falling_edge(Clock);
        ASSERT dataOut = x"ZZ" SEVERITY failure;
        ASSERT opCode = x"A0" SEVERITY failure;
        ASSERT OpCodeDataData = x"UUUU" SEVERITY failure;
        -- Read byte
        writeEnabled <= '0';
        WAIT UNTIL falling_edge(Clock);
        ASSERT dataOut = x"A0" SEVERITY failure;
        ASSERT opCode = x"A0" SEVERITY failure;
        ASSERT OpCodeDataData = x"UUUU" SEVERITY failure;
        -- Write Multiple bytes
        writeEnabled <= '1';
        address <= x"0001";
        dataIn <= x"A1";
        WAIT UNTIL falling_edge(Clock);
        address <= x"0002";
        dataIn <= x"A2";
        WAIT UNTIL falling_edge(Clock);
        address <= x"0003";
        dataIn <= x"A3";
        WAIT UNTIL falling_edge(Clock);
        writeEnabled <= '0';
        address <= x"0001";
        WAIT UNTIL falling_edge(Clock);
        ASSERT dataOut = x"A1" SEVERITY failure;
        ASSERT opCode = x"A0" SEVERITY failure;
        ASSERT OpCodeDataData = x"A1A2" SEVERITY failure;
        -- Move PC
        pc <= x"0001";
        WAIT UNTIL falling_edge(Clock);
        ASSERT dataOut = x"A1" SEVERITY failure;
        ASSERT opCode = x"A1" SEVERITY failure;
        ASSERT OpCodeDataData = x"A2A3" SEVERITY failure;

        WAIT;
    END PROCESS;
END Rtl;
