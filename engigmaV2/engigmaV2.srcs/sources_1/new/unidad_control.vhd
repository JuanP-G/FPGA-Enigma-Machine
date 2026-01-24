library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unidad_control is
    Port (
        -- Entradas físicas basys3
        clk             : in STD_LOGIC;
        rst             : in STD_LOGIC;  
        btn_cifrar      : in std_logic;
        seleccion_rotor : in STD_LOGIC_VECTOR (1 downto 0); 
        modo_descifrar  : in STD_LOGIC;
        
        --entrada datapath
        salida_rotor0   : in STD_LOGIC_VECTOR (4 downto 0);
        salida_rotor1   : in STD_LOGIC_VECTOR (4 downto 0);
        
        --salida con todo el control codfi
        salidaMoore    : out std_logic_vector (18 downto 0)
    );
end entity;

architecture Behavioral of unidad_control is 

    type estados is (S0,S1,S2,S3,S3_2,S4,S5,S6);
    signal q, qSig : estados;
    
    --senyales auxiliares
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
    
begin

    -- 1. REGISTRO DE ESTADO (Secuencial)
    process(clk, rst)
    begin
        if rst = '1' then
            q <= S0;
        elsif rising_edge(clk) then
            q <= qSig;
        end if;
    end process;

    -- 2. Calculo de siguiente estado
    process(q,clk, btn_cifrar, salida_rotor0)
    begin
        case q is 
            when S0 => 
                qSig <= S1;
                
            when S1 =>
                if btn_cifrar = '1' then
                    qSig <= S2;
                else 
                    qSig <= S1;
                    
                end if;
                    
            when S2 =>
                    qSig <= S3;
                    
            when S3 =>
                    qSig <= S3_2;
                    --qSig <= S4;
                
            when S3_2 =>
                    qSig <= S4;    
                
            when S4 =>
                    qSig <= S5;
            
            when S5 =>
            
                    if unsigned(salida_rotor0) >= to_unsigned(5, salida_rotor0'length) and unsigned(salida_rotor1) >= to_unsigned(2, salida_rotor1'length) then
                        qSig <= S0;
                    
                    elsif unsigned(salida_rotor0) >= to_unsigned(9, salida_rotor0'length) then
                        qSig <= S6;
                    else
                        qSig <= S1;
                    end if;
            
            when S6 =>
                    qSig <= S1;
        end case;
        
    end process;

   
    -- 3. DECODIFICADOR DE SALIDA (Combinacional - Palabra de Control Completa)
    process (clk, q)
    
    begin
        case q is 
        
            --reset
            when S0 =>
                controlMuxIndice <= "00";
                controlMuxNvuelta <= "00";
                controlMuxA <= "11";
                controlMuxB <="11";
                controlMuxROM <= "11";
                controlMuxROMi <= "11";
                controlMuxLsalida <= '0' & modo_descifrar;
                controlMuxDig0 <= "00";
                controlMuxDig1 <= "00";
                opSumRest <= '0';
            
            --espera
            when S1 =>
                controlMuxIndice <= "10";                   --mantener
                controlMuxNvuelta <= "01";                  --mantener
                controlMuxA <= "11";                        --dont care
                controlMuxB <="11";                         --dont care
                controlMuxROM <= seleccion_rotor;           --modo seleccionado
                controlMuxROMi <= seleccion_rotor;          --modo seleccionado
                --controlMuxLsalida <= '0' & modo_descifrar;  --rom (cifrar) o rom (descifrar)
                controlMuxLsalida <= "11";                   --mantener
                controlMuxDig0 <= "01";                     --mantener
                controlMuxDig1 <= "01";
                opSumRest <= '0';
               
            --calculo indice
            when S2 =>
                controlMuxIndice <= "01";                   --sumRest
                controlMuxNvuelta <= "01";                  --mantener
                controlMuxA <= "00";                        --nVuelta
                controlMuxB <="00";                         --letraEntrada
                controlMuxROM <= seleccion_rotor;           --modo seleccionado
                controlMuxROMi <= seleccion_rotor;          --modo seleccionado
                controlMuxLsalida <= '0' & modo_descifrar;  --rom (cifrar) o rom (descifrar)
                controlMuxDig0 <= "01";                     --mantener
                controlMuxDig1 <= "01";                     --mantener
                opSumRest <= '0';
            
            --cifrar/descifrar
            when S3 =>
                controlMuxIndice <= "10";                   --mantener
                controlMuxNvuelta <= "01";                  --mantener
                controlMuxA <= "11";                        --0
                controlMuxB <="11";                         --0
                controlMuxROM <= seleccion_rotor;           --modo seleccionado
                controlMuxROMi <= seleccion_rotor;          --modo seleccionado
                controlMuxLsalida <= '0' & modo_descifrar;  --rom (cifrar) o rom (descifrar)
                controlMuxDig0 <= "01";                     --mantener
                controlMuxDig1 <= "01";                     --mantener
                opSumRest <= '0';
                
            when S3_2 =>
                controlMuxIndice <= "10";                   --mantener
                controlMuxNvuelta <= "01";                  --mantener
                controlMuxA <= "11";                        --0
                controlMuxB <="10";                         --0
                controlMuxROM <= seleccion_rotor;           --modo seleccionado
                controlMuxROMi <= seleccion_rotor;          --modo seleccionado
                controlMuxLsalida <= "10";                  --sumRest
                controlMuxDig0 <= "01";                     --mantener
                controlMuxDig1 <= "01";                     --mantener
                opSumRest <= '1';                           --resta
            
            --incremento nVuelta
            when S4 =>
                controlMuxIndice <= "10";                   --mantener
                controlMuxNvuelta <= "10";                  --sumRest
                controlMuxA <= "00";                        --nVuelta
                controlMuxB <="01";                         --1
                controlMuxROM <= seleccion_rotor;           --modo seleccionado
                controlMuxROMi <= seleccion_rotor;          --modo seleccionado
                --controlMuxLsalida <= '0' & modo_descifrar;  --rom (cifrar) o rom (descifrar)
                controlMuxLsalida <= "11";                  --mantener
                controlMuxDig0 <= "01";                     --mantener
                controlMuxDig1 <= "01";                     --mantener
                opSumRest <= '0';
                
            --incremento dig0
            when S5 =>
                controlMuxIndice <= "10";                   --mantener
                controlMuxNvuelta <= "01";                  --mantener
                controlMuxA <= "01";                        --nDig0
                controlMuxB <="01";                         --1
                controlMuxROM <= seleccion_rotor;           --modo seleccionado
                controlMuxROMi <= seleccion_rotor;          --modo seleccionado
                --controlMuxLsalida <= '0' & modo_descifrar;  --rom (cifrar) o rom (descifrar)
                controlMuxLsalida <= "11";                  --mantener
                controlMuxDig0 <= "10";                     --sumRest
                controlMuxDig1 <= "01";                     --mantener
                opSumRest <= '0';
                
           --correccion dig1
           when S6 =>
                controlMuxIndice <= "10";                   --mantener
                controlMuxNvuelta <= "01";                  --mantener
                controlMuxA <= "10";                        --nDig1
                controlMuxB <="01";                         --1
                controlMuxROM <= seleccion_rotor;           --modo seleccionado
                controlMuxROMi <= seleccion_rotor;          --modo seleccionado
                controlMuxLsalida <= "11";                  --mantener
                controlMuxDig0 <= "00";                     --mantener
                controlMuxDig1 <= "10";                     --sumRest
                opSumRest <= '0';
        end case;
        
        --Junto la salida
        salidaMoore <= controlMuxIndice & controlMuxNvuelta & controlMuxA & controlMuxB & controlMuxROM & controlMuxROMi & controlMuxLsalida & controlMuxDig0 & controlMuxDig1 & opSumRest;
    
    end process;
    

end Behavioral;