library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity zext16_18 is
	port(
		Din		: in std_logic_vector(15 downto 0);
		Dout	: out std_logic_vector(17 downto 0)
	);
end zext16_18;

architecture Behavioral of zext16_18 is
begin
	--zero extend
	Dout <= '0'&'0'&Din;

end Behavioral;