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
        PC : IN std_logic_vector(15 DOWNTO 0);
        OpCode : OUT std_logic_vector(7 DOWNTO 0);
        OpCodeData : OUT std_logic_vector(15 DOWNTO 0)
    );
END MemoryMap;

ARCHITECTURE Rtl OF MemoryMap IS
    COMPONENT CustomRom4K
        PORT (
            Clock : IN std_logic;
            Enabled : IN std_logic;
            WriteEnabled : IN std_logic;
            Address : IN std_logic_vector(15 DOWNTO 0);
            DataIn : IN std_logic_vector(7 DOWNTO 0);
            DataOut : OUT std_logic_vector(7 DOWNTO 0);
            PC : IN std_logic_vector(15 DOWNTO 0);
            OpCode : OUT std_logic_vector(7 DOWNTO 0);
            OpCodeData : OUT std_logic_vector(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT CustomRam4K
        PORT (
            Clock : IN std_logic;
            Enabled : IN std_logic;
            WriteEnabled : IN std_logic;
            Address : IN std_logic_vector(15 DOWNTO 0);
            DataIn : IN std_logic_vector(7 DOWNTO 0);
            DataOut : OUT std_logic_vector(7 DOWNTO 0);
            PC : IN std_logic_vector(15 DOWNTO 0);
            OpCode : OUT std_logic_vector(7 DOWNTO 0);
            OpCodeData : OUT std_logic_vector(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT IOPorts
        PORT (
            Clock : IN std_logic;
            Enabled : IN std_logic;
            WriteEnabled : IN std_logic;
            Address : IN std_logic_vector(7 DOWNTO 0);
            DataIn : IN std_logic_vector(7 DOWNTO 0);
            DataOut : OUT std_logic_vector(7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL romEnabled : std_logic;
    SIGNAL ramEnabled : std_logic;
    SIGNAL ioEnabled : std_logic;
    SIGNAL romOpCode : std_logic_vector(7 DOWNTO 0);
    SIGNAL romOpCodeData : std_logic_vector(15 DOWNTO 0);
    SIGNAL ramAddress : std_logic_vector(15 DOWNTO 0);
    SIGNAL ramPC : std_logic_vector(15 DOWNTO 0);
    SIGNAL ramOpCode : std_logic_vector(7 DOWNTO 0);
    SIGNAL ramOpCodeData : std_logic_vector(15 DOWNTO 0);
    SIGNAL ioAddress : std_logic_vector(7 DOWNTO 0);
BEGIN
    ramAddress <= std_logic_vector(to_unsigned(to_integer(unsigned(Address)) - 4096, ramAddress'length));
    ramPC <= std_logic_vector(to_unsigned(to_integer(unsigned(PC)) - 4096, ramPC'length));

    ioAddress(7) <= Address(7);
    ioAddress(6) <= Address(6);
    ioAddress(5) <= Address(5);
    ioAddress(4) <= Address(4);
    ioAddress(3) <= Address(3);
    ioAddress(2) <= Address(2);
    ioAddress(1) <= Address(1);
    ioAddress(0) <= Address(0);

    romEnabled <= (NOT Address(15)) AND (NOT Address(14)) AND (NOT Address(13)) AND (NOT Address(12));
    ioEnabled <= Address(15) AND Address(14) AND Address(13) AND Address(12) AND Address(11) AND Address(10) AND Address(9) AND Address(8);
    ramEnabled <= NOT romEnabled AND NOT ioEnabled;

    OpCode <= ramOpCode WHEN ramEnabled = '1' ELSE
        romOpCode;
    OpCodeData <= romOpCode WHEN ramEnabled = '1' ELSE
        romOpCodeData;

    -- 0x0000 => 0x0FFF = ROM 4K
    rom : CustomRom4K PORT MAP(
        Clock => Clock,
        Enabled => romEnabled,
        WriteEnabled => WriteEnabled,
        Address => Address,
        DataIn => DataIn,
        DataOut => DataOut,
        PC => PC,
        OpCode => romOpCode,
        OpCodeData => romOpCodeData
    );
    -- 0x1000 => 0xFEFF = RAM ~60K
    ram : CustomRam4K PORT MAP(
        Clock => Clock,
        Enabled => ramEnabled,
        WriteEnabled => WriteEnabled,
        Address => ramAddress,
        DataIn => DataIn,
        DataOut => DataOut,
        PC => PC,
        OpCode => ramOpCode,
        OpCodeData => ramOpCodeData
    );
    -- 0xFF00  => 0xFFFF = I/O 256B
    io : IOPorts PORT MAP(
        Clock => Clock,
        Enabled => ioEnabled,
        WriteEnabled => WriteEnabled,
        Address => ioAddress,
        DataIn => DataIn,
        DataOut => DataOut
    );

END Rtl;
