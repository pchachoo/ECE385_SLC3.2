library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sext9 is
	port(
		Din		: in std_logic_vector(8 downto 0);
		Dout	: out std_logic_vector(15 downto 0)
	);
end sext9;

architecture Behavioral of sext9 is
begin

	--sign extend
	Dout <= Din(8)&Din(8)&Din(8)&Din(8)&Din(8)&Din(8)&Din(8)&Din;

end Behavioral;