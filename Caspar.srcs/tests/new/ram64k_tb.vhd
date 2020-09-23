LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Ram64k_TB IS
END Ram64k_TB;

ARCHITECTURE Rtl OF Ram64k_TB IS
    COMPONENT Ram64K
        PORT (
            clka : IN std_logic;
            ena : IN std_logic;
            wea : IN std_logic_vector(0 DOWNTO 0);
            addra : IN std_logic_vector(15 DOWNTO 0);
            dina : IN std_logic_vector(7 DOWNTO 0);
            douta : OUT std_logic_vector(7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clka : std_logic := '0';
    SIGNAL ena : std_logic := '0';
    SIGNAL wea : std_logic_vector(0 DOWNTO 0) := "0";
    SIGNAL addra : std_logic_vector(15 DOWNTO 0) := x"0000";
    SIGNAL dina : std_logic_vector(7 DOWNTO 0) := x"00";
    SIGNAL douta : std_logic_vector(7 DOWNTO 0);

    PROCEDURE waitCycles(n : NATURAL) IS
    BEGIN
        FOR i IN 1 TO n LOOP
            WAIT UNTIL falling_edge(clka);
        END LOOP;
    END PROCEDURE;
BEGIN
    uut : Ram64K PORT MAP(clka, ena, wea, addra, dina, douta);
    clka <= NOT clka AFTER 5 ns;

    PROCESS
    BEGIN
        -- write and read back
        ena <= '1';
        wea <= "1";
        addra <= x"0000";
        dina <= x"AA";
        waitCycles(1);
        wea <= "0";
        waitCycles(2);
        ASSERT douta = x"AA" SEVERITY failure;

        -- multiple write and read back
        wea <= "1";
        addra <= x"0001";
        dina <= x"01";
        waitCycles(1);
        addra <= x"0002";
        dina <= x"02";
        waitCycles(1);
        addra <= x"0003";
        dina <= x"03";
        waitCycles(1);
        wea <= "0";
        addra <= x"0001";
        waitCycles(2);
        ASSERT douta = x"01" SEVERITY failure;
        addra <= x"0002";
        waitCycles(2);
        ASSERT douta = x"02" SEVERITY failure;
        addra <= x"0003";
        waitCycles(2);
        ASSERT douta = x"03" SEVERITY failure;

        WAIT;
    END PROCESS;
END Rtl;
