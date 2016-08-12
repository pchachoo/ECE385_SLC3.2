library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--
-- Building block for the LC-3 16-bit architecture
--
entity reg16 is
	port(
		Clk		: in std_logic;
		LD		: in std_logic;
		Din		: in std_logic_vector(15 downto 0);
		Dout	: out std_logic_vector(15 downto 0)
	);
end reg16;

architecture Behavioral of reg16 is

	signal Dval : std_logic_vector(15 downto 0);

begin

	Reg : process(Clk, LD, Din)
	begin
		if(rising_edge(Clk)) then
			--check for load signal
			if(LD = '1') then
				Dval <= Din;
			end if;
		end if;
	end process Reg;

	Dout <= Dval;

end Behavioral;
