LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;
USE STD.textio.ALL;
USE ieee.std_logic_textio.ALL;

-------------------------------------------------
-- Testbench per provare la modalità di savoro non continua della butterfly
-------------------------------------------------

ENTITY testbench_BUTTERFLY IS
END testbench_BUTTERFLY;

ARCHITECTURE Behavior OF testbench_BUTTERFLY IS

  COMPONENT BUTTERFLY IS
    PORT (
      Clock, Start : IN STD_LOGIC;
      Ar, Ai, Br, Bi, Wr, Wi : IN sfixed(0 DOWNTO -19);
      Done : OUT STD_LOGIC;
      A1r, A1i, B1r, B1i : OUT sfixed(0 DOWNTO -19)
    );
  END COMPONENT;

  SIGNAL Ar_t, Ai_t, Br_t, Bi_t, Wr_t, Wi_t, A1r_t, A1i_t, B1r_t, B1i_t : sfixed(0 DOWNTO -19);
  SIGNAL Clock_t : STD_LOGIC := '1';
  SIGNAL Start_t, Done_t : STD_LOGIC;

  FILE FileIn : text;
  FILE FileOut : text;

BEGIN

  DUT : BUTTERFLY
  PORT MAP(Clock => Clock_t, Start => Start_t, Done => Done_t, Ar => Ar_t, Ai => Ai_t, Br => Br_t, Bi => Bi_t, Wr => Wr_t, Wi => Wi_t, A1r => A1r_t, A1i => A1i_t, B1r => B1r_t, B1i => B1i_t);

  Clock_t <= NOT Clock_t AFTER 50 ns;

  --Processo di gestione dei file
  file_io : PROCESS

    --Variabili per lettura file
    VARIABLE InputLine : line;
    VARIABLE OutputLine : line;
    VARIABLE Ar_f, Ai_f, Br_f, Bi_f, Wr_f, Wi_f : sfixed(0 DOWNTO -19);
    VARIABLE Space : CHARACTER;

  BEGIN

    --Apertura file di input e di output
    file_open(FileIn, "input_vectors.log", read_mode);
    file_open(FileOut, "output_results.log", write_mode);

    --Letura input dal file input_vectors.txt
    WHILE NOT endfile(FileIn) LOOP
      readline(FileIn, InputLine); --Lettura riga completa
      read(InputLine, Ar_f);
      read(InputLine, Space); --Lettura spazio
      read(InputLine, Ai_f);
      read(InputLine, Space); --Lettura spazio
      read(InputLine, Br_f);
      read(InputLine, Space); --Lettura spazio
      read(InputLine, Bi_f);
      read(InputLine, Space); --Lettura spazio
      read(InputLine, Wr_f);
      read(InputLine, Space); --Lettura spazio
      read(InputLine, Wi_f);
      read(InputLine, Space); --Lettura spazio

      --Passaggio delle variabili ai segnali della butterfly
      Ar_t <= Ar_f;
      Ai_t <= Ai_f;
      Br_t <= Br_f;
      Bi_t <= Bi_f;
      Wr_t <= Wr_f;
      Wi_t <= Wi_f;
      Start_t <= '0';
      WAIT FOR 500 ns; --Attesa reset

      Start_t <= '1';
      WAIT FOR 200 ns; --Attesa campionamento segnale di start

      Start_t <= '0';
      WAIT FOR 950 ns; --Attesa risultati

      --Scrittura risultati nel file output_results.txt
      write(OutputLine, A1r_t);
      write(OutputLine, STRING'(" "));
      write(OutputLine, A1i_t);
      write(OutputLine, STRING'(" "));
      write(OutputLine, B1r_t);
      write(OutputLine, STRING'(" "));
      write(OutputLine, B1i_t);
      write(OutputLine, STRING'(" "));
      writeline(FileOut, OutputLine);

    END LOOP;

    --Chiusura file di input e di output
    file_close(FileIn);
    file_close(FileOut);

    WAIT;

  END PROCESS;

END Behavior;