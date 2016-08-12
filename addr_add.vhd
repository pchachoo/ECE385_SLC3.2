library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity addr_add is
	port(
		ADDR1	: in std_logic_vector(15 downto 0);
		ADDR2	: in std_logic_vector(15 downto 0);
		ADDRout	: out std_logic_vector(15 downto 0)
	);
end addr_add;

architecture Behavioral of addr_add is
begin

	--output the addition of the two address parameters
	ADDRout <= ADDR1 + ADDR2;

end Behavioral;
