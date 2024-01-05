LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;

-------------------------------------------------
-- Butterfly a 20 bit
-------------------------------------------------

ENTITY BUTTERFLY IS
	PORT (
		Clock, Start : IN STD_LOGIC;
		Ar, Ai, Br, Bi, Wr, Wi : IN sfixed(0 DOWNTO -19);
		Done : OUT STD_LOGIC;
		A1r, A1i, B1r, B1i : OUT sfixed(0 DOWNTO -19)
	);
END BUTTERFLY;

ARCHITECTURE Behavior OF BUTTERFLY IS

	COMPONENT DP IS
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
	END COMPONENT;

	COMPONENT CU IS
		PORT (
			Clk : IN STD_LOGIC;
			Cir : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Start : IN STD_LOGIC;
			Commands : OUT STD_LOGIC_VECTOR (26 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL Command_i : STD_LOGIC_VECTOR(26 DOWNTO 0); --Comandi control unit
	SIGNAL Shift_Start_i : STD_LOGIC_VECTOR(1 DOWNTO 0); --Uscita shift register start

BEGIN

	DATAPATH : DP PORT MAP(
		Clock => Clock, En_Reg_Ar => Command_i(26), En_Reg_Ai => Command_i(25), En_Reg_Br => Command_i(24), En_Reg_Bi => Command_i(23),
		En_Reg_A => Command_i(22), En_Reg_B => Command_i(21), En_Reg_C => Command_i(20), En_Reg_1 => Command_i(19), En_Reg_2 => Command_i(18), MUL_SH => Command_i(3),
		Sel_Mux_1 => Command_i(17), Sel_Mux_2 => Command_i(16 DOWNTO 15), Sel_Mux_3 => Command_i(14), Sel_Mux_4 => Command_i(13), Sel_Mux_5 => Command_i(12), Sel_Mux_6 => Command_i(11 DOWNTO 10), Sel_Mux_7 => Command_i(9), Sel_Mux_8 => Command_i(8 DOWNTO 7), Sel_Mux_9 => Command_i(6 DOWNTO 5), Sel_Mux_10 => Command_i(4),
		Start => Start, Reset_Shift_Start => Command_i(0), Enable_Shift_Start => Command_i(1), Out_Shift_Start_1 => Shift_Start_i(0), Out_Shift_Start_2 => Shift_Start_i(1),
		Wr => Wr, Wi => Wi, Ar => Ar, Ai => Ai, Br => Br, Bi => Bi,
		Ar_1 => A1r, Ai_1 => A1i, Br_1 => B1r, Bi_1 => B1i);

	C_U : CU PORT MAP(Clk => Clock, Cir => Shift_Start_i, Start => Start, Commands => Command_i);

	Done <= Command_i(2);

END ARCHITECTURE;