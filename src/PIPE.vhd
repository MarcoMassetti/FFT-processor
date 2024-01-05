library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;

entity PIPE is 
generic  (N : integer := 20);
	port (  D : in sfixed ( 1 downto -(N-1));
		CLK : in std_logic;
		Q : out sfixed (1 downto -(N-1)));

end PIPE;

architecture Behavior of PIPE is 

begin 

  process (CLK)
  begin
  
    if CLK'event and CLK = '1' then
     
       Q <= D;

    end if;
   
   end process;

end Behavior;

