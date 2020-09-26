LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY IOPorts IS
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
END IOPorts;

ARCHITECTURE Rtl OF IOPorts IS
    COMPONENT Register8Bit
        PORT (
            Clock : IN std_logic;
            Enabled : IN std_logic;
            WriteEnabled : IN std_logic;
            DataIn : IN std_logic_vector(7 DOWNTO 0);
            DataOut : OUT std_logic_vector(7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL port02 : std_logic_vector(7 DOWNTO 0);
    SIGNAL port03 : std_logic_vector(7 DOWNTO 0);
    SIGNAL port00Enabled : std_logic;
    SIGNAL port01Enabled : std_logic;
    SIGNAL port02Enabled : std_logic;
    SIGNAL port03Enabled : std_logic;
    SIGNAL port00WriteEnabled : std_logic;
    SIGNAL port01WriteEnabled : std_logic;
    SIGNAL port02WriteEnabled : std_logic;
    SIGNAL port03WriteEnabled : std_logic;

BEGIN
    port00Enabled <= Enabled WHEN Address = x"00" ELSE
        '0';
    port01Enabled <= Enabled WHEN Address = x"01" ELSE
        '0';
    port02Enabled <= Enabled WHEN Address = x"02" ELSE
        '0';
    port03Enabled <= Enabled WHEN Address = x"03" ELSE
        '0';

    port00WriteEnabled <= '0';
    port01WriteEnabled <= '0';
    port02WriteEnabled <= WriteEnabled AND port02Enabled;
    port03WriteEnabled <= WriteEnabled AND port03Enabled;

    port02Reg : Register8Bit PORT MAP(Clock, '1', port02WriteEnabled, DataIn, port02);
    port03Reg : Register8Bit PORT MAP(Clock, '1', port03WriteEnabled, DataIn, port03);
    Port02Out <= port02;
    Port03Out <= port03;

    DataOut <=
        Port00In WHEN port00Enabled = '1' AND WriteEnabled = '0' ELSE
        Port01In WHEN port01Enabled = '1' AND WriteEnabled = '0' ELSE
        port02 WHEN port02Enabled = '1' AND WriteEnabled = '0' ELSE
        port03 WHEN port03Enabled = '1' AND WriteEnabled = '0' ELSE
        x"00" WHEN Enabled = '1'AND WriteEnabled = '0' ELSE
        "ZZZZZZZZ";
END Rtl;
