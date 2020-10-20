library IEEE;
use ieee.std_logic_1164.all;

entity conversorHex7Seg is
  port
  (
      -- Input ports
    Clk, enable     : in std_logic;
    dadoHex : in  std_logic_vector(3 downto 0);
      -- Output ports
    saida7seg : out std_logic_vector(6 downto 0)  -- := (others => '1')
  );
end entity;

architecture comportamento of conversorHex7Seg is
    --
    --       0
    --      ---
    --     |   |
    --    5|   |1
    --     | 6 |
    --      ---
    --     |   |
    --    4|   |2
    --     |   |
    --      ---
    --       3
    --
  signal rascSaida7seg: std_logic_vector(6 downto 0);
begin
  rascSaida7seg <=        "1000000" when dadoHex=x"0" else ---0
                          "1111001" when dadoHex=x"1" else ---1
                          "0100100" when dadoHex=x"2" else ---2
                          "0110000" when dadoHex=x"3" else ---3
                          "0011001" when dadoHex=x"4" else ---4
                          "0010010" when dadoHex=x"5" else ---5
                          "0000010" when dadoHex=x"6" else ---6
                          "1111000" when dadoHex=x"7" else ---7
                          "0000000" when dadoHex=x"8" else ---8
                          "0010000" when dadoHex=x"9" else ---9
                          "0001000" when dadoHex=x"a" else ---A
                          "0000011" when dadoHex=x"b" else ---P
                          "1111111"; -- Delete all segments

  process (Clk) is
  begin
    if rising_edge(Clk) then
      if (enable = '1') then
        saida7seg <= rascSaida7seg;
      end if;
    end if;
  end process;

end architecture;
