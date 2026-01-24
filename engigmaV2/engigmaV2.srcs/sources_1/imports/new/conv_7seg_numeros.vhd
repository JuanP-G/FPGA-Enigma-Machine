library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity conv_7seg_numeros is
    Port ( x : in  STD_LOGIC_VECTOR (4 downto 0);
           display : out  STD_LOGIC_VECTOR (6 downto 0));
end conv_7seg_numeros;

architecture Behavioral of conv_7seg_numeros is
    signal display_aux: STD_LOGIC_VECTOR (6 downto 0);
begin
    -- ORDEN CORRECTO: g f e d c b a
    -- '1' significa segmento ENCENDIDO (Logica Positiva)
    with x(3 downto 0) select
        display_aux <= 
            "0111111" when "0000", -- 0 (g apagado)
            "0000110" when "0001", -- 1
            "1011011" when "0010", -- 2
            "1001111" when "0011", -- 3
            "1100110" when "0100", -- 4
            "1101101" when "0101", -- 5
            "1111101" when "0110", -- 6
            "0000111" when "0111", -- 7
            "1111111" when "1000", -- 8
            "1101111" when "1001", -- 9
            "0000000" when others; -- Apagado

    -- INVERSION FINAL
    display <= not display_aux;
end Behavioral;