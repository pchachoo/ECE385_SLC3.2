library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mar is
	port(
		Clk			: in std_logic;
		LD_MAR		: in std_logic;
		MARin		: in std_logic_vector(15 downto 0);
		MARout		: out std_logic_vector(15 downto 0)
	);
end mar;

architecture Behavioral of mar is

	--16-bit register
	component reg16 is
		Port( 
			Clk		: in std_logic;
			LD		: in std_logic;
			Din		: in std_logic_vector(15 downto 0);
			Dout	: out std_logic_vector (15 downto 0)
		);
	end component reg16;

begin

	Reg_PC : reg16
	port map(
		Clk => Clk,
		LD => LD_MAR,
		Din => MARin,
		Dout => MARout
	);

end Behavioral;
