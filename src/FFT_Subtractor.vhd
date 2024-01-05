LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;
--LIBRARY work;
--USE work.fixed_pkg.ALL;

ENTITY FFT_Subtractor IS
	PORT (
		Subtractor_In1, Subtractor_In2 : IN sfixed(0 DOWNTO -38);
		Subtractor_Out : OUT sfixed(1 DOWNTO -38);
		CLK : IN STD_LOGIC);
END FFT_Subtractor;

ARCHITECTURE Behavior OF FFT_Subtractor IS

	COMPONENT PIPE IS
		GENERIC (N : INTEGER := 20);
		PORT (
			D : IN sfixed (1 DOWNTO - (N - 1));
			CLK : IN STD_LOGIC;
			Q : OUT sfixed (1 DOWNTO - (N - 1)));

	END COMPONENT;

	SIGNAL SubOut, Q1 : sfixed(1 DOWNTO -38);

BEGIN

	PROCESS (Subtractor_In1, Subtractor_In2)

	BEGIN

		SubOut <= (Subtractor_In1 - Subtractor_In2);

	END PROCESS;

	livello1 : PIPE
	GENERIC MAP(N => 39)
	PORT MAP(D => SubOut, CLK => CLK, Q => Subtractor_Out);

	-- livello2 : PIPE
	-- GENERIC MAP(N => 40)
	-- PORT MAP(D => Q1, CLK => CLK, Q => Subtractor_Out);

END Behavior;