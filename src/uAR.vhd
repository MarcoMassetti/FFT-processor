LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Registro senza reset con primo valore 111
-- campiona sul fronte di salita del clock
-------------------------------------------------

ENTITY uAR IS
    GENERIC (N : INTEGER := 3); --Numero di bit
    PORT (
        R : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Clock : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END uAR;

ARCHITECTURE Behavior OF uAR IS

    -- inizializzo il primo valore per avere lo stato di reset iniziale
    SIGNAL Data : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := "111";

BEGIN

    Register_process : PROCESS (Clock)

    BEGIN

        IF (Clock'EVENT AND Clock = '1') THEN

            Data <= R; --Campionamento dell'ingresso

        END IF;

    END PROCESS;

    Q <= Data;

END Behavior;