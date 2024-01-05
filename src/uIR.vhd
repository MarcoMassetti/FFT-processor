LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Registro senza reset
-- campiona sul fronte di discesa del clock
-------------------------------------------------

ENTITY uIR IS
    GENERIC (N : INTEGER := 32); --Numero di bit
    PORT (
        R : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        Clock : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END uIR;

ARCHITECTURE Behavior OF uIR IS

    -- inizializzo il primo valore per avere lo stato di reset iniziale
    SIGNAL Data : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := "11100000000000000000000000000000";

BEGIN

    Register_process : PROCESS (Clock)

    BEGIN

        IF (Clock'EVENT AND Clock = '0') THEN --fronte di discesa

            Data <= R; --Campionamento dell'ingresso

        END IF;

    END PROCESS;

    Q <= Data;

END Behavior;