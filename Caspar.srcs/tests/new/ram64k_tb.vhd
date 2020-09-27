LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Ram64K_TB IS
END Ram64K_TB;

ARCHITECTURE Rtl OF Ram64K_TB IS
    COMPONENT Ram64K IS
        PORT (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            clkb : IN STD_LOGIC;
            enb : IN STD_LOGIC;
            web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addrb : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clock : STD_LOGIC := '0';
    SIGNAL enA : STD_LOGIC := '0';
    SIGNAL wEA : STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
    SIGNAL addrA : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    SIGNAL dInA : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
    SIGNAL dOutA : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL enB : STD_LOGIC := '0';
    SIGNAL wEB : STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
    SIGNAL addrB : STD_LOGIC_VECTOR(13 DOWNTO 0) := "00000000000000";
    SIGNAL dInB : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
    SIGNAL dOutB : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    uut : Ram64K PORT MAP(clock, EnA, WEA, AddrA, DInA, DOutA, clock, EnB, WEB, AddrB, DInB, DOutB);
    clock <= NOT clock AFTER 5 ns;

    PROCESS
    BEGIN
        WAIT UNTIL falling_edge(clock);
        ASSERT dOutA = x"00" SEVERITY failure;
        ASSERT dOutB = x"00000000" SEVERITY failure;

        -- Write and Read byte
        WAIT UNTIL falling_edge(clock);
        enA <= '1';
        enB <= '0';
        wEA <= "1";
        dInA <= x"A0";
        WAIT UNTIL falling_edge(clock);
        ASSERT dOutA = x"A0" SEVERITY failure;
        ASSERT dOutB = x"00000000" SEVERITY failure;

        -- Write Multiple Bytes
        WAIT UNTIL falling_edge(clock);
        addrA <= x"0001";
        dInA <= x"A1";
        WAIT UNTIL falling_edge(clock);
        addrA <= x"0002";
        dInA <= x"A2";
        WAIT UNTIL falling_edge(clock);
        addrA <= x"0003";
        dInA <= x"A3";
        WAIT UNTIL falling_edge(clock);

        -- Read Bytes
        WAIT UNTIL falling_edge(clock);
        enB <= '1';
        wEA <= "0";
        addrA <= x"0000";
        addrB <= "00000000000000";
        WAIT UNTIL falling_edge(clock);
        ASSERT dOutA = x"A0" SEVERITY failure;
        ASSERT dOutB = x"A3A2A1A0" SEVERITY failure;

        WAIT UNTIL falling_edge(clock);
        addrA <= x"0001";
        WAIT UNTIL falling_edge(clock);
        ASSERT dOutA = x"A1" SEVERITY failure;
        ASSERT dOutB = x"A3A2A1A0" SEVERITY failure;

        WAIT UNTIL falling_edge(clock);
        addrA <= x"0002";
        WAIT UNTIL falling_edge(clock);
        ASSERT dOutA = x"A2" SEVERITY failure;
        ASSERT dOutB = x"A3A2A1A0" SEVERITY failure;

        WAIT UNTIL falling_edge(clock);
        addrA <= x"0003";
        WAIT UNTIL falling_edge(clock);
        ASSERT dOutA = x"A3" SEVERITY failure;
        ASSERT dOutB = x"A3A2A1A0" SEVERITY failure;

        WAIT;
    END PROCESS;
END Rtl;
