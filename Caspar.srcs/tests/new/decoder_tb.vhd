LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Decoder_TB IS
END Decoder_TB;

ARCHITECTURE Rtl OF Decoder_TB IS
    COMPONENT Decoder
        PORT (
            OpCode : IN std_logic_vector(7 DOWNTO 0);
            RegisterR : IN std_logic_vector(3 DOWNTO 0);
            RegisterW : IN std_logic_vector(3 DOWNTO 0);
            CtrlRegELines : OUT std_logic_vector(15 DOWNTO 0); -- R0 to R15
            CtrlRegEWLines : OUT std_logic_vector(15 DOWNTO 0); -- R0 to R15
            CtrlEnableMemory : OUT std_logic;
            CtrlEnableWriteMemory : OUT std_logic;
            CtrlEnableWriteRegPC : OUT std_logic;
            CtrlEnableAddrFromOpCode : OUT std_logic;
            CtrlEnableDataFromOpCode : OUT std_logic
        );
    END COMPONENT;

    SIGNAL opCode : std_logic_vector(7 DOWNTO 0) := x"00";
    SIGNAL registerR : std_logic_vector(3 DOWNTO 0) := x"0";
    SIGNAL registerW : std_logic_vector(3 DOWNTO 0) := x"0";
    SIGNAL ctrlRegELines : std_logic_vector(15 DOWNTO 0);
    SIGNAL ctrlRegEWLines : std_logic_vector(15 DOWNTO 0);
    SIGNAL ctrlEnableMemory : std_logic;
    SIGNAL ctrlEnableWriteMemory : std_logic;
    SIGNAL ctrlEnableWriteRegPC : std_logic;
    SIGNAL ctrlEnableAddrFromOpCode : std_logic;
    SIGNAL ctrlEnableDataFromOpCode : std_logic;
BEGIN
    uut : Decoder PORT MAP(opCode, registerR, registerW, ctrlRegELines, ctrlRegEWLines, ctrlEnableMemory, ctrlEnableWriteMemory, ctrlEnableWriteRegPC, ctrlEnableAddrFromOpCode, ctrlEnableDataFromOpCode);

    PROCESS
    BEGIN
        -- NOP
        opCode <= "00000000";
        registerR <= x"0";
        registerW <= x"0";
        WAIT FOR 1 ns;
        ASSERT ctrlRegELines = x"0000" SEVERITY failure;
        ASSERT ctrlRegEWLines = x"0000" SEVERITY failure;
        ASSERT ctrlEnableMemory = '0' SEVERITY failure;
        ASSERT ctrlEnableWriteMemory = '0' SEVERITY failure;
        ASSERT ctrlEnableWriteRegPC = '0' SEVERITY failure;
        ASSERT ctrlEnableAddrFromOpCode = '0' SEVERITY failure;
        ASSERT ctrlEnableDataFromOpCode = '0' SEVERITY failure;

        -- MOV R0, 0xAA
        opCode <= "00000001";
        registerR <= x"0";
        registerW <= x"0";
        WAIT FOR 1 ns;
        ASSERT ctrlRegELines = "1000000000000000" SEVERITY failure;
        ASSERT ctrlRegEWLines = "1000000000000000" SEVERITY failure;
        ASSERT ctrlEnableMemory = '0' SEVERITY failure;
        ASSERT ctrlEnableWriteMemory = '0' SEVERITY failure;
        ASSERT ctrlEnableWriteRegPC = '0' SEVERITY failure;
        ASSERT ctrlEnableAddrFromOpCode = '0' SEVERITY failure;
        ASSERT ctrlEnableDataFromOpCode = '1' SEVERITY failure;

        -- MOV R1, (0xAA)
        opCode <= "00000010";
        registerR <= x"0";
        registerW <= x"1";
        WAIT FOR 1 ns;
        ASSERT ctrlRegELines = "0100000000000000" SEVERITY failure;
        ASSERT ctrlRegEWLines = "0100000000000000" SEVERITY failure;
        ASSERT ctrlEnableMemory = '1' SEVERITY failure;
        ASSERT ctrlEnableWriteMemory = '0' SEVERITY failure;
        ASSERT ctrlEnableWriteRegPC = '0' SEVERITY failure;
        ASSERT ctrlEnableAddrFromOpCode = '1' SEVERITY failure;
        ASSERT ctrlEnableDataFromOpCode = '0' SEVERITY failure;

        -- MOV (0xAA), R2
        opCode <= "00000011";
        registerR <= x"2";
        registerW <= x"0";
        WAIT FOR 1 ns;
        ASSERT ctrlRegELines = "0010000000000000" SEVERITY failure;
        ASSERT ctrlRegEWLines = "0000000000000000" SEVERITY failure;
        ASSERT ctrlEnableMemory = '1' SEVERITY failure;
        ASSERT ctrlEnableWriteMemory = '1' SEVERITY failure;
        ASSERT ctrlEnableWriteRegPC = '0' SEVERITY failure;
        ASSERT ctrlEnableAddrFromOpCode = '1' SEVERITY failure;
        ASSERT ctrlEnableDataFromOpCode = '0' SEVERITY failure;

        -- JMP 0xAA
        opCode <= "00000100";
        registerR <= x"0";
        registerW <= x"0";
        WAIT FOR 1 ns;
        ASSERT ctrlRegELines = "0000000000000000" SEVERITY failure;
        ASSERT ctrlRegEWLines = "0000000000000000" SEVERITY failure;
        ASSERT ctrlEnableMemory = '0' SEVERITY failure;
        ASSERT ctrlEnableWriteMemory = '0' SEVERITY failure;
        ASSERT ctrlEnableWriteRegPC = '1' SEVERITY failure;
        ASSERT ctrlEnableAddrFromOpCode = '0' SEVERITY failure;
        ASSERT ctrlEnableDataFromOpCode = '1' SEVERITY failure;

        WAIT;
    END PROCESS;
END Rtl;
