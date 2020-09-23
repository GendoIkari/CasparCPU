LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Alu_TB IS
END Alu_TB;

ARCHITECTURE Rtl OF Alu_TB IS
    COMPONENT Alu
        PORT (
            A : IN std_logic_vector(7 DOWNTO 0);
            B : IN std_logic_vector(7 DOWNTO 0);
            OpCode : IN std_logic_vector(7 DOWNTO 0);
            Result : OUT std_logic_vector(7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL A : std_logic_vector(7 DOWNTO 0);
    SIGNAL B : std_logic_vector(7 DOWNTO 0);
    SIGNAL OpCode : std_logic_vector(7 DOWNTO 0);
    SIGNAL Result : std_logic_vector(7 DOWNTO 0);
BEGIN
    uut : Alu PORT MAP(A, B, OpCode, Result);

    PROCESS
    BEGIN
        -- A
        A <= "01010101";
        B <= "10101010";
        OpCode <= "01000000";
        WAIT FOR 10 ns;
        ASSERT Result = "01010101" SEVERITY failure;

        -- B
        A <= "01010101";
        B <= "10101010";
        OpCode <= "10000000";
        WAIT FOR 10 ns;
        ASSERT Result = "10101010" SEVERITY failure;

        -- not A
        A <= "01010101";
        B <= "11110000";
        OpCode <= "01100000";
        WAIT FOR 10 ns;
        ASSERT Result = "10101010" SEVERITY failure;

        -- not B
        A <= "00001111";
        B <= "10101010";
        OpCode <= "10010000";
        WAIT FOR 10 ns;
        ASSERT Result = "01010101" SEVERITY failure;

        -- A and B
        A <= "01010101";
        B <= "10101010";
        OpCode <= "00001000";
        WAIT FOR 10 ns;
        ASSERT Result = "00000000" SEVERITY failure;

        -- A or B
        A <= "11110000";
        B <= "00001111";
        OpCode <= "00111100";
        WAIT FOR 10 ns;
        ASSERT Result = "11111111" SEVERITY failure;

        -- A + B
        A <= "01010101";
        B <= "10101010";
        OpCode <= "00000000";
        WAIT FOR 10 ns;
        ASSERT Result = "11111111" SEVERITY failure;

        -- A - B (positive result)
        A <= "00100000";
        B <= "00000100";
        OpCode <= "00100100";
        WAIT FOR 10 ns;
        ASSERT Result = "00011100" SEVERITY failure;

        -- B - A (positive result)
        A <= "00000100";
        B <= "00100000";
        OpCode <= "00010100";
        WAIT FOR 10 ns;
        ASSERT Result = "00011100" SEVERITY failure;

        -- A - B (negative result)
        A <= "00000100";
        B <= "00100000";
        OpCode <= "00100100";
        WAIT FOR 10 ns;
        ASSERT Result = "11100100" SEVERITY failure;

        -- B - A (negative result)
        A <= "00100000";
        B <= "00000100";
        OpCode <= "00010100";
        WAIT FOR 10 ns;
        ASSERT Result = "11100100" SEVERITY failure;

        -- 0
        A <= "00100101";
        B <= "10010100";
        OpCode <= "11000000";
        WAIT FOR 10 ns;
        ASSERT Result = "00000000" SEVERITY failure;

        -- 1
        A <= "00100101";
        B <= "10010100";
        OpCode <= "11110100";
        WAIT FOR 10 ns;
        ASSERT Result = "00000001" SEVERITY failure;

        -- -1
        A <= "00100101";
        B <= "10010100";
        OpCode <= "11000100";
        WAIT FOR 10 ns;
        ASSERT Result = "11111111" SEVERITY failure;

        WAIT;
    END PROCESS;
END Rtl;
