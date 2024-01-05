LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench_CU IS
END testbench_CU;

ARCHITECTURE arch OF testbench_CU IS

    COMPONENT CU IS
        PORT (
            Clk : IN STD_LOGIC;
            Cir : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Start : IN STD_LOGIC;
            Commands : OUT STD_LOGIC_VECTOR (24 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL Clk_t : STD_LOGIC := '1';
    SIGNAL Cir_t : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Start_t : STD_LOGIC;
    SIGNAL Commands_t : STD_LOGIC_VECTOR (24 DOWNTO 0);

BEGIN

    Clk_t <= NOT Clk_t AFTER 50 ns;

    test : PROCESS
    BEGIN
        Cir_t <= "00";
        Start_t <= '0';
        WAIT FOR 1000 ns;

        Cir_t <= "00";
        Start_t <= '1';
        WAIT FOR 100 ns;

        Cir_t <= "01";
        Start_t <= '0';
        WAIT FOR 600 ns;

        Cir_t <= "10";
        Start_t <= '0';
        WAIT FOR 600 ns;

        Cir_t <= "00";
        Start_t <= '0';
        WAIT FOR 2000 ns;

        WAIT;
    END PROCESS;

    DUT : CU PORT MAP(
        Clk => Clk_t, Cir => Cir_t, Start => Start_t, Commands => Commands_t);

END ARCHITECTURE;