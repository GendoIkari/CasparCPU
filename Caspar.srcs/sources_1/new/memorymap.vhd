LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MemoryMap IS
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
END MemoryMap;

ARCHITECTURE Rtl OF MemoryMap IS
    COMPONENT Ram64K IS
        PORT (
            ClkA : IN STD_LOGIC;
            EnA : IN STD_LOGIC;
            WEA : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            AddrA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            DInA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            DOutA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            ClkB : IN STD_LOGIC;
            EnB : IN STD_LOGIC;
            WEB : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            AddrB : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            DInB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            DOutB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT IOPorts
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

    SIGNAL ramEnabled : std_logic;
    SIGNAL ioEnabled : std_logic;
    SIGNAL ioAddress : std_logic_vector(7 DOWNTO 0);
    SIGNAL ramDataOut : std_logic_vector(7 DOWNTO 0);
    SIGNAL ioDataOut : std_logic_vector(7 DOWNTO 0);
BEGIN
    ioEnabled <= Address(15) AND Address(14) AND Address(13) AND Address(12) AND Address(11) AND Address(10) AND Address(9) AND Address(8);
    ioAddress <= Address(7 DOWNTO 0);
    ramEnabled <= NOT ioEnabled;
    DataOut <=
        ramDataOut WHEN ramEnabled = '1' AND Enabled = '1' ELSE
        ioDataOut WHEN ioEnabled = '1' AND Enabled = '1' ELSE
        "ZZZZZZZZ";

    -- -- 0x0000 => 0xFEFF = ROM ~64K
    ram : Ram64K PORT MAP(
        ClkA => Clock,
        EnA => ramEnabled,
        WEA(0) => WriteEnabled,
        AddrA => Address,
        DInA => DataIn,
        DOutA => ramDataOut,
        ClkB => Clock,
        EnB => '1',
        WEB => "0",
        AddrB => PC,
        DInB => x"00000000",
        DOutB(7 DOWNTO 0) => OpCode,
        DOutB(11 DOWNTO 8) => OCRegA,
        DOutB(15 DOWNTO 12) => OCRegB,
        DOutB(23 DOWNTO 16) => OCData(7 DOWNTO 0),
        DOutB(31 DOWNTO 24) => OCData(15 DOWNTO 8)
    );
    -- 0xFF00  => 0xFFFF = I/O 256B
    io : IOPorts PORT MAP(
        Clock => Clock,
        Enabled => ioEnabled,
        WriteEnabled => WriteEnabled,
        Address => ioAddress,
        DataIn => DataIn,
        DataOut => ioDataOut,
        Port00In => Port00In,
        Port01In => Port01In,
        Port02Out => Port02Out,
        Port03Out => Port03Out
    );

END Rtl;
