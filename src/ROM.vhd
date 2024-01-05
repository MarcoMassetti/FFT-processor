LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

----------------------------
---ROM
----------------------------

ENTITY ROM IS
    PORT (
        Adr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        Dout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END ROM;

ARCHITECTURE rtl OF ROM IS

    TYPE Mem IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    CONSTANT Rom_7 : Mem := (

        --la prima riga indica la suddivsione dei bit e serve a comprendere meglio il loro compito

        --adr  jump    register      mux               done   cir  c_clr
        --0 IDLE
        "000" & "01" & "111111101" & "000001101000011" & "0" & "1" & "0",
        --1
        "010" & "00" & "000001010" & "111000000001000" & "0" & "0" & "0",
        --2
        "011" & "00" & "000000101" & "010100000010100" & "0" & "0" & "0",
        --3
        "100" & "00" & "001010100" & "011000000000000" & "0" & "0" & "0",
        --4
        "101" & "10" & "000111000" & "110000010000000" & "0" & "0" & "0",
        --5
        "000" & "00" & "000010010" & "001010001100011" & "0" & "0" & "0",
        --6 DONE è uguale allo stato 5 tranne per il done
        "000" & "00" & "000010010" & "001010001100011" & "1" & "0" & "0",
        --7 RESET
        "000" & "00" & "000000000" & "000000000000000" & "0" & "0" & "1"
    );

BEGIN

    memory : PROCESS (Adr)
    BEGIN
        Dout <= Rom_7(to_integer(unsigned(Adr)));
    END PROCESS memory;

END ARCHITECTURE;