library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--sumador restador mod 25
entity sumador_restador is
    generic (
        N : positive := 5   
    );
    port (
        A   : in  STD_LOGIC_VECTOR(N-1 downto 0);
        B   : in  STD_LOGIC_VECTOR(N-1 downto 0);
        OP  : in  STD_LOGIC; -- 0 = suma, 1 = resta
        Y   : out STD_LOGIC_VECTOR(N-1 downto 0);
        Cout: out STD_LOGIC 
    );
end entity;

architecture Behavioral of sumador_restador is
    signal op_res : integer;
    signal int_A, int_B : integer;
begin
    int_A <= to_integer(unsigned(A));
    int_B <= to_integer(unsigned(B));

    process(int_A, int_B, OP)
        variable temp : integer;
    begin
        if OP = '0' then -- SUMA MOD 26
            temp := int_A + int_B;
            if temp > 25 then
                temp := temp - 26;
            end if;
        else             -- RESTA MOD 26
            temp := int_A - int_B;
            if temp < 0 then
                temp := temp + 26; 
            end if;
        end if;
        
        
        if temp > 31 then temp := 0; end if; 
        
        op_res <= temp;
    end process;

    Y <= std_logic_vector(to_unsigned(op_res, N));
    Cout <= '0'; 

end Behavioral;