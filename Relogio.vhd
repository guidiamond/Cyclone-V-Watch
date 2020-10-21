LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- top_level: agrupa I/Os, decodificador e processador

ENTITY Relogio IS
  GENERIC (
    DATA_WIDTH : NATURAL := 8;
    ADDR_WIDTH : NATURAL := 8
  );

  PORT (
    -- Input ports
    CLOCK_50 : IN std_logic;
    SW       : IN std_logic_vector(2 DOWNTO 0);
    KEY      : IN std_logic_vector(3 DOWNTO 0);
	 -- Output ports
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
  );
END ENTITY;
ARCHITECTURE rlt OF Relogio IS

  SIGNAL processorInstruction, databus : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
  SIGNAL displayData   : std_logic_vector(3 DOWNTO 0);

  SIGNAL load, store, enableBaseTime, clearTimeBase : std_logic;
  SIGNAL enableButtons    : std_logic_vector(2 DOWNTO 0);
  SIGNAL enableDisplays    : std_logic_vector(5 DOWNTO 0);
  SIGNAL enableSwitches     : std_logic_vector(2 DOWNTO 0);

BEGIN

  Processador : ENTITY work.Processor
    PORT MAP(
      Clk            => CLOCK_50,
      databus        => databus, 
      displayData    => displayData,
      load           => load,
      store          => store,
      rawInstruction => processorInstruction
    );

  Decodificador : ENTITY work.Decoder
    PORT MAP(
      rawInstruction   => processorInstruction,
      store            => store,
      load             => load,
      enableDisplay    => enableDisplays,
      enableButton     => enableButtons,
      enableSW         => enableSwitches,
      enableBaseTime   => enableBaseTime,
      clearBaseTime    => clearTimeBase
    );
	 
  entradaChaves : ENTITY work.switch
    PORT MAP(
      input  => SW(2 DOWNTO 0),
      output => databus,
      enable => enableSwitches
    );

  entradaBotoes : ENTITY work.button
    PORT MAP(
      input  => KEY(2 DOWNTO 0),
      output => databus,
      enable => enableButtons
    );

  interfaceBaseTempo : ENTITY work.divisorGenerico_e_Interface
    PORT MAP(
      clk              => CLOCK_50,
      habilitaLeitura  => enableBaseTime,
      limpaLeitura     => clearTimeBase,
      leituraUmSegundo => databus,
		  selBaseTempo     => SW(0)
    );

  Displays : ENTITY work.display
    PORT MAP(
      input  => displayData,
      enable => enableDisplays,
      Clk    => CLOCK_50,
	  	H0     => HEX0,
	  	H1     => HEX1,
	  	H2     => HEX2, 
	  	H3     => HEX3,
	  	H4     => HEX4,
	  	H5     => HEX5
    );
END ARCHITECTURE;