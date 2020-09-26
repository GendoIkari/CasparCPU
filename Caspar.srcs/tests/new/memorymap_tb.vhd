LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MemoryMap_TB IS
END MemoryMap_TB;

ARCHITECTURE Rtl OF MemoryMap_TB IS
    COMPONENT MemoryMap IS
        PORT (
            Clock : IN std_logic;
            Enabled : IN std_logic;
            WriteEnabled : IN std_logic;
            Address : IN std_logic_vector(15 DOWNTO 0);
            DataIn : IN std_logic_vector(7 DOWNTO 0);
            DataOut : OUT std_logic_vector(7 DOWNTO 0);
            PC : IN std_logic_vector(13 DOWNTO 0);
            OpCode : OUT std_logic_vector(7 DOWNTO 0);
            OCRegA : OUT std_logic_vector(3 DOWNTO 0);
            OCRegB : OUT std_logic_vector(3 DOWNTO 0);
            OCData : OUT std_logic_vector(15 DOWNTO 0);

            Port00In : IN std_logic_vector(7 DOWNTO 0);
            Port01In : IN std_logic_vector(7 DOWNTO 0);
            Port02Out : OUT std_logic_vector(7 DOWNTO 0);
            Port03Out : OUT std_logic_vector(7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clock : STD_LOGIC := '0';
    SIGNAL enabled : std_logic := '0';
    SIGNAL writeEnabled : std_logic := '0';
    SIGNAL address : std_logic_vector(15 DOWNTO 0) := x"0000";
    SIGNAL dataIn : std_logic_vector(7 DOWNTO 0) := x"00";
    SIGNAL dataOut : std_logic_vector(7 DOWNTO 0);
    SIGNAL PC : std_logic_vector(13 DOWNTO 0) := std_logic_vector(to_unsigned(0, 14));
    SIGNAL opCode : std_logic_vector(7 DOWNTO 0);
    SIGNAL OCRegA : std_logic_vector(3 DOWNTO 0);
    SIGNAL OCRegB : std_logic_vector(3 DOWNTO 0);
    SIGNAL OCData : std_logic_vector(15 DOWNTO 0);

    SIGNAL port00In : std_logic_vector(7 DOWNTO 0) := x"AA";
    SIGNAL port01In : std_logic_vector(7 DOWNTO 0) := x"BB";
    SIGNAL port02Out : std_logic_vector(7 DOWNTO 0);
    SIGNAL port03Out : std_logic_vector(7 DOWNTO 0);
BEGIN
    clock <= NOT clock AFTER 5 ns;

    uut : MemoryMap PORT MAP(
        Clock => Clock,
        Enabled => Enabled,
        WriteEnabled => WriteEnabled,
        Address => Address,
        DataIn => DataIn,
        DataOut => DataOut,
        PC => PC,
        OpCode => OpCode,
        OCRegA => OCRegA,
        OCRegB => OCRegB,
        OCData => OCData,
        Port00In => Port00In,
        Port01In => Port01In,
        Port02Out => Port02Out,
        Port03Out => Port03Out
    );

    PROCESS BEGIN
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = "ZZZZZZZZ" SEVERITY failure;

        enabled <= '1';
        -- Read RAM 0x0000
        address <= x"0000";
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"02" SEVERITY failure;
        -- Read Port00
        address <= x"FF00";
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"AA" SEVERITY failure;
        -- Read ram at opcode data address
        PC <= "00000000000000";
        address <= OCData;
        WAIT UNTIL falling_edge(clock);
        ASSERT dataOut = x"AA" SEVERITY failure;

        WAIT;
    END PROCESS;
END Rtl;
