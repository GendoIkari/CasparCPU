LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Core IS
    PORT (
        IN_Clock : IN std_logic;

        IN_BtnL : IN std_logic;
        IN_BtnR : IN std_logic;

        IN_Switch00 : IN std_logic;
        IN_Switch01 : IN std_logic;
        IN_Switch02 : IN std_logic;
        IN_Switch03 : IN std_logic;
        IN_Switch04 : IN std_logic;
        IN_Switch05 : IN std_logic;
        IN_Switch06 : IN std_logic;
        IN_Switch07 : IN std_logic;
        IN_Switch08 : IN std_logic;
        IN_Switch09 : IN std_logic;
        IN_Switch10 : IN std_logic;
        IN_Switch11 : IN std_logic;
        IN_Switch12 : IN std_logic;
        IN_Switch13 : IN std_logic;
        IN_Switch14 : IN std_logic;
        IN_Switch15 : IN std_logic;

        OUT_Led00 : OUT std_logic;
        OUT_Led01 : OUT std_logic;
        OUT_Led02 : OUT std_logic;
        OUT_Led03 : OUT std_logic;
        OUT_Led04 : OUT std_logic;
        OUT_Led05 : OUT std_logic;
        OUT_Led06 : OUT std_logic;
        OUT_Led07 : OUT std_logic;

        OUT_Led08 : OUT std_logic;
        OUT_Led09 : OUT std_logic;
        OUT_Led10 : OUT std_logic;
        OUT_Led11 : OUT std_logic;
        OUT_Led12 : OUT std_logic;
        OUT_Led13 : OUT std_logic;
        OUT_Led14 : OUT std_logic;
        OUT_Led15 : OUT std_logic
    );
END Core;

ARCHITECTURE Rtl OF Core IS
    COMPONENT Register8Bit IS
        PORT (
            Clock : IN std_logic;
            Enabled : IN std_logic;
            WriteEnabled : IN std_logic;
            DataIn : IN std_logic_vector(7 DOWNTO 0);
            DataOut : OUT std_logic_vector(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Register16Bit IS
        PORT (
            Clock : IN std_logic;
            Enabled : IN std_logic;
            WriteEnabled : IN std_logic;
            DataIn : IN std_logic_vector(15 DOWNTO 0);
            DataOut : OUT std_logic_vector(15 DOWNTO 0)
        );
    END COMPONENT;

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

    COMPONENT Decoder
        PORT (
            OpCode : IN std_logic_vector(7 DOWNTO 0);
            RegisterR : IN std_logic_vector(3 DOWNTO 0);
            RegisterW : IN std_logic_vector(3 DOWNTO 0);
            CtrlRegELines : OUT std_logic_vector(15 DOWNTO 0);
            CtrlRegEWLines : OUT std_logic_vector(15 DOWNTO 0);
            CtrlEnableMemory : OUT std_logic;
            CtrlEnableWriteMemory : OUT std_logic;
            CtrlEnableWriteRegPC : OUT std_logic;
            CtrlEnableAddrFromOpCode : OUT std_logic;
            CtrlEnableDataFromOpCode : OUT std_logic
        );
    END COMPONENT;

    -- Control Lines
    SIGNAL ctrlEnableMemory : std_logic := '0';
    SIGNAL ctrlEnableWriteMemory : std_logic := '0';
    SIGNAL ctrlEnableRegisters : std_logic_vector(15 DOWNTO 0);
    SIGNAL ctrlEnableWriteRegisters : std_logic_vector(15 DOWNTO 0);
    SIGNAL ctrlEnableWriteRegPC : std_logic := '0';
    SIGNAL ctrlEnableAddrFromOpCode : std_logic := '0';
    SIGNAL ctrlEnableDataFromOpCode : std_logic := '0';
    -- Bus
    SIGNAL busAddress : std_logic_vector(15 DOWNTO 0);
    SIGNAL busData : std_logic_vector(7 DOWNTO 0);
    SIGNAL busReadPC : std_logic_vector(15 DOWNTO 0);
    SIGNAL busWritePC : std_logic_vector(15 DOWNTO 0);
    SIGNAL busOpCode : std_logic_vector(7 DOWNTO 0);
    SIGNAL busOpCodeRegisterR : std_logic_vector(3 DOWNTO 0);
    SIGNAL busOpCodeRegisterW : std_logic_vector(3 DOWNTO 0);
    SIGNAL busOpCodeData : std_logic_vector(15 DOWNTO 0);
    -- I/O
    SIGNAL switches00 : std_logic_vector(7 DOWNTO 0);
    SIGNAL switches01 : std_logic_vector(7 DOWNTO 0);
    SIGNAL leds02 : std_logic_vector(7 DOWNTO 0);
    SIGNAL leds03 : std_logic_vector(7 DOWNTO 0);

BEGIN
    regGenR0R15 : FOR i IN 0 TO 15 GENERATE
        registerRI : Register8Bit PORT MAP(
            Clock => IN_Clock,
            Enabled => ctrlEnableRegisters(i),
            WriteEnabled => ctrlEnableWriteRegisters(i),
            DataIn => busData,
            DataOut => busData
        );
    END GENERATE regGenR0R15;

    registerPC : Register16Bit PORT MAP(
        Clock => IN_Clock,
        Enabled => '1',
        WriteEnabled => '1',
        DataIn => busWritePC,
        DataOut => busReadPC
    );
    busWritePC <= busOpCodeData WHEN ctrlEnableWriteRegPC = '1' ELSE
        std_logic_vector(unsigned(busReadPC) + 1);

    memoryMapInst : MemoryMap PORT MAP(
        Clock => IN_Clock,
        Enabled => ctrlEnableMemory,
        WriteEnabled => ctrlEnableWriteMemory,
        Address => busAddress,
        DataIn => busData,
        DataOut => busData,
        PC => busReadPC(13 DOWNTO 0),
        OpCode => busOpCode,
        OCRegA => busOpCodeRegisterR,
        OCRegB => busOpCodeRegisterW,
        OCData => busOpCodeData,
        Port00In => switches00,
        Port01In => switches01,
        Port02Out => leds02,
        Port03Out => leds03
    );

    busAddress <= busOpCodeData WHEN ctrlEnableAddrFromOpCode = '1' ELSE
        "ZZZZZZZZZZZZZZZZ";
    busData <= busOpCodeData(7 DOWNTO 0) WHEN CtrlEnableDataFromOpCode = '1' ELSE
        "ZZZZZZZZ";

    decoderInst : Decoder PORT MAP(
        OpCode => busOpCode,
        RegisterR => busOpCodeRegisterR,
        RegisterW => busOpCodeRegisterW,
        CtrlRegELines => ctrlEnableRegisters,
        CtrlRegEWLines => ctrlEnableWriteRegisters,
        CtrlEnableMemory => ctrlEnableMemory,
        CtrlEnableWriteMemory => ctrlEnableWriteMemory,
        CtrlEnableWriteRegPC => ctrlEnableWriteRegPC,
        CtrlEnableAddrFromOpCode => ctrlEnableAddrFromOpCode,
        CtrlEnableDataFromOpCode => ctrlEnableDataFromOpCode
    );

    -- I/O
    switches00(7) <= IN_Switch00;
    switches00(6) <= IN_Switch01;
    switches00(5) <= IN_Switch02;
    switches00(4) <= IN_Switch03;
    switches00(3) <= IN_Switch04;
    switches00(2) <= IN_Switch05;
    switches00(1) <= IN_Switch06;
    switches00(0) <= IN_Switch07;

    switches01(7) <= IN_Switch08;
    switches01(6) <= IN_Switch09;
    switches01(5) <= IN_Switch10;
    switches01(4) <= IN_Switch11;
    switches01(3) <= IN_Switch12;
    switches01(2) <= IN_Switch13;
    switches01(1) <= IN_Switch14;
    switches01(0) <= IN_Switch15;

    OUT_Led00 <= leds02(7);
    OUT_Led01 <= leds02(6);
    OUT_Led02 <= leds02(5);
    OUT_Led03 <= leds02(4);
    OUT_Led04 <= leds02(3);
    OUT_Led05 <= leds02(2);
    OUT_Led06 <= leds02(1);
    OUT_Led07 <= leds02(0);

    OUT_Led08 <= leds03(7);
    OUT_Led09 <= leds03(6);
    OUT_Led10 <= leds03(5);
    OUT_Led11 <= leds03(4);
    OUT_Led12 <= leds03(3);
    OUT_Led13 <= leds03(2);
    OUT_Led14 <= leds03(1);
    OUT_Led15 <= leds03(0);
END Rtl;
