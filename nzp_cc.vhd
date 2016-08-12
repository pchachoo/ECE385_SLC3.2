library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity nzp_cc is
	port(
		Clk				: in std_logic;
		Reset			: in std_logic;
		LD_CC			: in std_logic;
		Regfile_Data	: in std_logic_vector(15 downto 0);
		NZP_reg			: out std_logic_vector(2 downto 0)
	);
end nzp_cc;

architecture Behavioral of nzp_cc is

	signal reg_val : std_logic_vector(2 downto 0);

begin

	set_cc : process(Regfile_Data, Clk, Reset, LD_CC)
	begin
		if(Reset = '1') then
			reg_val <= "000";
		elsif(rising_edge(Clk)) then
			--check for load signal
			if(LD_CC = '1') then
				if(Regfile_Data = "0000000000000000") then
					reg_val <= "010";	--zero is on the bus
				elsif(Regfile_Data(15) = '1') then
					reg_val <= "100";	--negative number is on the bus
				elsif(Regfile_Data(15) = '0') then
					reg_val <= "001";	--postive number is on the bus
				else
					reg_val <= "000";
				end if;
			end if;
		end if;
	end process set_cc;
	
	NZP_reg <= reg_val;
end Behavioral;