LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ButtonInterface IS
  GENERIC (
    dataWidth : NATURAL := 4
  );
  PORT (
    input  : IN std_logic_vector(dataWidth - 1 DOWNTO 0);
    enable : IN std_logic_vector(dataWidth - 1 DOWNTO 0);
    output    : OUT std_logic_vector(7 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE comportamento OF ButtonInterface IS
BEGIN
  output <= "0000000" & enable(0) WHEN input(0) = '1' ELSE
    "0000000" & enable(1) WHEN input(1) = '1' ELSE
    "0000000" & enable(2) WHEN input(2) = '1' ELSE
    "0000000" & enable(3) WHEN input(3) = '1' ELSE
    (OTHERS => 'Z');
END ARCHITECTURE;
