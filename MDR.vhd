library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mdr is
	port(
		Clk			: in std_logic;
		LD_MDR		: in std_logic;
		MDRin		: in std_logic_vector(15 downto 0);
		MDRout		: out std_logic_vector(15 downto 0)
	);
end mdr;

architecture Behavioral of mdr is

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

	Reg_MDR : reg16
	port map(Clk => Clk,
			 LD => LD_MDR,
			 Din => MDRin,
			 Dout => MDRout
	);

end Behavioral;
