library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
    generic ( N : positive := 5 );
    Port (
        -- entradas basys3
        clk             : in STD_LOGIC;
        entrada_letra   : in STD_LOGIC_VECTOR (4 downto 0); --sw
        
        -- Senyal de Control UC
        salidaMoore    : in std_logic_vector (18 downto 0);
        
        -- Salidas
        salida_letra    : out STD_LOGIC_VECTOR (4 downto 0);
        salida_rotor0   : out STD_LOGIC_VECTOR (4 downto 0);
        salida_rotor1   : out STD_LOGIC_VECTOR (4 downto 0)
    );
end entity;

architecture Behavioral of datapath is 

    type alfabeto_array is array (0 to 25) of natural range 0 to 25;
    
    -- RODILLO I ...
    constant ROM1     : alfabeto_array := (4, 10, 12, 5, 11, 6, 3, 16, 21, 25, 13, 19, 14, 22, 24, 7, 23, 20, 18, 15, 0, 8, 1, 17, 2, 9);
    constant ROM1i    : alfabeto_array := (20, 22, 24, 6, 0, 3, 5, 15, 21, 25, 1, 4, 2, 10, 12, 19, 7, 23, 18, 11, 17, 8, 13, 16, 14, 9);
    -- RODILLO II ...
    constant ROM2     : alfabeto_array := (0, 9, 3, 10, 18, 8, 17, 20, 23, 1, 11, 7, 22, 19, 12, 2, 16, 6, 25, 13, 15, 24, 5, 21, 14, 4);
    constant ROM2i    : alfabeto_array := (0, 9, 15, 2, 25, 22, 17, 11, 5, 1, 3, 10, 14, 19, 24, 20, 16, 6, 4, 13, 7, 23, 12, 8, 21, 18);
    -- RODILLO III ...
    constant ROM3     : alfabeto_array := (1, 3, 5, 7, 9, 11, 2, 15, 17, 19, 23, 21, 25, 13, 24, 4, 8, 22, 6, 0, 10, 12, 20, 18, 16, 14);
    constant ROM3i    : alfabeto_array := (19, 0, 6, 1, 15, 2, 18, 3, 16, 4, 20, 5, 21, 13, 25, 7, 24, 8, 23, 9, 22, 11, 17, 10, 14, 12);

    -- COMPONENTES
    component mux is
        Port(
            E0, E1, E2, E3 : in std_logic_vector(N-1 downto 0);
            Control : in std_logic_vector (1 downto 0);
            Z : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    component sumador_restador is
        port (
            A, B : in  STD_LOGIC_VECTOR(N-1 downto 0);
            OP   : in  STD_LOGIC;
            Y    : out STD_LOGIC_VECTOR(N-1 downto 0);
            Cout : out STD_LOGIC
        );
    end component;
    
    --Uc decodificada
    signal controlMuxIndice  : std_logic_vector (1 downto 0);   --18,17
    signal controlMuxNvuelta : std_logic_vector (1 downto 0);   --16,15
    signal controlMuxA       : std_logic_vector (1 downto 0);   --14,13
    signal controlMuxB       : std_logic_vector (1 downto 0);   --12,11
    signal controlMuxROM     : std_logic_vector (1 downto 0);   --10,9
    signal controlMuxROMi    : std_logic_vector (1 downto 0);   --8,7
    signal controlMuxLSalida : std_logic_vector (1 downto 0);   --6,5
    signal controlMuxDig0    : std_logic_vector (1 downto 0);   --4,3
    signal controlMuxDig1    : std_logic_vector (1 downto 0);   --2,1
    signal opSumRest         : std_logic;                       --0

    -- SENYALES INTERNAS
    signal rom1_out, rom2_out, rom3_out : std_logic_vector(N-1 downto 0);
    signal rom1i_out, rom2i_out, rom3i_out : std_logic_vector(N-1 downto 0);
    signal indice_rom : integer range 0 to 31; 
    
    signal zMuxA, zMuxB, zSumRest : std_logic_vector(N-1 downto 0);
    signal salidaRom, salidaRomI : std_logic_vector(N-1 downto 0);
    
    -- REGISTROS (Estado Actual)
    signal nVuelta_reg : std_logic_vector(N-1 downto 0);
    signal rotor0_reg  : std_logic_vector(N-1 downto 0);
    signal rotor1_reg  : std_logic_vector(N-1 downto 0);
    signal indice_rom_reg : std_logic_vector(N-1 downto 0);

    -- CABLES (Salida de los Muxes, realimentacion y evitar latches)
    signal nVuelta_next : std_logic_vector(N-1 downto 0);
    signal rotor0_next  : std_logic_vector(N-1 downto 0);
    signal rotor1_next  : std_logic_vector(N-1 downto 0);
    signal indice_rom_reg_next : std_logic_vector(N-1 downto 0);
    signal letraAux     : std_logic_vector (N-1 downto 0);
    signal letraAux_next : std_logic_vector (N-1 downto 0);

begin

    --conexion UC
    controlMuxIndice <= salidaMoore(18 downto 17);
    controlMuxNvuelta <= salidaMoore(16 downto 15);
    controlMuxA <= salidaMoore(14 downto 13);
    controlMuxB <= salidaMoore(12 downto 11);
    controlMuxROM <= salidaMoore(10 downto 9);
    controlMuxROMi <= salidaMoore(8 downto 7);
    controlMuxLsalida <= salidaMoore(6 downto 5);
    controlMuxDig0 <= salidaMoore(4 downto 3);
    controlMuxDig1 <= salidaMoore(2 downto 1);
    opSumRest <= salidaMoore(0);
    -- --------------------------------------------------------
    -- PROCESO DE REGISTROS
    -- --------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            -- Actualizamos el estado con lo que sale de los Muxes
            nVuelta_reg <= nVuelta_next;
            rotor0_reg  <= rotor0_next;
            rotor1_reg  <= rotor1_next;
            indice_rom_reg <= indice_rom_reg_next;
            letraAux <= letraAux_next;
        end if;
    end process;

    -- Conectamos las salidas de los registros a los puertos de salida de la entidad
    salida_rotor0 <= rotor0_reg;
    salida_rotor1 <= rotor1_reg;

    -- --------------------------------------------------------
    -- LOGICA COMBINACIONAL (Datapath)
    -- --------------------------------------------------------

    -- El sumador usa el ESTADO ACTUAL (nVuelta_reg)
       instMuxA : mux Port Map (
           E0 => nVuelta_reg, -- Antes era nVuelta (bucle)
           E1 => rotor0_reg,
           E2 => rotor1_reg,
           E3 => letraAux,
           Control => controlMuxA,
           Z => zMuxA
       );
       
       instMuxB : mux Port Map (
           E0 => entrada_letra,
           E1 => "00001",  --1
           E2 => nVuelta_reg,  
           E3 => "00000",  
           Control => controlMuxB,
           Z => zMuxB
       );
       
       instSumRest : sumador_restador Port Map (
           A => zMuxA,
           B => zMuxB,
           OP => opSumRest,
           Y => zSumRest,
           Cout => open
       );

    -- Acceso ROM
    
       instMuxIndice : mux Port Map (
            E0 => "00000",
            E1 => zSumRest,
            E2 => indice_rom_reg,
            E3 => "00000",
            
            Control => controlMuxIndice,
            
            Z => indice_rom_reg_next
       );
    
       indice_rom <= to_integer(unsigned(indice_rom_reg)) mod 26;
       
       rom1_out <= std_logic_vector(to_unsigned(ROM1(indice_rom), N));
       rom2_out <= std_logic_vector(to_unsigned(ROM2(indice_rom), N));
       rom3_out <= std_logic_vector(to_unsigned(ROM3(indice_rom), N));
       
       rom1i_out <= std_logic_vector(to_unsigned(ROM1i(indice_rom), N));
       rom2i_out <= std_logic_vector(to_unsigned(ROM2i(indice_rom), N));
       rom3i_out <= std_logic_vector(to_unsigned(ROM3i(indice_rom), N));
       
       instMuxRom : mux Port Map (
           E0 => rom1_out,
           E1 => rom2_out,
           E2 => rom3_out,
           E3 => "00000",
           Control => controlMuxROM,
           Z => salidaRom
        );
       
        instMuxRomi : mux Port Map (
           E0 => rom1i_out,
           E1 => rom2i_out,
           E2 => rom3i_out,
           E3 => "00000",
           Control => controlMuxROMi,
           Z => salidaRomi
        );
    
    -- Cambio de letra salida
        instMuxLsalida : mux Port Map (
           E0 => salidaRom,
           E1 => salidaRomi,
           E2 => zSumRest,
           E3 => letraAux,
           Control => controlMuxLsalida,
           Z => letraAux_next
        );
       
       salida_letra <= letraAux;
    -- --------------------------------------------------------
    -- CALCULO DEL SIGUIENTE ESTADO (Salidas a _next)
    -- --------------------------------------------------------
     
    -- Control nVuelta
       instMuxNvuelta : mux Port Map (
           E0 => "00000",
           E1 => nVuelta_reg, -- Usa el valor actual
           E2 => zSumRest,
           E3 => "00000",
           Control => controlMuxNvuelta,
           Z => nVuelta_next  -- Salida hacia el registro
       );
       
    -- Control dig0 (Rotor 0)
       instMuxDig0 : mux Port Map (
           E0 => "00000",
           E1 => rotor0_reg,  -- Usa el valor actual
           E2 => zSumRest,
           E3 => "00000",
           Control => controlMuxDig0,
           Z => rotor0_next   -- Salida hacia el registro
       );
           
    -- Control dig1 (Rotor 1)
        instMuxDig1 : mux Port Map (
           E0 => "00000",
           E1 => rotor1_reg,  -- Usa el valor actual
           E2 => zSumRest,
           E3 => "00000",
           Control => controlMuxDig1,
           Z => rotor1_next   -- Salida hacia el registro
       );

end Behavioral;