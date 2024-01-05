LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;

-------------------------------------------------
-- Multiplexer fixed point a due ingressi con numero
-- di bit impostabile parametricamente
-------------------------------------------------

ENTITY MUX2to1_Nbit_sf IS
    GENERIC (N : INTEGER := 1); --Numero di bit
    PORT (
        X, Y : IN sfixed(0 DOWNTO -N + 1);
        S : IN STD_LOGIC;
        M : OUT sfixed(0 DOWNTO -N + 1)
    );
END MUX2to1_Nbit_sf;

ARCHITECTURE Behavior OF MUX2to1_Nbit_sf IS

    COMPONENT MUX2to1_1bit IS
        PORT (
            X, Y, S : IN STD_LOGIC;
            M : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN

    WITH S SELECT
        M <= X WHEN '0',
        Y WHEN OTHERS;

END ARCHITECTURE;