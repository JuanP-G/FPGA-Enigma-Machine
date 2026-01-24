library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sintesis_enigma is
    generic (
        N : positive := 5   
    );
    Port ( 
        rst          : IN  std_logic;                    -- Btn central
        clk          : IN  std_logic;                    -- Reloj 100MHz
        boton_cifrar : IN  std_logic;                    -- Btn derecho
        sw           : IN  std_logic_vector(15 DOWNTO 0);-- Switches
        display      : OUT std_logic_vector(6 DOWNTO 0); -- Catodos
        s_display    : OUT std_logic_vector(3 DOWNTO 0); -- Anodos
        leds         : OUT std_logic_vector(15 DOWNTO 0) -- LEDs
    );
end sintesis_enigma;

architecture Behavioral of sintesis_enigma is

    -- COMPONENTES --
    
    component unidad_control is
        Port (
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
    end component;

    component datapath is
        generic ( N : positive := 5 );
        Port (
            clk : in STD_LOGIC;
            
            entrada_letra      : in STD_LOGIC_VECTOR (4 downto 0);      
            salidaMoore        : in std_logic_vector(18 downto 0);
            
            salida_letra      : out STD_LOGIC_VECTOR (4 downto 0);
            salida_rotor0     : out STD_LOGIC_VECTOR (4 downto 0);
            salida_rotor1     : out STD_LOGIC_VECTOR (4 downto 0)
        );
    end component;

    component displays is
        Port ( 
            rst : in STD_LOGIC;
            clk : in STD_LOGIC;       
            digito_0 : in  STD_LOGIC_VECTOR (4 downto 0); 
            digito_1 : in  STD_LOGIC_VECTOR (4 downto 0); 
            digito_2 : in  STD_LOGIC_VECTOR (4 downto 0); 
            digito_3 : in  STD_LOGIC_VECTOR (4 downto 0); 
            display : out  STD_LOGIC_VECTOR (6 downto 0);
            display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
         );
    end component;

    component debouncer is
      PORT (
        rst: IN std_logic;
        clk: IN std_logic;
        x: IN std_logic;
        xDeb: OUT std_logic;
        xDebFallingEdge: OUT std_logic;
        xDebRisingEdge: OUT std_logic
      );
    end component;

    -- SENYALES INTERNAS --
    signal cable_control : std_logic_vector(18 downto 0);
    
    -- Senyales para el Datapath (Unificadas)
    signal s_salida_letra  : std_logic_vector(4 downto 0);
    signal s_salida_rotor0 : std_logic_vector(4 downto 0);
    signal s_salida_rotor1 : std_logic_vector(4 downto 0);
    signal s_entrada_letra : std_logic_vector(4 downto 0);
    
    -- Senyal del boton limpio
    signal btn_cifrar_debounced : std_logic;
    signal btn_edge_detected    : std_logic;
    
    signal rst_n : std_logic;
    signal btn_cifrar_limpio : std_logic;

begin

    rst_n <= not rst;

    -- Asignacion de entradas de Switches
    s_entrada_letra <= sw(4 downto 0); -- 5 bits menos significativos para la letra

    -- Instancia Debouncer
     inst_debouncer: debouncer PORT MAP (
          rst => rst_n, -- Reset invertido
          clk => clk,
          x => boton_cifrar,
          xDeb => open,
          xDebFallingEdge => open,
          xDebRisingEdge => btn_cifrar_limpio
      );

    -- Instancia Unidad de Control
    inst_UC: unidad_control 
    Port Map (
        clk             => clk,
        rst             => rst,
        btn_cifrar      => btn_cifrar_limpio, 
        seleccion_rotor => sw(14 downto 13),
        modo_descifrar  => sw(15),
        salidaMoore    => cable_control, -- Conecta salida a senyal interna
        salida_rotor0 => s_salida_rotor0,
        salida_rotor1 => s_salida_rotor1
    );

    -- Instancia Datapath
    inst_Datapath: datapath 
    Generic Map ( N => 5 )
    Port Map (
        clk => clk,
        
        entrada_letra => s_entrada_letra, -- Usar senyal s_...
        
        salidaMoore => cable_control,
        
        salida_letra    => s_salida_letra,  -- Usar senyal s_...
        salida_rotor0   => s_salida_rotor0, -- Usar senyal s_...
        salida_rotor1   => s_salida_rotor1 
    );

    -- Instancia Displays
    inst_Displays: displays 
    Port Map ( 
        rst => rst,
        clk => clk,        
        digito_0 => s_salida_letra,  -- Letra resultante
        digito_1 => s_entrada_letra, -- Letra entrada
        digito_2 => s_salida_rotor0, -- Rotor valor
        digito_3 => s_salida_rotor1, -- Rotor Aux o Ceros
        display  => display,
        display_enable => s_display
    );

    -- Leds de depuracion
    leds(15) <= sw(15); -- Modo
    leds(14 downto 13) <= sw(14 downto 13); -- Seleccion rotor
    leds(12 downto 5) <= (others => '0');
    leds(4 downto 0) <= s_entrada_letra; -- Muestra switch entrada

end Behavioral;