LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Adder IS
    PORT (
        A : IN std_logic_vector(7 DOWNTO 0);
        B : IN std_logic_vector(7 DOWNTO 0);
        CIn : IN std_logic;
        Result : OUT std_logic_vector(7 DOWNTO 0);
        COut : OUT std_logic
    );
END Adder;

ARCHITECTURE Rtl OF Adder IS
    COMPONENT Adder1Bit
        PORT (
            A : IN std_logic;
            B : IN std_logic;
            CIn : IN std_logic;
            Result : OUT std_logic;
            COut : OUT std_logic
        );
    END COMPONENT;

    SIGNAL inputC : std_logic_vector(0 TO 8);
BEGIN
    inputC(0) <= CIn;

    adders : FOR i IN 0 TO 7 GENERATE
        adderI : Adder1Bit PORT MAP(A(i), B(i), inputC(i), Result(i), inputC(i + 1));
    END GENERATE adders;

    COut <= inputC(8);
END Rtl;
