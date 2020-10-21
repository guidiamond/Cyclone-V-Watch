LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY button IS
  GENERIC (
    dataWidth : NATURAL := 4
  );
  PORT (
    input  : IN std_logic_vector(2 DOWNTO 0);
    enable : IN std_logic_vector(2 DOWNTO 0);
    output    : OUT std_logic_vector(7 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE comportamento OF button IS
BEGIN
  output <= "0000000" & input(0) WHEN enable(0) = '1' ELSE
    "0000000" & input(1) WHEN enable(1) = '1' ELSE
    "0000000" & input(2) WHEN enable(2) = '1' ELSE
    (OTHERS => 'Z');
END ARCHITECTURE;