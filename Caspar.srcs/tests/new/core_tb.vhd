LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY Core_TB IS
END Core_TB;

ARCHITECTURE Rtl OF Core_TB IS
    COMPONENT Core
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
    END COMPONENT;

    SIGNAL clock : std_logic := '0';
    SIGNAL IN_BtnL : std_logic := '0';
    SIGNAL IN_BtnR : std_logic := '0';
    SIGNAL IN_Switch00 : std_logic := '0';
    SIGNAL IN_Switch01 : std_logic := '0';
    SIGNAL IN_Switch02 : std_logic := '0';
    SIGNAL IN_Switch03 : std_logic := '0';
    SIGNAL IN_Switch04 : std_logic := '0';
    SIGNAL IN_Switch05 : std_logic := '0';
    SIGNAL IN_Switch06 : std_logic := '0';
    SIGNAL IN_Switch07 : std_logic := '0';
    SIGNAL IN_Switch08 : std_logic := '0';
    SIGNAL IN_Switch09 : std_logic := '0';
    SIGNAL IN_Switch10 : std_logic := '0';
    SIGNAL IN_Switch11 : std_logic := '0';
    SIGNAL IN_Switch12 : std_logic := '0';
    SIGNAL IN_Switch13 : std_logic := '0';
    SIGNAL IN_Switch14 : std_logic := '0';
    SIGNAL IN_Switch15 : std_logic := '0';

    SIGNAL OUT_Led00 : std_logic := '0';
    SIGNAL OUT_Led01 : std_logic := '0';
    SIGNAL OUT_Led02 : std_logic := '0';
    SIGNAL OUT_Led03 : std_logic := '0';
    SIGNAL OUT_Led04 : std_logic := '0';
    SIGNAL OUT_Led05 : std_logic := '0';
    SIGNAL OUT_Led06 : std_logic := '0';
    SIGNAL OUT_Led07 : std_logic := '0';

    SIGNAL OUT_Led08 : std_logic := '0';
    SIGNAL OUT_Led09 : std_logic := '0';
    SIGNAL OUT_Led10 : std_logic := '0';
    SIGNAL OUT_Led11 : std_logic := '0';
    SIGNAL OUT_Led12 : std_logic := '0';
    SIGNAL OUT_Led13 : std_logic := '0';
    SIGNAL OUT_Led14 : std_logic := '0';
    SIGNAL OUT_Led15 : std_logic := '0';
BEGIN
    uut : Core PORT MAP(
        clock,
        IN_BtnL,
        IN_BtnR,
        IN_Switch00,
        IN_Switch01,
        IN_Switch02,
        IN_Switch03,
        IN_Switch04,
        IN_Switch05,
        IN_Switch06,
        IN_Switch07,
        IN_Switch08,
        IN_Switch09,
        IN_Switch10,
        IN_Switch11,
        IN_Switch12,
        IN_Switch13,
        IN_Switch14,
        IN_Switch15,

        OUT_Led00,
        OUT_Led01,
        OUT_Led02,
        OUT_Led03,
        OUT_Led04,
        OUT_Led05,
        OUT_Led06,
        OUT_Led07,

        OUT_Led08,
        OUT_Led09,
        OUT_Led10,
        OUT_Led11,
        OUT_Led12,
        OUT_Led13,
        OUT_Led14,
        OUT_Led15
    );
    clock <= NOT clock AFTER 5 ns;

    PROCESS
    BEGIN
        WAIT UNTIL rising_edge(clock);
        WAIT UNTIL rising_edge(clock);
        WAIT UNTIL rising_edge(clock);
        IN_Switch00 <= NOT IN_Switch00;
    END PROCESS;
END Rtl;
