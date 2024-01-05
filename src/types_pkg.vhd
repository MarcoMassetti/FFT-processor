LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;

-------------------------------------------------
-- Package usato per definire i tipi di segnali usati nella FFT
-------------------------------------------------

PACKAGE types_pkg IS

	--Vettore usato per contenere i campioni di ingresso e le uscite della FFT
	TYPE vector_of_16_sfixed IS ARRAY (0 TO 15) OF sfixed (0 DOWNTO -19);

	--Array usato per contenere i valori tra i diversi stadi di butterfly
	TYPE array_of_sfixed IS ARRAY (0 TO 4) OF vector_of_16_sfixed;

	--Vettore usato per contenere i twiddle factors
	TYPE vector_of_8_sfixed IS ARRAY (0 TO 7) OF sfixed (0 DOWNTO -19);

END PACKAGE types_pkg;