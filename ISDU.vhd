--------------------------------------------------------------------------------
-- Company: 		 UIUC ECE Dept.
-- Engineer:		 Stephen Kempf
--
-- Create Date:    17:44:03 10/08/06
-- Design Name:    ECE 385 Lab 10 Given Code - Incomplete ISDU
-- Module Name:    ISDU - Behavioral
--
-- Comments:
--    Revised 3-22-2007
--    Spring 2007 Distribution
--    Revised 10-22-2010
--    Spring 2013 Distribution
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ISDU is
    Port( clk           : in std_logic;
          Reset         : in std_logic;
          Run           : in std_logic;
          Continue      : in std_logic;
          ContinueIR    : in std_logic;  -- For partial testing in Week 1

          Opcode        : in std_logic_vector(3 downto 0);
          IR_5          : in std_logic;
		  BEN			: in std_logic;
 
          LD_MAR        : out std_logic;
          LD_MDR        : out std_logic;
          LD_IR         : out std_logic;
          LD_BEN        : out std_logic;
          LD_CC         : out std_logic;
          LD_REG        : out std_logic;
          LD_PC         : out std_logic;

          GatePC        : out std_logic;
          GateMDR       : out std_logic;
          GateALU       : out std_logic;
          GateADDR      : out std_logic;

          PCMUX         : out std_logic_vector(1 downto 0);
          DRMUX         : out std_logic;
          SR1MUX        : out std_logic;
          SR2MUX        : out std_logic;
          ADDR1MUX      : out std_logic;
          ADDR2MUX      : out std_logic_vector(1 downto 0);

          ALUK          : out std_logic_vector(1 downto 0);

          Mem_CE        : out std_logic;  -- The memory signals are active-low
          Mem_UB        : out std_logic;
          Mem_LB        : out std_logic;
          Mem_OE        : out std_logic;  -- "MIO.EN", but active-low
          Mem_WE        : out std_logic);
end ISDU;

architecture Behavioral of ISDU is

type ctrl_state is (Halted, PauseIR1, PauseIR2, S_18, S_33_1, S_33_2, S_35, S_32, S_01, S_02_1, S_02_2, S_03, S_04, S_05, S_07,
					Pause1_1, Pause1_2, Pause1_3, Pause2_1, Pause2_2, Pause2_3, S_08, S_09, S_10, S_11_1, S_11_2, S_12, S_13, S_14);
signal State, Next_state : ctrl_state;

begin

Assign_Next_State : process (clk, reset)
begin
  if (Reset = '1') then
    State <= Halted;
  elsif (rising_edge(clk)) then
    State <= Next_state;
  end if;
end process;

Get_Next_State : process (State, Opcode, Run, ContinueIR, Continue, IR_5, BEN)
begin
  case State is
    when Halted => 
      if (Run = '0') then
        Next_state <= Halted;
      else
        Next_state <= S_18;
      end if;

	--FETCH
    when S_18 =>
      Next_state <= S_33_1;
    when S_33_1 =>
      Next_state <= S_33_2;
    when S_33_2 =>
      Next_state <= S_35;
    when S_35 =>
      Next_state <= PauseIR1;
--		Next_state <= S_32;  -- Bypass PauseIR in Week 2.

    when PauseIR1 =>  -- Pause to display IR on HEX. (Week 1)
      if (ContinueIR = '0') then
        Next_state <= PauseIR1;
      else
        Next_state <= PauseIR2;
      end if;
    when PauseIR2 =>  -- Wait for ContinueIR to be released. (Week 1)
      if (ContinueIR = '1') then
        Next_state <= PauseIR2;
      else
--      Next_state <= S_32;
        Next_state <= S_18;
      end if;

	--DECODE
    when S_32 =>
      case Opcode is
        when "0001" =>  -- ADD 
          Next_state <= S_01;
        when "0101" =>	-- AND
          Next_state <= S_05;
        when "1001" =>	-- NOT
          Next_state <= S_09;
        when "0000" =>	-- BR
          Next_state <= S_07;
        when "1100" =>	-- JMP
          Next_state <= S_13;
        when "0100" =>	-- JSR
          Next_state <= S_14;
        when "0110" =>	-- LDR
          Next_state <= S_10;
        when "0111" =>	-- STR
          Next_state <= S_03;
        when "1101" =>	-- PAUSE
          Next_state <= Pause1_1;
        when others =>
          Next_state <= S_18;
      end case;

	--EXECUTE
    when S_07 =>	--BR
	  if(BEN = '1') then
		Next_state <= S_08;
	  else
		Next_state <= S_18;
	  end if;

	when S_10 =>	--LDR
	  Next_state <= S_11_1;
	when S_11_1 =>
	  Next_state <= S_11_2;
	when S_11_2 =>
	  Next_state <= S_12;

	when S_03 =>	--STR
	  Next_state <= S_04;
	when S_04 =>
	  Next_state <= S_02_1;
	when S_02_1 =>
	  Next_state <= S_02_2;

	--PAUSE
	when Pause1_1 =>  -- Pause to display LED vector
      if (Continue = '0') then
        Next_state <= Pause1_1;
      else
        Next_state <= Pause1_2;
      end if;
    when Pause2_1 =>  -- Wait for Continue to be released
      if (Continue = '1') then
        Next_state <= Pause2_1;
      else
        Next_state <= Pause2_2;
      end if;

	--extra states for the pause instruction to help with program hanging issues
    when Pause2_2 =>
	  Next_state <= Pause2_3;
    when Pause2_3 =>
	  Next_state <= S_18;
	when Pause1_2 =>
	  Next_state <= Pause1_3;
	when Pause1_3 =>
	  Next_state <= Pause2_1;

	--next instruction
    when S_01 =>
      Next_state <= S_18;
    when S_05 =>
      Next_state <= S_18;
    when S_09 =>
      Next_state <= S_18;
    when S_12 =>
      Next_state <= S_18;
    when S_08 =>
      Next_state <= S_18;
    when S_14 =>
      Next_state <= S_18;
    when S_13 =>
      Next_state <= S_18;
    when S_02_2 =>
	  Next_state <= S_18;

    when others =>
      NULL;
  end case;
end process;

Assign_Control_Signals : process (state, IR_5)
begin
  -- default controls signal values; within a process, these can be
  -- overridden further down (in the case statement, in this case)
  LD_MAR <= '0';
  LD_MDR <= '0';
  LD_IR  <= '0';
  LD_BEN <= '0';
  LD_CC  <= '0';
  LD_REG <= '0';
  LD_PC  <= '0';

  GatePC     <= '0';
  GateMDR    <= '0';
  GateALU    <= '0';
  GateADDR   <= '0';

  PCMUX    <= "00"; -- By default PC loads from PC+1 entity
  DRMUX    <= '0';	-- By default sends IR(11:9) to DR 
  SR1MUX   <= '0';	-- By default sends IR(8:6) to SR1 
  SR2MUX   <= '0';	-- By default Register File is selected
  ADDR1MUX <= '0';	-- By default PC is selected
  ADDR2MUX <= "00";	-- By default PCoffset11 is selected

  ALUK	   <= "00";	-- By default ADD is performed

  Mem_OE   <= '1';	-- These signals are active low
  Mem_WE   <= '1';

  case State is
    when Halted =>    -- Do nothing
    when S_18 =>      -- Fetch 1 (Week 1)
      GatePC <= '1';     -- PC drives bus,
      LD_MAR <= '1';     -- loaded into MAR
      PCMUX <= "00";     -- PC loads from PC+1 entity
      LD_PC <= '1';
    when S_33_1 =>    -- Fetch 2 (Week 1)
      Mem_OE <= '0';     -- Memory bus driven by Memory; also, MDRMUX takes data from memory bus
    when S_33_2 =>    -- Fetch 3 (Week 1)
      Mem_OE <= '0';     -- Memory bus still driven by Memory
      LD_MDR <= '1';     -- Load MDR from memory bus
    when S_35 =>      -- Fetch 4 (Week 1)
      GateMDR <= '1';    -- MDR drives bus,
      LD_IR <= '1';      -- loaded into IR
    when PauseIR1 =>  -- No control signals. IR should be displayed on HEX4-HEX7. (Week 1)
    when PauseIR2 =>  -- No control signals. (Week 1)
    when S_32 =>      -- Instruction Decode
      LD_BEN <= '1';     -- Load the BEN register (not shown on given BD)
    when S_01 =>	--ADD
      LD_CC <='1';
      LD_REG <= '1';     -- Store result to Regfile
      SR1MUX <= '0';	 -- default
      SR2MUX <= IR_5;    -- Selects between value from regfile or sign-extended immediate value
      DRMUX <= '0';		 -- default 
      GateALU <= '1';    -- ALU drives bus
      ALUK <= "00";      -- ALU perfroms addition; other functions are AND, NOT, and PASS
    when S_05 =>	--AND
      LD_CC <= '1';
      LD_REG <= '1';
      SR1MUX <= '0';	 -- default
      SR2MUX <= IR_5;	 -- Selects between value from regfile or sign-extended immediate value
      DRMUX <= '0';		 -- default
      GateALU <= '1';
      ALUK <= "01";		 -- AND
    when S_09 =>	--NOT
      LD_CC <= '1';
      LD_REG <= '1';
      SR1MUX <= '0';	 -- default
      DRMUX <= '0';		 -- default
      GateALU <= '1';
      ALUK <= "11";		 -- NOT
    when S_08 =>	--BR
      LD_PC <= '1';
      ADDR1MUX <= '0';	 -- default
      ADDR2MUX <= "01";	 -- PCoffset9
      PCMUX <= "10";	 -- ADDR adder
    when S_13 =>	--JMP
      LD_PC <= '1';
      PCMUX <= "01";	 -- sysbus
      SR1MUX <= '0';	 -- default
      GateALU <= '1';
      ALUK <= "10";		 -- PASS A
    when S_14 =>	--JSR
      LD_REG <= '1';
      LD_PC <= '1';
      DRMUX <= '1';		 -- R7
      ADDR1MUX <= '0';	 -- default
      ADDR2MUX <= "00";	 -- default
      PCMUX <= "10";	 -- ADDR adder
      GatePC <= '1';
    when S_03 =>	--STR 1
      LD_MAR <= '1';
	  SR1MUX <= '0';	 -- default
	  ADDR1MUX <= '1';	 -- SR1
	  ADDR2MUX <= "10";	 -- offset6
	  GateADDR <= '1';
	when S_04 =>	--STR 2
	  LD_MDR <= '1';
	  SR1MUX <= '1';	 -- IR(11:8)
	  GateALU <= '1';
	  ALUK <= "10";		 -- PASS A
	when S_02_1 =>	--STR 3
	  Mem_WE   <= '0';	 -- Memory bus driven by MDR
	when S_02_2 =>
	  Mem_WE   <= '0';	 -- Memory bus still driven by MDR
	when S_10 =>	--LDR 1
	  LD_MAR <= '1';
	  SR1MUX <= '0';	 -- default
	  ADDR1MUX <= '1';	 -- SR1
	  ADDR2MUX <= "10";	 -- offset6
	  GateADDR <= '1';
	when S_11_1 =>	--LDR 2
	  Mem_OE <= '0';     -- Memory bus driven by Memory; also, MDRMUX takes data from memory bus
	when S_11_2 =>
	  LD_MDR <= '1';     -- Load MDR from memory bus
	  Mem_OE <= '0';     -- Memory bus still driven by Memory
	when S_12 =>	--LDR 3
	  LD_REG <= '1';
	  DRMUX <= '0';	 -- default
	  GateMDR <= '1';

	when Pause1_1 =>	  -- No control signals; LED vector should be displayed
	when Pause1_2 =>
    when Pause2_1 =>	  -- No control signals
    when Pause2_2 =>
    when S_07	=>	  -- No control signals when determining whether to branch or not
    when others =>
      NULL;
  end case;
end process;

Mem_CE   <= '0'; -- Always enable the memory, both bytes (remember, active low!)
Mem_UB   <= '0';
Mem_LB   <= '0';

end Behavioral;      
