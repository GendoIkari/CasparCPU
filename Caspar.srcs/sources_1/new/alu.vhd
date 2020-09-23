LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Alu IS
    PORT (
        A : IN std_logic_vector(7 DOWNTO 0);
        B : IN std_logic_vector(7 DOWNTO 0);
        OpCode : IN std_logic_vector(7 DOWNTO 0); -- ZeroA, ZeroB, NotA, NotB, Add/And, NotResult, X, X
        Result : OUT std_logic_vector(7 DOWNTO 0)
    );
END Alu;

ARCHITECTURE Rtl OF Alu IS
    COMPONENT Mux2
        PORT (
            A : IN std_logic_vector(7 DOWNTO 0);
            B : IN std_logic_vector(7 DOWNTO 0);
            Sel : IN std_logic;
            O : OUT std_logic_vector(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Adder
        PORT (
            A : IN std_logic_vector(7 DOWNTO 0);
            B : IN std_logic_vector(7 DOWNTO 0);
            CIn : IN std_logic;
            Result : OUT std_logic_vector(7 DOWNTO 0);
            COut : OUT std_logic
        );
    END COMPONENT;

    SIGNAL afterZeroA : std_logic_vector(7 DOWNTO 0);
    SIGNAL afterZeroB : std_logic_vector(7 DOWNTO 0);
    SIGNAL afterNotA : std_logic_vector(7 DOWNTO 0);
    SIGNAL afterNotB : std_logic_vector(7 DOWNTO 0);
    SIGNAL aPlusB : std_logic_vector(7 DOWNTO 0);
    SIGNAL aAndB : std_logic_vector(7 DOWNTO 0);
    SIGNAL afterOperation : std_logic_vector(7 DOWNTO 0);
BEGIN
    aOrZero : Mux2 PORT MAP(A, "00000000", OpCode(7), afterZeroA);
    bOrZero : Mux2 PORT MAP(B, "00000000", OpCode(6), afterZeroB);

    aOrNotA : Mux2 PORT MAP(afterZeroA, NOT afterZeroA, OpCode(5), afterNotA);
    bOrNotB : Mux2 PORT MAP(afterZeroB, NOT afterZeroB, OpCode(4), afterNotB);

    adderAB : Adder PORT MAP(afterNotA, afterNotB, '0', aPlusB);
    aAndB <= afterNotA AND afterNotB;
    plusOrAnd : Mux2 PORT MAP(aPlusB, aAndB, OpCode(3), afterOperation);

    oOrNotO : Mux2 PORT MAP(afterOperation, NOT afterOperation, Opcode(2), Result);
END Rtl;
