library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux4_1 is
	port(
		s		: in std_logic_vector(1 downto 0);
		Dina	: in std_logic_vector(15 downto 0);
		Dinb	: in std_logic_vector(15 downto 0);
		Dinc	: in std_logic_vector(15 downto 0);
		Dout	: out std_logic_vector(15 downto 0)
	);
end mux4_1;

architecture Behavioral of mux4_1 is
begin
	process(s, Dina, Dinb, Dinc)

		variable state : std_logic_vector(15 downto 0);

	begin
		--select data to output depending on select signal
		case s is
			when "00" =>
				state := Dina;
			when "01" =>
				state := Dinb;
			when "10" =>
				state := Dinc;
			when others =>
				state := "XXXXXXXXXXXXXXXX";
		end case;
		Dout <= state;
	end process;


end Behavioral;
