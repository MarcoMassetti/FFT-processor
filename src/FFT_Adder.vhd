LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;
--LIBRARY work;
--USE work.fixed_pkg.ALL;

ENTITY FFT_Adder IS
	PORT (
		Adder_In1, Adder_In2 : IN sfixed(0 DOWNTO -38);
		Adder_Out : OUT sfixed(1 DOWNTO -38));
END FFT_Adder;

ARCHITECTURE Behavior OF FFT_Adder IS
BEGIN

	PROCESS (Adder_In1, Adder_In2)

	BEGIN

		Adder_Out <= (Adder_In1 + Adder_In2);

	END PROCESS;

END Behavior;