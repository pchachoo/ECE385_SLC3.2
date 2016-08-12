library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity plus1 is
	port(
		Din		: in std_logic_vector(15 downto 0);
		Dout	: out std_logic_vector(15 downto 0)
	);
end plus1;

architecture Behavioral of plus1 is
begin
	--incrementing logic
	increment : process(Din)
	begin
		--add one
		Dout <= Din + 1;
	end process increment;

end Behavioral;
