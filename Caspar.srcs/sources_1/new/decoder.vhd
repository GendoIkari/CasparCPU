LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Decoder IS
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
END Decoder;

ARCHITECTURE Rtl OF Decoder IS
    -- NOP
    CONSTANT NOP : std_logic_vector(7 DOWNTO 0) := "00000000";
    -- MOV R0, 0xAA
    CONSTANT MOV_NUM_TO_REG : std_logic_vector(7 DOWNTO 0) := "00000001";
    -- MOV R0, (0xAA)
    CONSTANT MOV_MEM_TO_REG : std_logic_vector(7 DOWNTO 0) := "00000010";
    -- MOV (0xAA), R0
    CONSTANT MOV_REG_TO_MEM : std_logic_vector(7 DOWNTO 0) := "00000011";
    -- JMP 0xAA
    CONSTANT JMP_AT_NUM : std_logic_vector(7 DOWNTO 0) := "00000100";

    SIGNAL needRegR : std_logic := '0';
    SIGNAL needRegW : std_logic := '0';
    SIGNAL demuxedRegR : std_logic_vector(15 DOWNTO 0);
    SIGNAL demuxedRegW : std_logic_vector(15 DOWNTO 0);
BEGIN

    WITH OpCode SELECT needRegR <=
        '1' WHEN MOV_REG_TO_MEM,
        '0' WHEN OTHERS;

    WITH OpCode SELECT needRegW <=
        '1' WHEN MOV_NUM_TO_REG,
        '1' WHEN MOV_MEM_TO_REG,
        '0' WHEN OTHERS;

    WITH RegisterR SELECT demuxedRegR <=
        "1000000000000000" WHEN "0000",
        "0100000000000000" WHEN "0001",
        "0010000000000000" WHEN "0010",
        "0001000000000000" WHEN "0011",
        "0000100000000000" WHEN "0100",
        "0000010000000000" WHEN "0101",
        "0000001000000000" WHEN "0110",
        "0000000100000000" WHEN "0111",
        "0000000010000000" WHEN "1000",
        "0000000001000000" WHEN "1001",
        "0000000000100000" WHEN "1010",
        "0000000000010000" WHEN "1011",
        "0000000000001000" WHEN "1100",
        "0000000000000100" WHEN "1101",
        "0000000000000010" WHEN "1110",
        "0000000000000001" WHEN "1111",
        "0000000000000000" WHEN OTHERS;

    WITH RegisterW SELECT demuxedRegW <=
        "1000000000000000" WHEN "0000",
        "0100000000000000" WHEN "0001",
        "0010000000000000" WHEN "0010",
        "0001000000000000" WHEN "0011",
        "0000100000000000" WHEN "0100",
        "0000010000000000" WHEN "0101",
        "0000001000000000" WHEN "0110",
        "0000000100000000" WHEN "0111",
        "0000000010000000" WHEN "1000",
        "0000000001000000" WHEN "1001",
        "0000000000100000" WHEN "1010",
        "0000000000010000" WHEN "1011",
        "0000000000001000" WHEN "1100",
        "0000000000000100" WHEN "1101",
        "0000000000000010" WHEN "1110",
        "0000000000000001" WHEN "1111",
        "0000000000000000" WHEN OTHERS;

    CtrlRegELines <=
        demuxedRegR WHEN needRegR = '1' AND needRegW = '0' ELSE
        demuxedRegW WHEN needRegR = '0' AND needRegW = '1' ELSE
        demuxedRegR OR demuxedRegW WHEN needRegR = '1' AND needRegW = '1' ELSE
        x"0000";
    CtrlRegEWLines <= demuxedRegW WHEN needRegW = '1' ELSE
        x"0000";

    WITH OpCode SELECT CtrlEnableMemory <=
        '1' WHEN MOV_MEM_TO_REG,
        '1' WHEN MOV_REG_TO_MEM,
        '0' WHEN OTHERS;

    WITH OpCode SELECT CtrlEnableWriteMemory <=
        '1' WHEN MOV_REG_TO_MEM,
        '0' WHEN OTHERS;

    WITH OpCode SELECT CtrlEnableWriteRegPC <=
        '1' WHEN JMP_AT_NUM,
        '0' WHEN OTHERS;

    WITH OpCode SELECT CtrlEnableAddrFromOpCode <=
        '1' WHEN MOV_MEM_TO_REG,
        '1' WHEN MOV_REG_TO_MEM,
        '0' WHEN OTHERS;

    WITH OpCode SELECT CtrlEnableDataFromOpCode <=
        '1' WHEN MOV_NUM_TO_REG,
        '1' WHEN JMP_AT_NUM,
        '0' WHEN OTHERS;
END Rtl;
