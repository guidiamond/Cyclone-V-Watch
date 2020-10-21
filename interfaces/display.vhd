LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY display IS
  GENERIC (
    DATA_WIDTH : NATURAL := 4
  );

  PORT (
    input                             : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    enable                             : IN std_logic_vector(5 DOWNTO 0);
    Clk                                : IN std_logic;
    H0, H1, H2, H3, H4, H5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
  );
END ENTITY;
ARCHITECTURE arch_name OF display IS
BEGIN
  DISPLAY0 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      clk       => Clk,
      dadoHex   => input,
      habilita  => enable(0),
      saida7seg => H0
    );
  DISPLAY1 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      clk       => Clk,
      dadoHex   => input,
      habilita  => enable(1),
      saida7seg => H1
    );
  DISPLAY2 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      clk       => Clk,
      dadoHex   => input,
      habilita  => enable(2),
      saida7seg => H2
    );
  DISPLAY3 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      clk       => Clk,
      dadoHex   => input,
      habilita  => enable(3),
      saida7seg => H3
    );
  DISPLAY4 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      clk       => Clk,
      dadoHex   => input,
      habilita  => enable(4),
      saida7seg => H4
    );
  DISPLAY5 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      clk       => Clk,
      dadoHex   => input,
      habilita  => enable(5),
      saida7seg => H5
    );
END ARCHITECTURE;