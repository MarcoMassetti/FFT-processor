LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;
USE ieee.numeric_std.ALL;

ENTITY FFT_RoundingHU IS
	PORT (--CLK : in std_logic;
		Rounding_In : IN sfixed(0 DOWNTO -38);
		Rounding_Out : OUT sfixed(0 DOWNTO -19));

END FFT_RoundingHU;

ARCHITECTURE Behavior OF FFT_RoundingHU IS

	SIGNAL Res, one : sfixed(0 DOWNTO -19);
	SIGNAL Sum : sfixed(1 DOWNTO -19);

BEGIN

	Res <= Rounding_In(0 DOWNTO -19);

	--one <= to_sfixed(0.00000095367431640625, one);
	--Sum <= to_sfixed(0.0, Sum);
	one <= "00000000000000000001";

	Sum <= Res + one;
	Rounding_Out <= Sum(0 DOWNTO -19);
END Behavior;