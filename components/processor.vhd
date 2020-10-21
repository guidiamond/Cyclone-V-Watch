LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Processor IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 12
    );
    PORT (
        Clk            : IN std_logic;
        databus        : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        displayData    : OUT std_logic_vector(3 DOWNTO 0);
        load, store    : OUT std_logic;
        rawInstruction : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_name OF Processor IS
    SIGNAL fetchedInstruction, regBankOUT   : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL controlPoint                     : std_logic_vector(9 DOWNTO 0);
    SIGNAL opCode                           : std_logic_vector(2 DOWNTO 0);
BEGIN
    DataFlow : ENTITY work.df
        PORT MAP(
            Clk                => Clk,
            databus            => databus,
            controlPoint       => controlPoint(9 DOWNTO 2), 
            opCode             => opCode,
            fetchedInstruction => fetchedInstruction, 
            regBankOUT         => regBankOUT 
        );

    ControlUnit : ENTITY work.cu
        PORT MAP(
            controlPoint    => controlPoint,
            opCode          => opCode,
            Clk             => Clk
        );

    store          <= controlPoint(0);
    load           <= controlPoint(1);
    displayData    <= regBankOUT(3 DOWNTO 0); 
    rawInstruction <= fetchedInstruction; 
END ARCHITECTURE;