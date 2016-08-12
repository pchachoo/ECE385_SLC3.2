library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ben_reg is
	port(
		Clk			: in std_logic;
		Reset		: in std_logic;
		LD_BEN		: in std_logic;
		NZP			: in std_logic_vector(2 downto 0);
		NZP_reg		: in std_logic_vector(2 downto 0);
		BEN			: out std_logic
	);
end ben_reg;

architecture Behavioral of ben_reg is

	signal reg_val : std_logic;

begin

	set_ben : process(NZP, NZP_reg, Clk, Reset, LD_BEN)
	begin
		if(Reset = '1') then
			reg_val <= '0';
		elsif(rising_edge(Clk)) then
			--check for load signal
			if(LD_BEN = '1') then
				--treat the NZP signal from the instruction registers as a mask for the NZP register bits
				--that represent the condition codes
				if(NZP(0) ='1' and NZP_reg(0) = '1') then
					reg_val <= '1';
				elsif(NZP(1) ='1' and NZP_reg(1) = '1') then
					reg_val <= '1';
				elsif(NZP(2) ='1' and NZP_reg(2) = '1') then
					reg_val <= '1';
				else
					reg_val <= '0';
				end if;
			end if;
		end if;
	end process set_ben;
	
	BEN <= reg_val;
end Behavioral;