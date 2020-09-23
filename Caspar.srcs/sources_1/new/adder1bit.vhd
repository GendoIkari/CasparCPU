LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Adder1Bit IS
    PORT (
        A : IN std_logic;
        B : IN std_logic;
        CIn : IN std_logic;
        Result : OUT std_logic;
        COut : OUT std_logic
    );
END Adder1Bit;

ARCHITECTURE Rtl OF Adder1Bit IS
BEGIN
    Result <= A XOR B XOR CIn;
    COut <= (A AND B) OR (Cin AND A) OR (CIn AND B);
END Rtl;
