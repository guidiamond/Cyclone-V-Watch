LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY df IS
    GENERIC (
        VALUE_WIDTH    : NATURAL := 8;
        ROM_ADDR_WIDTH : NATURAL := 10;
		ROM_DATA_WIDTH : NATURAL := 18; -- opCode(3bits) + registrador(5bits) + currAddress(10bits)
        OPCODE_WIDTH   : NATURAL := 3;
        REG_ADDR_WIDTH : NATURAL := 5
    );
    PORT (
        Clk                : IN std_logic;
        databus            : IN std_logic_vector(VALUE_WIDTH - 1 downto 0);
        controlPoint       : IN std_logic_vector(7 downto 0);
        opCode             : OUT std_logic_vector(OPCODE_WIDTH - 1 downto 0);
        fetchedInstruction : OUT std_logic_vector(VALUE_WIDTH - 1 downto 0);
        regBankOUT         : OUT std_logic_vector(VALUE_WIDTH - 1 downto 0)
    );
END ENTITY;

ARCHITECTURE arch_name OF df IS
    constant INCREMENT : NATURAL := 1;

    signal PC, PC_PLUS_ONE, NEXT_PC                        : std_logic_vector(ROM_ADDR_WIDTH - 1 downto 0);
	signal Instruction                                               : std_logic_vector(ROM_DATA_WIDTH - 1 downto 0); -- Saida da ROM
    signal io, saidaBancoReg, saidaULA_bancoReg                      : std_logic_vector(VALUE_WIDTH - 1 downto 0);
	signal selMuxProxPC_FlagEqual, flagEqual, flipflopOUT            : std_logic;

    alias currAddress : std_logic_vector(VALUE_WIDTH - 1 downto 0) IS Instruction(7 downto 0);
    alias jumpAddress : std_logic_vector(ROM_ADDR_WIDTH - 1 downto 0) IS Instruction(9 downto 0);
    alias regAddress  : std_logic_vector(REG_ADDR_WIDTH - 1 downto 0) IS Instruction(14 downto 10);
    alias localOpCode : std_logic_vector(OPCODE_WIDTH - 1 downto 0) IS Instruction(17 downto 15);
    
    alias enableFlipFlop   : std_logic IS controlPoint(0);
    alias enableULA        : std_logic_vector(3 downto 1) IS controlPoint(3 downto 1);
    alias enableStore      : std_logic IS controlPoint(4);
    alias enableIO         : std_logic IS controlPoint(5);
    alias enableJE         : std_logic IS controlPoint(6);
    alias enableNextPCMux  : std_logic IS controlPoint(7);

BEGIN
    ProgramCounter : ENTITY work.registradorGenerico
        GENERIC MAP(
            larguraDados => ROM_ADDR_WIDTH
        )
        PORT MAP(
            DIN    => NEXT_PC,
            DOUT   => PC,
            ENABLE => '1',
            CLK    => Clk,
            RST    => '0'
        );

    MuxNextPC : ENTITY work.muxGenerico2x1
        GENERIC MAP(
            larguraDados => ROM_ADDR_WIDTH
        )
        PORT MAP(
            entradaA_MUX => PC_PLUS_ONE,
            entradaB_MUX => jumpAddress,
            seletor_MUX  => selMuxProxPC_FlagEqual,
            saida_MUX    => NEXT_PC
        );

    selMuxProxPC_FlagEqual <= enableNextPCMux OR (enableJE AND flipflopOUT);

    NextInstruction : ENTITY work.somaConstante
        GENERIC MAP(
            larguraDados => ROM_ADDR_WIDTH,
            constante    => INCREMENT
        )
        PORT MAP(
            entrada => PC,
            saida   => PC_PLUS_ONE
        );

    ROM : ENTITY work.memoriaROM
        GENERIC MAP(
            dataWidth => ROM_DATA_WIDTH,
            addrWidth => ROM_ADDR_WIDTH
        )
        PORT MAP(
            Endereco => PC,
            Dado     => Instruction
        );

    CURR_IO : ENTITY work.muxGenerico2x1
        GENERIC MAP(
            larguraDados => VALUE_WIDTH
        )
        PORT MAP(
            entradaA_MUX => databus,
            entradaB_MUX => currAddress,
            seletor_MUX  => enableIO,
            saida_MUX    => io
        );

    ULA : ENTITY work.ULA
        GENERIC MAP(
            larguraDados => VALUE_WIDTH
        )
        PORT MAP(
            entradaA  => io,
            entradaB  => saidaBancoReg,
            saida     => saidaULA_bancoReg,
            seletor   => enableULA,
            flagEqual => flagEqual
        );

    EqFlagStore : ENTITY work.flipFlop
        PORT MAP(
            DIN    => flagEqual,
            DOUT   => flipflopOUT,
            ENABLE => enableFlipFlop,
            CLK    => Clk,
            RST    => '0'
        );

    RegBank : ENTITY work.bancoRegistradoresArqRegMem
        GENERIC MAP(larguraDados => VALUE_WIDTH, larguraEndBancoRegs => REG_ADDR_WIDTH)
        PORT MAP(
            clk             => Clk,
            endereco        => regAddress,
            dadoEscrita     => saidaULA_bancoReg,
            habilitaEscrita => enableStore,
            saida           => saidaBancoReg
            );

    opCode   <= localOpCode; -- UC loopup table
    regBankOUT  <= saidaBancoReg; -- Display (hex)
    fetchedInstruction <= currAddress; -- Address decoder
END ARCHITECTURE;