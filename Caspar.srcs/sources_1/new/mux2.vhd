LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Mux2 IS
    PORT (
        A : IN std_logic_vector(7 DOWNTO 0);
        B : IN std_logic_vector(7 DOWNTO 0);
        Sel : IN std_logic;
        O : OUT std_logic_vector(7 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Rtl OF Mux2 IS
BEGIN
    WITH Sel SELECT O <=
        B WHEN '1',
        A WHEN OTHERS;
END ARCHITECTURE;
