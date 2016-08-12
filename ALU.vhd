library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port (
		A : in std_logic_vector (15 downto 0);
		B : in std_logic_vector (15 downto 0);
		Alu_Out : out std_logic_vector (15 downto 0);
		ALUK : in std_logic_vector (1 downto 0)
	);
end ALU;

architecture Behavioral of ALU is
	-- holds computed value
    signal out_value : std_logic_vector (15 downto 0);
begin
    arithmetic : process(A, B, ALUK)
    begin
        if (ALUK = "00") then		-- addition
            out_value <= (A + B);
        elsif (ALUK = "01")then		-- bitwise and
            out_value <= (A AND B);
        elsif (ALUK = "10") then	-- pass
            out_value <= A;
        elsif (ALUK = "11") then	-- bitwise not
            out_value <= (NOT A);
        else
            NULL;
        end if;
    end process arithmetic;

    Alu_Out <= out_value;

end Behavioral;
