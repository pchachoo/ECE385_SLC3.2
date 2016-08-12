library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pc is
	port(
		Clk			: in std_logic;
		LD_PC		: in std_logic;
		Reset		: in std_logic;
		Run			: in std_logic;
		PCin		: in std_logic_vector(15 downto 0);
		S			: in std_logic_vector(15 downto 0);
		PCout		: out std_logic_vector(15 downto 0)
	);
end pc;

architecture Behavioral of pc is

	signal Reg_val : std_logic_vector(15 downto 0);

begin

	Reg_Reset : process(Clk, Reset, PCin, LD_PC, Reg_val, S, Run)
	begin

		--clear when reset is set
		if(Reset = '1') then
			Reg_val <= "0000000000000000";
		elsif(rising_edge(Clk)) then
			--check for load signal
			if(LD_PC = '1') then
				Reg_val <= PCin;
			end if;
		end if;

		PCout <= Reg_val;
	end process Reg_Reset;
end Behavioral;
