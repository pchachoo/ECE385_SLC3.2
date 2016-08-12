library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sext11 is
	port(
		Din		: in std_logic_vector(10 downto 0);
		Dout	: out std_logic_vector(15 downto 0)
	);
end sext11;

architecture Behavioral of sext11 is
begin

	--sign extend
	Dout <= Din(10)&Din(10)&Din(10)&Din(10)&Din(10)&Din;

end Behavioral;