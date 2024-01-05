LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------
-- Flip-flop di tipo D
-------------------------------------------------

ENTITY FF_D IS
	PORT (
		R : IN STD_LOGIC;
		Clock, Clear, Enable : IN STD_LOGIC;
		Q : OUT STD_LOGIC
	);
END FF_D;

ARCHITECTURE Behavior OF FF_D IS

BEGIN

	Register_process : PROCESS (Clock)

	BEGIN

		IF (Clock'EVENT AND Clock = '1') THEN

			IF (Clear = '1') THEN
				Q <= '0'; --Reset del valore memorizzato

			ELSIF (Enable = '1') THEN
				Q <= R; --Campionamento dell'ingresso

			END IF;

		END IF;

	END PROCESS;

END Behavior;