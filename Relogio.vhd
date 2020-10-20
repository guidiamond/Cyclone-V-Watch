LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- top_level: agrupa I/Os, decodificador e processador

ENTITY Relogio IS
  GENERIC (
    DATA_WIDTH : NATURAL := 8
  );

  PORT (
    -- Input ports
    Clk         : IN std_logic;
    SW          : IN std_logic_vector(7 DOWNTO 0);
    BUTTON      : IN std_logic_vector(3 DOWNTO 0);
	 -- Output ports
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE rlt OF Relogio IS

  -- Data related signals
  signal processorInputDATABUS, processorInstruction : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
  signal displayDATA                                 : std_logic_vector(3 downto 0);

  -- In/Out enabler signals
  signal load, store, enableTimeBase, clearTimeBase : std_logic;
  signal enableButtons  : std_logic_vector(3 downto 0);
  signal enableDisplays : std_logic_vector(5 downto 0);
  signal enableSwitches : std_logic_vector(7 downto 0);
BEGIN
  Processor : ENTITY work.processor
  PORT MAP(
            Clk             => Clk,                   -- in sync clock
            dataBus         => processorInputDATABUS, -- in basetime, button and switches databus
            displayData     => displayDATA,           -- in
            rawInstruction  => processorInstruction   -- out deps: decoder
            load            => load,                  -- out deps: decoder
            store           => store,                 -- out deps: decoder
          );

  Decoder : ENTITY work.decoder
  PORT MAP(
            rawInstruction => processorInstruction,   -- in
            store          => store,                  -- in
            load           => load,                   -- in
            enableDisplay  => enableDisplays,         -- out
            enableButton   => enableButtons,          -- out
            enableSW       => enableSwitches,         -- out
            enableTimeBase => enableTimeBase,         -- out
            clearTimeBase  => clearTimeBase           -- out
          );

  baseTimeInterface : ENTITY work.divisorGenerico_e_Interface
  PORT MAP(
            clk              => Clk,
            habilitaLeitura  => enableTimeBase,
            limpaLeitura     => clearBaseTime,
            leituraUmSegundo => processorInputDATABUS,
            selBaseTempo     => SW(0)
          );

    switchInput : ENTITY work.SwitchInterface
    PORT MAP(
              input      => SW(DATA_WIDTH - 1 DOWNTO 0),
              enabled    => processorInputDATABUS,
              output     => habilitaSw
            );

    buttonInput : ENTITY work.ButtonInterface
    PORT MAP(
              input  => BUTTON(3 DOWNTO 0),
              enable => processorInputDATABUS,
              output => barramento_entradaProcessador
            );

    Displays : ENTITY work.DisplayInterface
    PORT MAP(
              input  => displayData,
              enable => enableDisplays,
              Clk    => Clk,
              D0     => HEX0,
              D1     => HEX1,
              D2     => HEX2, 
              H3     => HEX3,
              D4     => HEX4,
              D5     => HEX5
            );
END ARCHITECTURE;
