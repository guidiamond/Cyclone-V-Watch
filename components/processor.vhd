LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- processor formado pelo fluxo de dados e unidade de controle

ENTITY processor IS
    GENERIC (
        DATA_WIDTH : NATURAL := 8;
        ADDR_WIDTH : NATURAL := 12
    );
    PORT (
        -- Input ports
        Clk            : IN std_logic;
        dataBus        : IN std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
        displayData    : OUT std_logic_vector(3 DOWNTO 0);
        rawInstruction : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
        load           : OUT std_logic;
        store          : OUT std_logic;
    );
END ENTITY;

ARCHITECTURE arch_name OF processor IS
    SIGNAL controlPoint              : std_logic_vector(9 DOWNTO 0);
    SIGNAL opCode                    : std_logic_vector(2 DOWNTO 0);
    SIGNAL regBankOUT                : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL fetchedInstruction        : std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
BEGIN

    DF : ENTITY work.fluxoDados
        PORT MAP(
            Clk                       => Clk, -- sync clock
            controlPoint              => controlPoint(9 DOWNTO 2),  -- Used by the CU
            dataBus                   => dataBus,     -- input
            fetchedInstruction        => fetchedInstruction, -- address used by the decoder
            regBankOUT                => regBankOUT -- data out
            opCode                    => opCode, -- Rom -> CU
        );

    CU : ENTITY work.control_unit
        PORT MAP(
            controlPoint    => controlPoint,
            opCode          => opCode
        );

    store          <= controlPoint(0); -- deps: decoder
    load           <= controlPoint(1); -- deps: decoder
    displayData    <= regBankOUT(3 DOWNTO 0); 
    rawInstruction <= fetchedInstruction; 
END ARCHITECTURE;
