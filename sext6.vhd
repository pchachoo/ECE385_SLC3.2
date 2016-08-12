library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sext6 is
	port(
		Din		: in std_logic_vector(5 downto 0);
		Dout	: out std_logic_vector(15 downto 0)
	);
end sext6;

architecture Behavioral of sext6 is
begin

	--sign extend
	Dout <= Din(5)&Din(5)&Din(5)&Din(5)&Din(5)&Din(5)&Din(5)&Din(5)&Din(5)&Din(5)&Din;

end Behavioral;