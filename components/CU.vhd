LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY CU IS
    PORT (
        opCode       : IN std_logic_vector(2 DOWNTO 0);
        controlPoint : OUT std_logic_vector(9 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_name OF CU IS
  -- The CU activates the necessary circuity/data transfers.
  -- Using the mux to match the corresponding actions
  -- Result stored in a register
  -- Data may be read/written from/to the main memory during this stage

    ALIAS selMuxProxPC       : std_logic IS controlPoint(9);
    ALIAS selJe              : std_logic IS controlPoint(8);
    ALIAS selMuxIOImed       : std_logic IS controlPoint(7);
    ALIAS habEscritaBancoReg : std_logic IS controlPoint(6);
    ALIAS selOperacaoULA     : std_logic_vector(5 DOWNTO 3) IS controlPoint(5 DOWNTO 3);
    ALIAS habFlipFlop        : std_logic IS controlPoint(2);
    ALIAS load               : std_logic IS controlPoint(1);
    ALIAS store              : std_logic IS controlPoint(0);
    
    CONSTANT cmpCMD        : std_logic_vector(2 DOWNTO 0) := "000";
    CONSTANT jmpCMD        : std_logic_vector(2 DOWNTO 0) := "001";
    CONSTANT addCMD        : std_logic_vector(2 DOWNTO 0) := "010";
    CONSTANT subCMD        : std_logic_vector(2 DOWNTO 0) := "011";
    CONSTANT getioCMD      : std_logic_vector(2 DOWNTO 0) := "100";
    CONSTANT opCodeDisplay : std_logic_vector(2 DOWNTO 0) := "101";
    CONSTANT opCodeJe      : std_logic_vector(2 DOWNTO 0) := "110";
    CONSTANT movCMD        : std_logic_vector(2 DOWNTO 0) := "111";

    SIGNAL instrucao       : std_logic_vector(7 DOWNTO 0);
	 
	 -- aliases para instrucao
    ALIAS cmp     : std_logic IS instrucao(0);
    ALIAS jmp     : std_logic IS instrucao(1);
    ALIAS add     : std_logic IS instrucao(2);
    ALIAS sub     : std_logic IS instrucao(3);
    ALIAS getIO   : std_logic IS instrucao(4);
    ALIAS display : std_logic IS instrucao(5);
    ALIAS je      : std_logic IS instrucao(6);
    ALIAS mov     : std_logic IS instrucao(7);

    --       selMuxProxPC selJe  selMuxIOImed  habEscritaBancoReg  selOperacaoULA  habFlipFlop  load  store
    -- cmp        0         0         1                0                 001            1         0    0
    -- jmp        1         0         0                0                 000            0         0    0
    -- add        0         0         1                1                 000            0         0    0
    -- sub        0         0         1                1                 001            0         0    0
    -- display    0         0         0                0                 000            0         0    1
    -- getIO      0         0         0                1                 010            0         1    0
    -- je         0         1         0                0                 000            0         0    0
    -- mov        0         0         1                1                 010            0         0    0
	 
  -- opCODE is decoded from ROM

BEGIN
    WITH opCode SELECT
        instrucao <= "00000001" WHEN cmpCMD,
        "00000010" WHEN jmpCMD,
        "00000100" WHEN addCMD,
        "00001000" WHEN subCMD,
        "00010000" WHEN getioCMD,
        "00100000" WHEN opCodeDisplay,
        "01000000" WHEN opCodeJe,
        "10000000" WHEN movCMD,
        "00000000" WHEN OTHERS;

    WITH opCode SELECT
        selOperacaoULA <= "000" WHEN jmpCMD,
        "000" WHEN opCodeDisplay,
        "000" WHEN addCMD,
        "001" WHEN cmpCMD,
        "001" WHEN subCMD,
        "010" WHEN getioCMD,
        "010" WHEN movCMD,
        "000" WHEN OTHERS;

    selMuxProxPC       <= jmp;
    selJe              <= je;
    selMuxIOImed       <= cmp OR add OR sub OR mov;
    habEscritaBancoReg <= add OR sub OR getIO OR mov;
    habFlipFlop        <= cmp;
    load               <= getIO;
    store              <= display;

END ARCHITECTURE;
