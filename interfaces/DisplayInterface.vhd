LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY DisplayInterface IS
  GENERIC (
    DATA_WIDTH : NATURAL := 4
  );

  PORT (
    timeIN                 : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    enable                 : IN std_logic_vector(5 DOWNTO 0);
    Clk                    : IN std_logic;
    D0, D1, D2, D3, D4, D5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE arch_name OF DisplayInterface IS
BEGIN
  -- Morning         Format: HH:MM:SS || HH:MM:A_ (AM)
  -- Afternoon/night Format: HH:MM:SS || HH:MM:P_ (PM)
  DISPLAY0 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      Clk       => Clk,
      dadoHex   => timeIN,
      enable    => enable(0),
      saida7seg => D0
    );
  DISPLAY1 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      Clk       => Clk,
      dadoHex   => timeIN,
      enable    => enable(1),
      saida7seg => D1
    );
  DISPLAY2 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      Clk       => Clk,
      dadoHex   => timeIN,
      enable    => enable(2),
      saida7seg => D2
    );
  DISPLAY3 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      Clk       => Clk,
      dadoHex   => timeIN,
      enable    => enable(3),
      saida7seg => D3
    );
  DISPLAY4 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      Clk       => Clk,
      dadoHex   => timeIN,
      enable    => enable(4),
      saida7seg => D4
    );
  DISPLAY5 : ENTITY work.conversorHex7Seg
    PORT MAP
    (
      Clk       => Clk,
      dadoHex   => timeIN,
      enable    => enable(5),
      saida7seg => D5
    );
END ARCHITECTURE;
