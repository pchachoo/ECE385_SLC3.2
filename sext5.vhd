library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sext5 is
	port(
		Din		: in std_logic_vector(4 downto 0);
		Dout	: out std_logic_vector(15 downto 0)
	);
end sext5;

architecture Behavioral of sext5 is
begin

	--sign extend
	Dout <= Din(4)&Din(4)&Din(4)&Din(4)&Din(4)&Din(4)&Din(4)&Din(4)&Din(4)&Din(4)&Din(4)&Din;

end Behavioral;