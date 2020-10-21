LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cu IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 8
    );
    PORT (
        Clk    : IN std_logic;
        opCode : IN std_logic_vector(2 DOWNTO 0);
        controlPoint : OUT std_logic_vector(9 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_name OF cu IS
    SIGNAL instruction       : std_logic_vector(7 DOWNTO 0);

    ALIAS store                 : std_logic IS controlPoint(0);
    ALIAS load                  : std_logic IS controlPoint(1);
    ALIAS enableFlipFlop        : std_logic IS controlPoint(2);
    ALIAS selOperacaoULA        : std_logic_vector(5 DOWNTO 3) IS controlPoint(5 DOWNTO 3);
    ALIAS enableWriteOnMemBank  : std_logic IS controlPoint(6);
    ALIAS enableIO              : std_logic IS controlPoint(7);
    ALIAS enableJE              : std_logic IS controlPoint(8);
    ALIAS enableMuxPC           : std_logic IS controlPoint(9);
    
    CONSTANT opCodeCmp     : std_logic_vector(2 DOWNTO 0) := "000";
    CONSTANT opCodeJmp     : std_logic_vector(2 DOWNTO 0) := "001";
    CONSTANT opCodeAdd     : std_logic_vector(2 DOWNTO 0) := "010";
    CONSTANT opCodeSub     : std_logic_vector(2 DOWNTO 0) := "011";
    CONSTANT opCodeGetIO   : std_logic_vector(2 DOWNTO 0) := "100";
    CONSTANT opCodeDisplay : std_logic_vector(2 DOWNTO 0) := "101";
    CONSTANT opCodeJe      : std_logic_vector(2 DOWNTO 0) := "110";
    CONSTANT opCodeMov     : std_logic_vector(2 DOWNTO 0) := "111";

    ALIAS cmp     : std_logic IS instruction(0);
    ALIAS jmp     : std_logic IS instruction(1);
    ALIAS add     : std_logic IS instruction(2);
    ALIAS sub     : std_logic IS instruction(3);
    ALIAS getIO   : std_logic IS instruction(4);
    ALIAS display : std_logic IS instruction(5);
    ALIAS je      : std_logic IS instruction(6);
    ALIAS mov     : std_logic IS instruction(7);

BEGIN
    WITH opCode SELECT
        instruction <= "00000001" WHEN opCodeCmp,
        "00000010" WHEN opCodeJmp,
        "00000100" WHEN opCodeAdd,
        "00001000" WHEN opCodeSub,
        "00010000" WHEN opCodeGetIO,
        "00100000" WHEN opCodeDisplay,
        "01000000" WHEN opCodeJe,
        "10000000" WHEN opCodeMov,
        "00000000" WHEN OTHERS;

    WITH opCode SELECT
        selOperacaoULA <= "000" WHEN opCodeJmp,
        "000" WHEN opCodeDisplay,
        "000" WHEN opCodeAdd,
        "001" WHEN opCodeCmp,
        "001" WHEN opCodeSub,
        "010" WHEN opCodeGetIO,
        "010" WHEN opCodeMov,
        "000" WHEN OTHERS;

    enableMuxPC          <= jmp;
    enableJE             <= je;
    enableWriteOnMemBank <= add OR sub OR getIO OR mov;
    enableIO             <= cmp OR add OR sub OR mov;
    enableFlipFlop       <= cmp;
    load                 <= getIO;
    store                <= display;

END ARCHITECTURE;