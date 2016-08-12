library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sr_mux2_1 is
	port(
		s		: in std_logic;
		Dina	: in std_logic_vector(2 downto 0);
		DinB	: in std_logic_vector(2 downto 0);
		Dout	: out std_logic_vector(2 downto 0)
	);
end sr_mux2_1;

architecture Behavioral of sr_mux2_1 is
begin
	process(s, Dina, Dinb)
	variable state : std_logic_vector(2 downto 0);
	begin

		--select the source register control signal
		if(s = '1') then
			state := Dinb;
		elsif(s = '0') then
			state := Dina;
		else
			state := "XXX";
		end if;

		Dout <= state;

	end process;
end Behavioral;