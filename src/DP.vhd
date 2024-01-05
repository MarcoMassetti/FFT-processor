LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;

ENTITY DP IS
	PORT (
		Clock : IN STD_LOGIC;
		En_Reg_Ar, En_Reg_Ai, En_Reg_Br, En_Reg_Bi, En_Reg_A, En_Reg_B, En_Reg_C, En_Reg_1, En_Reg_2, MUL_SH : IN STD_LOGIC;
		Sel_Mux_1, Sel_Mux_3, Sel_Mux_4, Sel_Mux_5, Sel_Mux_7, Sel_Mux_10 : IN STD_LOGIC;
		Sel_Mux_2, Sel_Mux_6, Sel_Mux_8, Sel_Mux_9 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Start, Reset_Shift_Start, Enable_Shift_Start : IN STD_LOGIC;
		Out_Shift_Start_1 : BUFFER STD_LOGIC;
		Out_Shift_Start_2 : OUT STD_LOGIC;
		Wr, Wi, Ar, Ai, Br, Bi : IN sfixed(0 DOWNTO -19);
		Ar_1, Ai_1, Br_1, Bi_1 : OUT sfixed(0 DOWNTO -19)
	);
END DP;

ARCHITECTURE Behavior OF DP IS

	COMPONENT FFT_Multiplier IS
		PORT (
			Multiplier_In1, Multiplier_In2 : IN sfixed(0 DOWNTO -19);
			XnSH, CLK : IN STD_LOGIC;
			Multiplier_Out : OUT sfixed(1 DOWNTO -38);
			SHout : OUT sfixed(0 DOWNTO -19));
	END COMPONENT;

	COMPONENT FFT_Adder IS
		PORT (
			Adder_In1, Adder_In2 : IN sfixed(0 DOWNTO -38);
			Adder_Out : OUT sfixed(1 DOWNTO -38));
	END COMPONENT;

	COMPONENT FFT_Subtractor IS
		PORT (
			Subtractor_In1, Subtractor_In2 : IN sfixed(0 DOWNTO -38);
			Subtractor_Out : OUT sfixed(1 DOWNTO -38);
			CLK : IN STD_LOGIC);
	END COMPONENT;

	COMPONENT MUX2to1_Nbit_sf IS
		GENERIC (N : INTEGER := 1); --Numero di bit
		PORT (
			X, Y : IN sfixed(0 DOWNTO -N + 1);
			S : IN STD_LOGIC;
			M : OUT sfixed(0 DOWNTO -N + 1)
		);
	END COMPONENT;

	COMPONENT MUX4to1_Nbit IS
		GENERIC (N : INTEGER := 1); --Numero di bit
		PORT (
			X, Y, Z, W : IN sfixed(0 DOWNTO -N + 1);
			S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			M : OUT sfixed(0 DOWNTO -N + 1)
		);
	END COMPONENT;

	COMPONENT REG IS
		GENERIC (N : INTEGER := 8); --Numero di bit
		PORT (
			R : IN sfixed(0 DOWNTO -N + 1);
			Clock, Clear, Enable : IN STD_LOGIC;
			Q : OUT sfixed(0 DOWNTO -N + 1)
		);
	END COMPONENT;

	COMPONENT FFT_RoundingHU IS
		PORT (
			Rounding_In : IN sfixed(0 DOWNTO -38);
			Rounding_Out : OUT sfixed(0 DOWNTO -19));

	END COMPONENT;

	COMPONENT FF_D IS
		PORT (
			R : IN STD_LOGIC;
			Clock, Clear, Enable : IN STD_LOGIC;
			Q : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL Out_Reg_Ar, Out_Reg_Ai, Out_Reg_Br, Out_Reg_Bi, Out_Reg_1, Out_Reg_2 : sfixed(0 DOWNTO -19); --Uscite registri a 20 bit
	SIGNAL Out_Reg_A, Out_Reg_B, Out_Reg_C : sfixed(0 DOWNTO -38); --Uscite registri a 39 bit
	SIGNAL Out_Mux_1, Out_Mux_2, Out_Mux_4, Out_Mux_5, Out_Mux_7, Out_Mux_10 : sfixed(0 DOWNTO -19); --Uscite multiplexer a 20 bit
	SIGNAL Out_Mux_3, Out_Mux_6, Out_Mux_8, Out_Mux_9 : sfixed(0 DOWNTO -38); --Uscite multiplexer a 39 bit
	SIGNAL Out_Multiplier : sfixed(1 DOWNTO -38); --Uscite moltiplicatore
	SIGNAL Out_Shifter, Out_Rounder : sfixed(0 DOWNTO -19); --Uscite shift moltiplicatore e rounder
	SIGNAL Out_Adder, Out_Subtractor : sfixed(1 DOWNTO -38); --Uscite sommatore e sottrattore
	SIGNAL Extended_Ar, Extended_Ai, Extended_Reg_1, Extended_Reg_2 : sfixed(0 DOWNTO -38); --Uscite dei registri estese su 39 bit
	SIGNAL Scaled_Out_Rounder : sfixed(0 DOWNTO -19); --Uscita del rounder scalata di un bit

BEGIN

	REG_AR : REG GENERIC MAP(N => 20) --Registro di ingresso usato per campionare Ar
	PORT MAP(Clock => Clock, Clear => '0', R => Ar, Enable => En_Reg_Ar, Q => Out_Reg_Ar);
	--Estensione su 39 bit dell'uscita del registro
	Extended_Ar(0 DOWNTO -19) <= Out_Reg_Ar;
	Extended_Ar(-20 DOWNTO -38) <= (OTHERS => '0');

	REG_AI : REG GENERIC MAP(N => 20) --Registro di ingresso usato per campionare Ai
	PORT MAP(Clock => Clock, Clear => '0', R => Ai, Enable => En_Reg_Ai, Q => Out_Reg_Ai);
	--Estensione su 39 bit dell'uscita del registro
	Extended_Ai(0 DOWNTO -19) <= Out_Reg_Ai;
	Extended_Ai(-20 DOWNTO -38) <= (OTHERS => '0');

	REG_BR : REG GENERIC MAP(N => 20) --Registro usato per campionare l'ngresso Br e l'uscita B'r
	PORT MAP(Clock => Clock, Clear => '0', R => Out_Mux_7, Enable => En_Reg_Br, Q => Out_Reg_Br);

	REG_BI : REG GENERIC MAP(N => 20) --Registro usato per campionare l'ngresso Bi e l'uscita B'i
	PORT MAP(Clock => Clock, Clear => '0', R => Out_Mux_10, Enable => En_Reg_Bi, Q => Out_Reg_Bi);

	REG_1 : REG GENERIC MAP(N => 20) --Registro temporaneo usato per campionare uscita shift e rounder
	PORT MAP(Clock => Clock, Clear => '0', R => Out_Mux_4, Enable => En_Reg_1, Q => Out_Reg_1);
	--Estensione su 39 bit dell'uscita del registro
	Extended_Reg_1(0 DOWNTO -19) <= Out_Reg_1;
	Extended_Reg_1(-20 DOWNTO -38) <= (OTHERS => '0');

	REG_2 : REG GENERIC MAP(N => 20) --Registro temporaneo usato per campionare uscita shift e rounder
	PORT MAP(Clock => Clock, Clear => '0', R => Out_Mux_5, Enable => En_Reg_2, Q => Out_Reg_2);
	--Estensione su 39 bit dell'uscita del registro
	Extended_Reg_2(0 DOWNTO -19) <= Out_Reg_2;
	Extended_Reg_2(-20 DOWNTO -38) <= (OTHERS => '0');

	REG_A : REG GENERIC MAP(N => 39) --Registro temporaneo usato per campionare uscita moltiplicatore
	PORT MAP(Clock => Clock, Clear => '0', R => Out_Multiplier(0 DOWNTO -38), Enable => En_Reg_A, Q => Out_Reg_A);

	REG_B : REG GENERIC MAP(N => 39) --Registro temporaneo usato per campionare uscita sommatore
	PORT MAP(Clock => Clock, Clear => '0', R => Out_Adder(0 DOWNTO -38), Enable => En_Reg_B, Q => Out_Reg_B);

	REG_C : REG GENERIC MAP(N => 39) --Registro temporaneo usato per campionare uscita sottrattore
	PORT MAP(Clock => Clock, Clear => '0', R => Out_Subtractor(0 DOWNTO -38), Enable => En_Reg_C, Q => Out_Reg_C);

	MUX_1 : MUX2to1_Nbit_sf GENERIC MAP(N => 20) --Multiplexer selezione ingresso moltiplicatore
	PORT MAP(X => Wi, Y => Wr, S => Sel_Mux_1, M => Out_Mux_1);

	MUX_2 : MUX4to1_Nbit GENERIC MAP(N => 20) --Multiplexer selezione ingresso moltiplicatore
	PORT MAP(
		X => Out_Reg_Ai, Y => Out_Reg_Ar, Z => Out_Reg_Bi, W => Out_Reg_Br,
		S => Sel_Mux_2, M => Out_Mux_2);

	MUX_3 : MUX2to1_Nbit_sf GENERIC MAP(N => 39) --Multiplexer selezione ingresso rounder
	PORT MAP(X => Out_Reg_C, Y => Out_Reg_B, S => Sel_Mux_3, M => Out_Mux_3);

	MUX_4 : MUX2to1_Nbit_sf GENERIC MAP(N => 20) --Multiplexer selezione ingresso registro 1
	PORT MAP(X => Scaled_Out_Rounder, Y => Out_Shifter, S => Sel_Mux_4, M => Out_Mux_4);

	MUX_5 : MUX2to1_Nbit_sf GENERIC MAP(N => 20) --Multiplexer selezione ingresso registro 2
	PORT MAP(X => Scaled_Out_Rounder, Y => Out_Shifter, S => Sel_Mux_5, M => Out_Mux_5);

	MUX_6 : MUX4to1_Nbit GENERIC MAP(N => 39) --Multiplexer selezione ingresso sommatore
	PORT MAP(
		X => Out_Reg_B, Y => Extended_Ar, Z => Extended_Ai, W => (OTHERS => '0'),
		S => Sel_Mux_6, M => Out_Mux_6);

	MUX_7 : MUX2to1_Nbit_sf GENERIC MAP(N => 20) --Multiplexer selezione ingresso registro Br
	PORT MAP(X => Scaled_Out_Rounder, Y => Br, S => Sel_Mux_7, M => Out_Mux_7);

	MUX_8 : MUX4to1_Nbit GENERIC MAP(N => 39) --Multiplexer selezione ingresso sottrattore
	PORT MAP(
		X => Out_Reg_C, Y => Out_Reg_B, Z => Out_Reg_A, W => (OTHERS => '0'),
		S => Sel_Mux_8, M => Out_Mux_8);

	MUX_9 : MUX4to1_Nbit GENERIC MAP(N => 39) --Multiplexer selezione ingresso sottrattore
	PORT MAP(
		X => Out_Reg_B, Y => Extended_Reg_2, Z => Extended_Reg_1, W => (OTHERS => '0'),
		S => Sel_Mux_9, M => Out_Mux_9);

	MUX_10 : MUX2to1_Nbit_sf GENERIC MAP(N => 20) --Multiplexer selezione ingresso registro Bi
	PORT MAP(X => Scaled_Out_Rounder, Y => Bi, S => Sel_Mux_10, M => Out_Mux_10);

	MULTIPLIER : FFT_Multiplier --Moltiplicatore a 20 bit
	PORT MAP(
		Multiplier_In1 => Out_Mux_1, Multiplier_In2 => Out_Mux_2,
		XnSH => MUL_SH, CLK => Clock, Multiplier_Out => Out_Multiplier, SHout => Out_Shifter);

	ADDER : FFT_Adder --Sommatore a 39 bit
	PORT MAP(Adder_In1 => Out_Reg_A, Adder_In2 => Out_Mux_6, Adder_Out => Out_Adder);

	SUBTRACTOR : FFT_Subtractor --Sottrattore a 39 bit
	PORT MAP(Subtractor_In1 => Out_Mux_9, Subtractor_In2 => Out_Mux_8, Subtractor_Out => Out_Subtractor, CLK => Clock);

	SHIFT_START_1 : FF_D --FF usato per tenere conto dei segnali di start ricevuti
	PORT MAP(Clock => Clock, Clear => Reset_Shift_Start, R => Start, Enable => Enable_Shift_Start, Q => Out_Shift_Start_1);

	SHIFT_START_2 : FF_D --FF usato per tenere conto dei segnali di start ricevuti
	PORT MAP(Clock => Clock, Clear => Reset_Shift_Start, R => Out_Shift_Start_1, Enable => Enable_Shift_Start, Q => Out_Shift_Start_2);

	ROUNDER : FFT_RoundingHU --Half up rounder da 39 a 20 bit
	PORT MAP(Rounding_In => Out_Mux_3, Rounding_Out => Out_Rounder);

	Scaled_Out_Rounder <= Out_Rounder(0) & Out_Rounder(0 DOWNTO -18); --Scalamento uscita rounder

	--Assegnazioni dei segnali di uscita
	Ar_1 <= Out_Reg_1;
	Ai_1 <= Out_Reg_2;
	Br_1 <= Out_Reg_Br;
	Bi_1 <= Out_Reg_Bi;

END ARCHITECTURE;