LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-------------------------------------------------
-- Control Unit
-------------------------------------------------

ENTITY CU IS
    PORT (
        Clk : IN STD_LOGIC;
        Cir : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- bit dei FF
        Start : IN STD_LOGIC;
        Commands : OUT STD_LOGIC_VECTOR (26 DOWNTO 0) -- bit di comando del DP
    );
END CU;

ARCHITECTURE Behaviuor OF CU IS

    COMPONENT ROM IS
        PORT (
            Adr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT uIR IS
        GENERIC (N : INTEGER := 31); --Numero di bit
        PORT (
            R : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Clock : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT PLA IS
        PORT (
            Jump, Cir : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Start : IN STD_LOGIC;
            Sel : OUT STD_LOGIC;
            Address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT MUX2to1_Nbit IS
        GENERIC (N : INTEGER := 3); --Numero di bit
        PORT (
            X, Y : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            S : IN STD_LOGIC;
            M : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT uAR IS
        GENERIC (N : INTEGER := 3); --Numero di bit
        PORT (
            R : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Clock : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL Code_i : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL Adr_i, NextAdr_i, PlaAdr_i, MuxAdr_i : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Jump_i : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Sel_i : STD_LOGIC;

BEGIN

    ROM_CU : ROM PORT MAP(
        Adr => Adr_i, Dout => Code_i);

    uIR_CU : uIR GENERIC MAP(N => 32)
    PORT MAP(
        R => Code_i, Clock => Clk, Q(31 DOWNTO 29) => NextAdr_i,
        Q(28 DOWNTO 27) => Jump_i, Q(26 DOWNTO 0) => Commands);

    PLA_CU : PLA PORT MAP(
        Jump => Jump_i, Cir => Cir, Start => Start, Sel => Sel_i, Address => PlaAdr_i);

    MUX_CU : MUX2to1_Nbit GENERIC MAP(N => 3)
    PORT MAP(X => NextAdr_i, Y => PlaAdr_i, S => Sel_i, M => MuxAdr_i);

    uAR_CU : uAR GENERIC MAP(N => 3)
    PORT MAP(R => MuxAdr_i, Clock => Clk, Q => Adr_i);

END ARCHITECTURE;