LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Adder_TB IS
END Adder_TB;

ARCHITECTURE Rtl OF Adder_TB IS
    COMPONENT Adder
        PORT (
            A : IN std_logic_vector(7 DOWNTO 0);
            B : IN std_logic_vector(7 DOWNTO 0);
            CIn : IN std_logic;
            Result : OUT std_logic_vector(7 DOWNTO 0);
            COut : OUT std_logic
        );
    END COMPONENT;

    SIGNAL A : std_logic_vector(7 DOWNTO 0);
    SIGNAL B : std_logic_vector(7 DOWNTO 0);
    SIGNAL CIn : std_logic;
    SIGNAL Result : std_logic_vector(7 DOWNTO 0);
    SIGNAL COut : std_logic;
BEGIN
    uut : Adder PORT MAP(A, B, CIn, Result, COut);

    PROCESS
    BEGIN
        -- A + B (C=0)
        A <= "10101010";
        B <= "01010101";
        CIn <= '0';
        WAIT FOR 10 ns;
        ASSERT Result = "11111111" SEVERITY failure;
        ASSERT COut = '0' SEVERITY failure;

        -- A + B (C=0)
        A <= "00001111";
        B <= "00000001";
        CIn <= '0';
        WAIT FOR 10 ns;
        ASSERT Result = "00010000" SEVERITY failure;
        ASSERT COut = '0' SEVERITY failure;

        -- A + B (C=1)
        A <= "00001111";
        B <= "00000001";
        CIn <= '1';
        WAIT FOR 10 ns;
        ASSERT Result = "00010001" SEVERITY failure;
        ASSERT COut = '0' SEVERITY failure;

        -- A + B (C=1) with overflow
        A <= "10101010";
        B <= "01010101";
        CIn <= '1';
        WAIT FOR 10 ns;
        ASSERT Result = "00000000" SEVERITY failure;
        ASSERT COut = '1' SEVERITY failure;

        WAIT;
    END PROCESS;

END Rtl;
