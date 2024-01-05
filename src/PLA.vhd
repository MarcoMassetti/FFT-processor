LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- PLA
-- a seconda dei bit ricevuti dal DP e dai bit di jump
-- decide se fare o meno il salto di indirizzo
-- in caso di salto cambia il bit di selezione del mux
-------------------------------------------------

ENTITY PLA IS
    PORT (
        Jump, Cir : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Start : IN STD_LOGIC;
        Sel : OUT STD_LOGIC;
        Address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
    );
END PLA;

ARCHITECTURE rtl OF PLA IS

BEGIN

    PLA : PROCESS (Jump, Cir, Start)

    BEGIN

        IF (Jump = "01" AND(Start = '1' OR Cir(0) = '1')) THEN
            -- salto dallo stato 0 ad 1
            Sel <= '1';
            Address <= "001";
        ELSIF (Jump = "10" AND Cir(1) = '1') THEN
            -- salto dallo stato 4 a 6 in caso in cui devo dare il done
            Sel <= '1';
            Address <= "110";
        ELSE
            -- non ho un jump e quindi l'indirizzo successivo è quello contenuto nella ROM
            Sel <= '0';
        END IF;

    END PROCESS;

END ARCHITECTURE;