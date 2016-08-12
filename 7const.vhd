library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity seven_const is
	port(
		valout	: out std_logic_vector(2 downto 0)
	);
end seven_const;

architecture Behavioral of seven_const is
begin
	--constant value of 7 using three bits is outputed for JSR
	--when we need to load R7 with the PC
	valout <= "111";

end Behavioral;