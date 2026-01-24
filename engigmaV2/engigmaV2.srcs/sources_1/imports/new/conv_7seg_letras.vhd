library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity conv_7seg_letras is
    Port ( x : in  STD_LOGIC_VECTOR (4 downto 0);
           display : out  STD_LOGIC_VECTOR (6 downto 0));
end conv_7seg_letras;

architecture Behavioral of conv_7seg_letras is
    signal display_aux: STD_LOGIC_VECTOR (6 downto 0);
begin
    -- Orden: g f e d c b a
    with x select
        display_aux <= 
            "1110111" when "00000", -- A 
            "1111100" when "00001", -- b
            "0111001" when "00010", -- C 
            "1011110" when "00011", -- d
            "1111001" when "00100", -- E
            "1110001" when "00101", -- F
            "1111101" when "00110", -- G (como 6)
            "1110110" when "00111", -- H
            "0000110" when "01000", -- I (como 1)
            "0011110" when "01001", -- J
            "1110101" when "01010", -- K (parecida a H)
            "0111000" when "01011", -- L
            "0101010" when "01100", -- m (dos n) - (sale mal)
            "1010100" when "01101", -- n
            "0111111" when "01110", -- O (cero)
            "1110011" when "01111", -- P
            "1100111" when "10000", -- q
            "1010000" when "10001", -- r
            "1101101" when "10010", -- S (igual que 5)
            "1111000" when "10011", -- t
            "0111110" when "10100", -- U
            "0111110" when "10101", -- V (igual U)
            "0101010" when "10110", -- W (sale raro)
            "1110110" when "10111", -- X (H)
            "1101110" when "11000", -- y
            "1011011" when "11001", -- Z (2)
            "0000000" when others;

    display <= not display_aux;
end Behavioral;