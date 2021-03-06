LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CustomRam64K IS
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
END CustomRam64K;

ARCHITECTURE Rtl OF CustomRam64K IS
    TYPE RamArray IS ARRAY (2 ** 16 - 1 DOWNTO 0) OF std_logic_vector(7 DOWNTO 0);
    SIGNAL memory : RamArray;
    SIGNAL opCodeDataH : std_logic_vector(7 DOWNTO 0);
    SIGNAL opCodeDataL : std_logic_vector(7 DOWNTO 0);
BEGIN
    DataOut <= memory(to_integer(unsigned(Address))) WHEN Enabled = '1' AND WriteEnabled = '0' ELSE
        "ZZZZZZZZ";
    OpCode <= memory(to_integer(unsigned(PC)));
    opCodeDataH <= memory(to_integer(unsigned(PC)) + 1);
    opCodeDataL <= memory(to_integer(unsigned(PC)) + 2);

    OpCodeData(15) <= opCodeDataH(7);
    OpCodeData(14) <= opCodeDataH(6);
    OpCodeData(13) <= opCodeDataH(5);
    OpCodeData(12) <= opCodeDataH(4);
    OpCodeData(11) <= opCodeDataH(3);
    OpCodeData(10) <= opCodeDataH(2);
    OpCodeData(9) <= opCodeDataH(1);
    OpCodeData(8) <= opCodeDataH(0);
    OpCodeData(7) <= opCodeDataL(7);
    OpCodeData(6) <= opCodeDataL(6);
    OpCodeData(5) <= opCodeDataL(5);
    OpCodeData(4) <= opCodeDataL(4);
    OpCodeData(3) <= opCodeDataL(3);
    OpCodeData(2) <= opCodeDataL(2);
    OpCodeData(1) <= opCodeDataL(1);
    OpCodeData(0) <= opCodeDataL(0);

    PROCESS (Clock)
    BEGIN
        IF rising_edge(Clock) AND Enabled = '1' AND WriteEnabled = '1' THEN
            memory(to_integer(unsigned(Address))) <= DataIn;
        END IF;
    END PROCESS;
END Rtl;
