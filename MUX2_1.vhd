library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux2_1 is
	port(
		s		: in std_logic;
		Dina	: in std_logic_vector(15 downto 0);
		Dinb	: in std_logic_vector(15 downto 0);
		Dout	: out std_logic_vector(15 downto 0)
	);
end mux2_1;

architecture Behavioral of mux2_1 is
begin
	process(s, Dina, Dinb)
		variable state : std_logic_vector(15 downto 0);
	begin

		--select data based on select signal
		if(s = '1') then
			state := Dinb;
		elsif(s = '0') then
			state := Dina;
		else
			state := "XXXXXXXXXXXXXXXX";
		end if;

		Dout <= state;

	end process;
end Behavioral;
