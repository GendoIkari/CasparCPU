LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Mux2_TB IS
END Mux2_TB;

ARCHITECTURE Rtl OF Mux2_TB IS
    COMPONENT Mux2
        PORT (
            A : IN std_logic_vector(7 DOWNTO 0);
            B : IN std_logic_vector(7 DOWNTO 0);
            Sel : IN std_logic;
            O : OUT std_logic_vector(7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL A : std_logic_vector(7 DOWNTO 0);
    SIGNAL B : std_logic_vector(7 DOWNTO 0);
    SIGNAL Sel : std_logic;
    SIGNAL O : std_logic_vector(7 DOWNTO 0);
BEGIN
    uut : Mux2 PORT MAP(A, B, Sel, O);

    PROCESS
    BEGIN
        A <= "10101010";
        B <= "01010101";
        Sel <= '0';
        WAIT FOR 10 ns;
        ASSERT O = "10101010" SEVERITY failure;

        Sel <= '1';
        WAIT FOR 10 ns;
        ASSERT O = "01010101" SEVERITY failure;

        Sel <= 'U';
        WAIT FOR 10 ns;
        ASSERT O = "10101010" SEVERITY failure;

        WAIT;
    END PROCESS;
END Rtl;
