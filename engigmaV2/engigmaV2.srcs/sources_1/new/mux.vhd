-- 4 entradas de 5 bits, 2 bits control, 1 salida

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is

    generic (
        N : positive := 5   
    );

    Port(
        E0 : in std_logic_vector(N-1 downto 0);
        E1 : in std_logic_vector (N-1 downto 0);
        E2 : in std_logic_vector(N-1 downto 0);
        E3 : in std_logic_vector (N-1 downto 0);
        
        Control : in std_logic_vector (1 downto 0);
        
        Z : out std_logic_vector(N-1 downto 0)
    );
end mux;

architecture Behavioral of mux is

signal salida : std_logic_vector(N-1 downto 0);

begin

    process(Control)
        begin
            case Control is
                when "00" => 
                    salida <= E0;
                when "01" =>
                    salida <= E1;
                when "10" =>
                    salida <= E2;
                when "11" =>
                    salida <= E3;
                when others =>
                    salida <= (others => '0');
            end case;
    end process;
    
    Z <= salida;

end Behavioral;
