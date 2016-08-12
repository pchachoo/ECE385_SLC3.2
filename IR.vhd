library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ir is
	port(
		Clk				: in std_logic;
		LD_IR			: in std_logic;
		Instruct_in		: in std_logic_vector(15 downto 0);
		Opcode			: out std_logic_vector(3 downto 0);
		IR_5			: out std_logic;
		DR_SR			: out std_logic_vector(2 downto 0);
		SR1_SR_BaseR	: out std_logic_vector(2 downto 0);
		SR2				: out std_logic_vector(2 downto 0);
		imm5			: out std_logic_vector(4 downto 0);
		PCoff9			: out std_logic_vector(8 downto 0);
		PCoff11			: out std_logic_vector(10 downto 0);
		off6			: out std_logic_vector(5 downto 0);
		ledVect12		: out std_logic_vector(11 downto 0);
		Instruct_out	: out std_logic_vector(15 downto 0);
		NZP				: out std_logic_vector(2 downto 0)
	);
end ir;

architecture Behavioral of ir is

	signal Instruct_val : std_logic_vector(15 downto 0);

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

	Reg_IR : reg16
	port map(Clk => Clk,
			 LD => LD_IR,
			 Din => Instruct_in,
			 Dout => Instruct_val
	);

	--breakout the instruction to form control signals
	--and parameters
	opcode <= Instruct_val(15 downto 12);
	DR_SR <= Instruct_val(11 downto 9);
	NZP <= Instruct_val(11 downto 9);
	SR1_SR_BaseR <= Instruct_val(8 downto 6);
	SR2 <= Instruct_val(2 downto 0);
	ledVect12 <= Instruct_val(11 downto 0);
	PCoff11 <= Instruct_val(10 downto 0);
	PCoff9 <= Instruct_val(8 downto 0);
	off6 <= Instruct_val(5 downto 0);
	imm5 <= Instruct_val(4 downto 0);
	IR_5 <= Instruct_val(5);
	Instruct_out <= Instruct_val;

end Behavioral;
