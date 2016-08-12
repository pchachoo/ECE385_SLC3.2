library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tristate_buffer is
	port(
		s		: in std_logic;
		Din		: in std_logic_vector(15 downto 0);
		Dout	: out std_logic_vector(15 downto 0)
	);
end tristate_buffer;

architecture Behavioral of tristate_buffer is
begin
	
	state : process (Din, s)
	begin
		--either place data on output or leave it floating
		if(s = '1') then
			Dout <= Din;
		elsif(s = '0') then
			Dout <= "ZZZZZZZZZZZZZZZZ";	--floating i.e. not connected for the system bus
		else
			Dout <= "XXXXXXXXXXXXXXXX";
		end if;
	end process state;

end Behavioral;
