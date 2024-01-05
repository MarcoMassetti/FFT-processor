LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;
USE ieee.numeric_std.ALL;

ENTITY FFT_Multiplier IS
	PORT (
		Multiplier_In1, Multiplier_In2 : IN sfixed(0 DOWNTO -19);
		XnSH, CLK : IN STD_LOGIC;
		Multiplier_Out : OUT sfixed(1 DOWNTO -38);
		SHout : OUT sfixed(0 DOWNTO -19));

END FFT_Multiplier;

ARCHITECTURE Behavior OF FFT_Multiplier IS

	COMPONENT PIPE IS
		GENERIC (N : INTEGER := 39);
		PORT (
			D : IN sfixed (1 DOWNTO - (N - 1));
			CLK : IN STD_LOGIC;
			Q : OUT sfixed (1 DOWNTO - (N - 1)));
	END COMPONENT;

	SIGNAL A, B : sfixed(0 DOWNTO -19);
	SIGNAL Xout, Q1, Q2 : sfixed(1 DOWNTO -38);

BEGIN

	A <= Multiplier_In1;
	B <= Multiplier_In2;
	PROCESS (A, B, XnSH)

	BEGIN
		IF (XnSH = '0') THEN

			Xout <= (A * B);

		ELSE

			SHout <= shift_left(sfixed(B), 1);

		END IF;

	END PROCESS;

	livello1 : PIPE
	GENERIC MAP(N => 39)
	PORT MAP(D => Xout, CLK => CLK, Q => Q1);

	livello2 : PIPE
	GENERIC MAP(N => 39)
	PORT MAP(D => Q1, CLK => CLK, Q => Multiplier_Out);

	-- livello3 : PIPE
	-- GENERIC MAP(N => 39)
	-- PORT MAP(D => Q2, CLK => CLK, Q => Multiplier_Out);
END Behavior;