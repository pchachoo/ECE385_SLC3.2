library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_unit is
	Port( 
		Clk : in std_logic;
		LD_REG : in std_logic;
		D : in std_logic_vector(15 downto 0);
		SR1			: in std_logic_vector(2 downto 0);
		SR2			: in std_logic_vector(2 downto 0);
		SR2_mux_out : out std_logic_vector(15 downto 0);
		SR1_mux_out : out std_logic_vector(15 downto 0);
		DR			: in std_logic_vector(2 downto 0)
	);
end reg_unit;

architecture Behavioral of reg_unit is

	signal load_0, load_1, load_2, load_3, load_4, load_5, load_6, load_7 : std_logic;
	signal Dout_0, Dout_1, Dout_2, Dout_3, Dout_4, Dout_5, Dout_6, Dout_7 : std_logic_vector(15 downto 0);

	--use a 16 bit register for the register file
	component reg16 is
		Port ( 
			Clk		: in std_logic;
			LD		: in std_logic;
			Din		: in std_logic_vector(15 downto 0);
			Dout	: out std_logic_vector(15 downto 0)
		);
	end component reg16;

begin

    input_data : process(Clk, LD_REG, DR)
	begin

		--by default no registers are loaded
		load_0 <= '0';
		load_1 <= '0';
		load_2 <= '0';
		load_3 <= '0';
		load_4 <= '0';
		load_5 <= '0';
		load_6 <= '0';
		load_7 <= '0';

		--check if the reigster file is to be modified
		if (LD_REG = '1') then
			--determine which register is to be written to and set its load signal
			case DR is
				when "000" =>
					load_0 <= '1';
				when "001" =>
					load_1 <= '1';
				when "010" =>
					load_2 <= '1';
				when "011" =>
					load_3 <= '1';
				when "100" =>
					load_4 <= '1';
				when "101" =>
					load_5 <= '1';
				when "110" =>
					load_6 <= '1';
				when "111" =>
					load_7 <= '1';
				when others =>
					NULL;
			end case;
		end if;
    end process input_data;

	--setup all the registers
	reg_7: reg16
	port map( 
		Clk => Clk,
		Din => D,
		LD => load_7,
		Dout => Dout_7
	);

	reg_6: reg16
	port map( 
		Clk => Clk,
		Din => D,
		LD => load_6,
		Dout => Dout_6
	);

	reg_5: reg16
	port map( 
		Clk => Clk,
		Din => D,
		LD => load_5,
		Dout => Dout_5
	);

	reg_4: reg16
	port map( 
		Clk => Clk,
		Din => D,
		LD => load_4,
		Dout => Dout_4
	);

	reg_3: reg16
	port map( 
		Clk => Clk,
		Din => D,
		LD => load_3,
		Dout => Dout_3
	);

	reg_2: reg16
	port map( 
		Clk => Clk,
		Din => D,
		LD => load_2,
		Dout => Dout_2
	);

	reg_1: reg16
	port map( 
		Clk => Clk,
		Din => D,
		LD => load_1,
		Dout => Dout_1
	);

	reg_0: reg16
	port map( 
		Clk => Clk,
		Din => D,
		LD => load_0,
		Dout => Dout_0
	);

	select_out : process(SR1, SR2, Dout_0, Dout_1, Dout_2, Dout_3, Dout_4, Dout_5, Dout_6, Dout_7)
	begin

		--determine which register to output on A
		case SR1 is
			when "000" =>
				SR1_mux_out <= Dout_0;
			when "001" =>
				SR1_mux_out <= Dout_1;
			when "010" =>
				SR1_mux_out <= Dout_2;
			when "011" =>
				SR1_mux_out <= Dout_3;
			when "100" =>
				SR1_mux_out <= Dout_4;
			when "101" =>
				SR1_mux_out <= Dout_5;
			when "110" =>
				SR1_mux_out <= Dout_6;
			when "111" =>
				SR1_mux_out <= Dout_7;
			when others =>
				SR1_mux_Out <= "XXXXXXXXXXXXXXXX";
		end case;

		--determine which retgister to output on B
		case SR2 is
			when "000" =>
				SR2_mux_out <= Dout_0;
			when "001" =>
				SR2_mux_out <= Dout_1;
			when "010" =>
				SR2_mux_out <= Dout_2;
			when "011" =>
				SR2_mux_out <= Dout_3;
			when "100" =>
				SR2_mux_out <= Dout_4;
			when "101" =>
				SR2_mux_out <= Dout_5;
			when "110" =>
				SR2_mux_out <= Dout_6;
			when "111" =>
				SR2_mux_out <= Dout_7;
			when others =>
				SR2_mux_Out <= "XXXXXXXXXXXXXXXX";
		end case;
	end process select_out;
end Behavioral;
