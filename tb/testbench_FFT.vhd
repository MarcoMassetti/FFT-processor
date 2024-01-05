LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;
USE work.types_pkg.ALL;

-------------------------------------------------
-- Testbench FFT
-------------------------------------------------

ENTITY testbench_FFT IS
END testbench_FFT;

ARCHITECTURE Behavior OF testbench_FFT IS

	COMPONENT FFT IS
		PORT (
			Clock, Start : IN STD_LOGIC;
			Inputs_r, Inputs_i : IN vector_of_16_sfixed;
			Done : OUT STD_LOGIC;
			Outputs_r, Outputs_i : OUT vector_of_16_sfixed
		);
	END COMPONENT;

	SIGNAL Clk_t : STD_LOGIC := '1';
	SIGNAL Start_t, Done_t : STD_LOGIC;
	SIGNAL Inputs_r_t, Inputs_i_t, Outputs_r_t, Outputs_i_t : vector_of_16_sfixed;

BEGIN

	Clk_t <= NOT Clk_t AFTER 50 ns;

	Inputs_i_t <= (OTHERS => to_sfixed(0, Inputs_i_t(0)));

	-- Inputs_r_t <= (--1
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)),
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)),
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)),
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)));

	-- Inputs_r_t <= (--2
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)));

	-- Inputs_r_t <= (--3
	-- 	to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
	-- 	to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
	-- 	to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
	-- 	to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)));

	-- Inputs_r_t <= (--4
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)),
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)),
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)),
	-- 	to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)));

	-- Inputs_r_t <= (--5
	-- 	to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)),
	-- 	to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)),
	-- 	to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)),
	-- 	to_sfixed(-0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)));

	-- Inputs_r_t <= (--6
	-- 	to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
	-- 	to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
	-- 	to_sfixed(0.75/4, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
	-- 	to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)));

	-- Inputs_r_t <= (
	-- 	to_sfixed(0, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)),
	-- 	to_sfixed(0, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)),
	-- 	to_sfixed(0, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)),
	-- 	to_sfixed(0, Inputs_r_t(0)), to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)));

	test : PROCESS
	BEGIN

		Inputs_r_t <= (--1
			to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)),
			to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)),
			to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)),
			to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)), to_sfixed(-0.25, Inputs_r_t(0)));

		Start_t <= '0';
		WAIT FOR 550 ns;

		Start_t <= '1';
		WAIT FOR 200 ns;

		Inputs_r_t <= (--3
			to_sfixed(0.25, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
			to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
			to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)),
			to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)), to_sfixed(0, Inputs_r_t(0)));
		WAIT FOR 600 ns;

		Inputs_r_t <= (--5
			to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)),
			to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(0.125, Inputs_r_t(0)),
			to_sfixed(0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)),
			to_sfixed(-0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)), to_sfixed(-0.125, Inputs_r_t(0)));
		WAIT FOR 600 ns;

		Start_t <= '0';
		WAIT FOR 2 ms;

		WAIT;
	END PROCESS;

	DUT : FFT PORT MAP(
		Clock => Clk_t, Start => Start_t, Inputs_r => Inputs_r_t, Inputs_i => Inputs_i_t, Done => Done_t,
		Outputs_r => Outputs_r_t, Outputs_i => Outputs_i_t);

END ARCHITECTURE;