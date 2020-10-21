LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Decoder IS
  GENERIC (
    DATA_WIDTH : NATURAL := 8;
    ADDR_WIDTH : NATURAL := 8
  );

  PORT (
    rawInstruction   : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    store, load      : IN std_logic; 
    enableDisplay    : OUT std_logic_vector(5 DOWNTO 0);
    enableButton     : OUT std_logic_vector(2 DOWNTO 0);
    enableSW         : OUT std_logic_vector(2 DOWNTO 0);
    enableBaseTime   : OUT std_logic;
    clearBaseTime    : OUT std_logic
  );
END ENTITY;
ARCHITECTURE arch_name OF Decoder IS

BEGIN
  enableSW(0) <= '1' WHEN (rawInstruction = x"00" AND load = '1') ELSE -- SW[0]: Select base time
  '0';
  enableSW(1) <= '1' WHEN (rawInstruction = x"01" AND load = '1') ELSE -- SW[1]: (24h | AM/PM) format
  '0';
  enableSW(2) <= '1' WHEN (rawInstruction = x"02" AND load = '1') ELSE -- SW[3]: Enable Clock Incrementer
  '0';

  
  enableButton(0) <= '1' WHEN (rawInstruction = x"0A" AND load = '1') ELSE --  + 1min (max 9)
  '0';
  enableButton(1) <= '1' WHEN (rawInstruction = x"0B" AND load = '1') ELSE --  + 10min (max 9)
  '0';
  enableButton(2) <= '1' WHEN (rawInstruction = x"0C" AND load = '1') ELSE --  + 1h
  '0';

  enableDisplay(0) <= '1' WHEN (rawInstruction = x"0E" AND store = '1') ELSE -- show 1s 
  '0';
  enableDisplay(1) <= '1' WHEN (rawInstruction = x"0F" AND store = '1') ELSE -- show 10s
  '0';
  enableDisplay(2) <= '1' WHEN (rawInstruction = x"10" AND store = '1') ELSE -- show 1min
  '0';
  enableDisplay(3) <= '1' WHEN (rawInstruction = x"11" AND store = '1') ELSE -- show 10min
  '0';
  enableDisplay(4) <= '1' WHEN (rawInstruction = x"12" AND store = '1') ELSE -- show 1h
  '0';
  enableDisplay(5) <= '1' WHEN (rawInstruction = x"13" AND store = '1') ELSE -- show 10h
  '0';

  enableBaseTime <= '1' WHEN (rawInstruction = x"14" AND load = '1') ELSE -- Enable base time
    '0';

  clearBaseTime <= '1' WHEN (rawInstruction = x"15" AND load = '1') ELSE -- Clean base time -> getio
    '0';

END ARCHITECTURE;