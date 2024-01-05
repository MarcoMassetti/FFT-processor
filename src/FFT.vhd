LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;
USE work.types_pkg.ALL;

-------------------------------------------------
-- FFT 16x16 a 20 bit
-------------------------------------------------

ENTITY FFT IS
	PORT (
		Clock, Start : IN STD_LOGIC;
		Inputs_r, Inputs_i : IN vector_of_16_sfixed;
		Done : OUT STD_LOGIC;
		Outputs_r, Outputs_i : OUT vector_of_16_sfixed
	);
END FFT;

ARCHITECTURE Behavior OF FFT IS

	COMPONENT BUTTERFLY IS
		PORT (
			Clock, Start : IN STD_LOGIC;
			Ar, Ai, Br, Bi, Wr, Wi : IN sfixed(0 DOWNTO -19);
			Done : OUT STD_LOGIC;
			A1r, A1i, B1r, B1i : OUT sfixed(0 DOWNTO -19)
		);
	END COMPONENT;

	--Valori reali e immaginari tra le diverse butterfly.
	--Sono matrici di sfixed, primo indice indica il livello, 
	--secondo indice indica il numero della labbetfly nel livello
	SIGNAL Val_R, Val_I : array_of_sfixed;

	--Segnali di start e done tra i diversi stadi di butterfly.
	--Viene usato il done di una sola butterfly di uno stadio
	--per dare lo start a tutte le butterfly dello stadio successivo
	SIGNAL Stard_Done : STD_LOGIC_VECTOR(4 DOWNTO 0);

	--Parte reale dei twiddle factors
	CONSTANT Wr : vector_of_8_sfixed := (
		to_sfixed(1, 0, -19), to_sfixed(0.923879532511287, 0, -19), to_sfixed(0.707106781186548, 0, -19), to_sfixed(0.382683432365090, 0, -19),
		to_sfixed(0, 0, -19), to_sfixed(-0.382683432365090, 0, -19), to_sfixed(-0.707106781186547, 0, -19), to_sfixed(-0.923879532511287, 0, -19)
	);

	--Parte immaginaria dei twiddle factors
	CONSTANT Wi : vector_of_8_sfixed := (
		to_sfixed(0, 0, -19), to_sfixed(-0.382683432365090, 0, -19), to_sfixed(-0.707106781186547, 0, -19), to_sfixed(-0.923879532511287, 0, -19),
		to_sfixed(-1, 0, -19), to_sfixed(-0.923879532511287, 0, -19), to_sfixed(-0.707106781186547, 0, -19), to_sfixed(-0.382683432365090, 0, -19)
	);

BEGIN

	Stard_Done(0) <= Start; --Collegamento segnale di start primo stadio di butterfly
	Val_R(0) <= Inputs_r; --Collegamento ingresso parte reale primo stadio di butterfly
	Val_I(0) <= Inputs_i; --Collegamento ingresso immaginaria reale primo stadio di butterfly

	Outputs_r <= Val_R(4); --Collegamento uscita parte reale ultimo stadio di butterfly
	Outputs_i <= Val_I(4); --Collegamento uscita parte immaginaria ultimo stadio di butterfly
	Done <= Stard_Done(4); --Collegamento segnale di done ultimo stadio di butterfly

	---------------------------------
	--Primo stadio di butterfly
	---------------------------------
	--I numeri nel nome del componente indicano rispettivamente:
	--il numero dello stadio; il numero del gruppo; il numero della butterfly nel gruppo
	BUTTERFLY_0_0_0 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(0), Done => Stard_Done(1),
		Ar => Val_R(0)(0), Ai => Val_I(0)(0), Br => Val_R(0)(8), Bi => Val_I(0)(8),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(1)(0), A1i => Val_I(1)(0), B1r => Val_R(1)(8), B1i => Val_I(1)(8));

	BUTTERFLY_0_0_1 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(0),
		Ar => Val_R(0)(1), Ai => Val_I(0)(1), Br => Val_R(0)(9), Bi => Val_I(0)(9),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(1)(1), A1i => Val_I(1)(1), B1r => Val_R(1)(9), B1i => Val_I(1)(9));

	BUTTERFLY_0_0_2 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(0),
		Ar => Val_R(0)(2), Ai => Val_I(0)(2), Br => Val_R(0)(10), Bi => Val_I(0)(10),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(1)(2), A1i => Val_I(1)(2), B1r => Val_R(1)(10), B1i => Val_I(1)(10));

	BUTTERFLY_0_0_3 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(0),
		Ar => Val_R(0)(3), Ai => Val_I(0)(3), Br => Val_R(0)(11), Bi => Val_I(0)(11),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(1)(3), A1i => Val_I(1)(3), B1r => Val_R(1)(11), B1i => Val_I(1)(11));

	BUTTERFLY_0_0_4 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(0),
		Ar => Val_R(0)(4), Ai => Val_I(0)(4), Br => Val_R(0)(12), Bi => Val_I(0)(12),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(1)(4), A1i => Val_I(1)(4), B1r => Val_R(1)(12), B1i => Val_I(1)(12));

	BUTTERFLY_0_0_5 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(0),
		Ar => Val_R(0)(5), Ai => Val_I(0)(5), Br => Val_R(0)(13), Bi => Val_I(0)(13),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(1)(5), A1i => Val_I(1)(5), B1r => Val_R(1)(13), B1i => Val_I(1)(13));

	BUTTERFLY_0_0_6 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(0),
		Ar => Val_R(0)(6), Ai => Val_I(0)(6), Br => Val_R(0)(14), Bi => Val_I(0)(14),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(1)(6), A1i => Val_I(1)(6), B1r => Val_R(1)(14), B1i => Val_I(1)(14));

	BUTTERFLY_0_0_7 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(0),
		Ar => Val_R(0)(7), Ai => Val_I(0)(7), Br => Val_R(0)(15), Bi => Val_I(0)(15),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(1)(7), A1i => Val_I(1)(7), B1r => Val_R(1)(15), B1i => Val_I(1)(15));

	---------------------------------
	--Secondo stadio di butterfly
	---------------------------------
	BUTTERFLY_1_0_0 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(1), Done => Stard_Done(2),
		Ar => Val_R(1)(0), Ai => Val_I(1)(0), Br => Val_R(1)(4), Bi => Val_I(1)(4),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(2)(0), A1i => Val_I(2)(0), B1r => Val_R(2)(4), B1i => Val_I(2)(4));

	BUTTERFLY_1_0_1 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(1),
		Ar => Val_R(1)(1), Ai => Val_I(1)(1), Br => Val_R(1)(5), Bi => Val_I(1)(5),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(2)(1), A1i => Val_I(2)(1), B1r => Val_R(2)(5), B1i => Val_I(2)(5));

	BUTTERFLY_1_0_2 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(1),
		Ar => Val_R(1)(2), Ai => Val_I(1)(2), Br => Val_R(1)(6), Bi => Val_I(1)(6),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(2)(2), A1i => Val_I(2)(2), B1r => Val_R(2)(6), B1i => Val_I(2)(6));

	BUTTERFLY_1_0_3 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(1),
		Ar => Val_R(1)(3), Ai => Val_I(1)(3), Br => Val_R(1)(7), Bi => Val_I(1)(7),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(2)(3), A1i => Val_I(2)(3), B1r => Val_R(2)(7), B1i => Val_I(2)(7));

	BUTTERFLY_1_1_0 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(1),
		Ar => Val_R(1)(8), Ai => Val_I(1)(8), Br => Val_R(1)(12), Bi => Val_I(1)(12),
		Wr => Wr(4), Wi => Wi(4),
		A1r => Val_R(2)(8), A1i => Val_I(2)(8), B1r => Val_R(2)(12), B1i => Val_I(2)(12));

	BUTTERFLY_1_1_1 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(1),
		Ar => Val_R(1)(9), Ai => Val_I(1)(9), Br => Val_R(1)(13), Bi => Val_I(1)(13),
		Wr => Wr(4), Wi => Wi(4),
		A1r => Val_R(2)(9), A1i => Val_I(2)(9), B1r => Val_R(2)(13), B1i => Val_I(2)(13));

	BUTTERFLY_1_1_2 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(1),
		Ar => Val_R(1)(10), Ai => Val_I(1)(10), Br => Val_R(1)(14), Bi => Val_I(1)(14),
		Wr => Wr(4), Wi => Wi(4),
		A1r => Val_R(2)(10), A1i => Val_I(2)(10), B1r => Val_R(2)(14), B1i => Val_I(2)(14));

	BUTTERFLY_1_1_3 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(1),
		Ar => Val_R(1)(11), Ai => Val_I(1)(11), Br => Val_R(1)(15), Bi => Val_I(1)(15),
		Wr => Wr(4), Wi => Wi(4),
		A1r => Val_R(2)(11), A1i => Val_I(2)(11), B1r => Val_R(2)(15), B1i => Val_I(2)(15));

	---------------------------------
	--Terzo stadio di butterfly
	---------------------------------
	BUTTERFLY_2_0_0 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(2), Done => Stard_Done(3),
		Ar => Val_R(2)(0), Ai => Val_I(2)(0), Br => Val_R(2)(2), Bi => Val_I(2)(2),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(3)(0), A1i => Val_I(3)(0), B1r => Val_R(3)(2), B1i => Val_I(3)(2));

	BUTTERFLY_2_0_1 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(2),
		Ar => Val_R(2)(1), Ai => Val_I(2)(1), Br => Val_R(2)(3), Bi => Val_I(2)(3),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(3)(1), A1i => Val_I(3)(1), B1r => Val_R(3)(3), B1i => Val_I(3)(3));

	BUTTERFLY_2_1_0 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(2),
		Ar => Val_R(2)(4), Ai => Val_I(2)(4), Br => Val_R(2)(6), Bi => Val_I(2)(6),
		Wr => Wr(4), Wi => Wi(4),
		A1r => Val_R(3)(4), A1i => Val_I(3)(4), B1r => Val_R(3)(6), B1i => Val_I(3)(6));

	BUTTERFLY_2_1_1 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(2),
		Ar => Val_R(2)(5), Ai => Val_I(2)(5), Br => Val_R(2)(7), Bi => Val_I(2)(7),
		Wr => Wr(4), Wi => Wi(4),
		A1r => Val_R(3)(5), A1i => Val_I(3)(5), B1r => Val_R(3)(7), B1i => Val_I(3)(7));

	BUTTERFLY_2_2_0 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(2),
		Ar => Val_R(2)(8), Ai => Val_I(2)(8), Br => Val_R(2)(10), Bi => Val_I(2)(10),
		Wr => Wr(2), Wi => Wi(2),
		A1r => Val_R(3)(8), A1i => Val_I(3)(8), B1r => Val_R(3)(10), B1i => Val_I(3)(10));

	BUTTERFLY_2_2_1 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(2),
		Ar => Val_R(2)(9), Ai => Val_I(2)(9), Br => Val_R(2)(11), Bi => Val_I(2)(11),
		Wr => Wr(2), Wi => Wi(2),
		A1r => Val_R(3)(9), A1i => Val_I(3)(9), B1r => Val_R(3)(11), B1i => Val_I(3)(11));

	BUTTERFLY_2_3_0 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(2),
		Ar => Val_R(2)(12), Ai => Val_I(2)(12), Br => Val_R(2)(14), Bi => Val_I(2)(14),
		Wr => Wr(6), Wi => Wi(6),
		A1r => Val_R(3)(12), A1i => Val_I(3)(12), B1r => Val_R(3)(14), B1i => Val_I(3)(14));

	BUTTERFLY_2_3_1 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(2),
		Ar => Val_R(2)(13), Ai => Val_I(2)(13), Br => Val_R(2)(15), Bi => Val_I(2)(15),
		Wr => Wr(6), Wi => Wi(6),
		A1r => Val_R(3)(13), A1i => Val_I(3)(13), B1r => Val_R(3)(15), B1i => Val_I(3)(15));

	---------------------------------
	--Quarto stadio di butterfly
	---------------------------------
	BUTTERFLY_3_0_0 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(3), Done => Stard_Done(4),
		Ar => Val_R(3)(0), Ai => Val_I(3)(0), Br => Val_R(3)(1), Bi => Val_I(3)(1),
		Wr => Wr(0), Wi => Wi(0),
		A1r => Val_R(4)(0), A1i => Val_I(4)(0), B1r => Val_R(4)(1), B1i => Val_I(4)(1));

	BUTTERFLY_3_1_1 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(3),
		Ar => Val_R(3)(2), Ai => Val_I(3)(2), Br => Val_R(3)(3), Bi => Val_I(3)(3),
		Wr => Wr(4), Wi => Wi(4),
		A1r => Val_R(4)(2), A1i => Val_I(4)(2), B1r => Val_R(4)(3), B1i => Val_I(4)(3));

	BUTTERFLY_3_2_2 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(3),
		Ar => Val_R(3)(4), Ai => Val_I(3)(4), Br => Val_R(3)(5), Bi => Val_I(3)(5),
		Wr => Wr(2), Wi => Wi(2),
		A1r => Val_R(4)(4), A1i => Val_I(4)(4), B1r => Val_R(4)(5), B1i => Val_I(4)(5));

	BUTTERFLY_3_3_3 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(3),
		Ar => Val_R(3)(6), Ai => Val_I(3)(6), Br => Val_R(3)(7), Bi => Val_I(3)(7),
		Wr => Wr(6), Wi => Wi(6),
		A1r => Val_R(4)(6), A1i => Val_I(4)(6), B1r => Val_R(4)(7), B1i => Val_I(4)(7));

	BUTTERFLY_3_4_4 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(3),
		Ar => Val_R(3)(8), Ai => Val_I(3)(8), Br => Val_R(3)(9), Bi => Val_I(3)(9),
		Wr => Wr(1), Wi => Wi(1),
		A1r => Val_R(4)(8), A1i => Val_I(4)(8), B1r => Val_R(4)(9), B1i => Val_I(4)(9));

	BUTTERFLY_3_5_5 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(3),
		Ar => Val_R(3)(10), Ai => Val_I(3)(10), Br => Val_R(3)(11), Bi => Val_I(3)(11),
		Wr => Wr(5), Wi => Wi(5),
		A1r => Val_R(4)(10), A1i => Val_I(4)(10), B1r => Val_R(4)(11), B1i => Val_I(4)(11));

	BUTTERFLY_3_6_6 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(3),
		Ar => Val_R(3)(12), Ai => Val_I(3)(12), Br => Val_R(3)(13), Bi => Val_I(3)(13),
		Wr => Wr(3), Wi => Wi(3),
		A1r => Val_R(4)(12), A1i => Val_I(4)(12), B1r => Val_R(4)(13), B1i => Val_I(4)(13));

	BUTTERFLY_3_7_7 : BUTTERFLY PORT MAP(
		Clock => Clock, Start => Stard_Done(3),
		Ar => Val_R(3)(14), Ai => Val_I(3)(14), Br => Val_R(3)(15), Bi => Val_I(3)(15),
		Wr => Wr(7), Wi => Wi(7),
		A1r => Val_R(4)(14), A1i => Val_I(4)(14), B1r => Val_R(4)(15), B1i => Val_I(4)(15));

END ARCHITECTURE;