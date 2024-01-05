LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;

-------------------------------------------------
-- Multiplexer fixed point a quattro ingressi con numero
-- di bit impostabile parametricamente
-------------------------------------------------

ENTITY MUX4to1_Nbit IS
    GENERIC (N : INTEGER := 1); --Numero di bit
    PORT (
        X, Y, Z, W : IN sfixed(0 DOWNTO -N + 1);
        S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        M : OUT sfixed(0 DOWNTO -N + 1)
    );
END MUX4to1_Nbit;

ARCHITECTURE Behavior OF MUX4to1_Nbit IS

BEGIN

    WITH S SELECT
        M <= X WHEN "00",
        Y WHEN "01",
        Z WHEN "10",
        W WHEN OTHERS;

END ARCHITECTURE;