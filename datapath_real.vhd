-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.0 Build 156 04/24/2013 SJ Web Edition"
-- CREATED		"Wed Oct 30 02:31:02 2013"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY datapath_real IS 
	PORT
	(
		Clk :  IN  STD_LOGIC;
		Continue :  IN  STD_LOGIC;
		Reset :  IN  STD_LOGIC;
		Run :  IN  STD_LOGIC;
		ContinueIR :  IN  STD_LOGIC;
		S :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		HEX0 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX2 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX3 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX4 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX5 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX6 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX7 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		Instruct :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		MAR :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		MDR :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		PC :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END datapath_real;

ARCHITECTURE bdf_type OF datapath_real IS 

COMPONENT cpu
	PORT(Clk : IN STD_LOGIC;
		 Reset : IN STD_LOGIC;
		 Run : IN STD_LOGIC;
		 Continue : IN STD_LOGIC;
		 ContinueIR : IN STD_LOGIC;
		 Mem_Bus : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 S : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 CE : OUT STD_LOGIC;
		 UB : OUT STD_LOGIC;
		 LB : OUT STD_LOGIC;
		 OE : OUT STD_LOGIC;
		 WE : OUT STD_LOGIC;
		 Address : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
		 Instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 ledVect12 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		 MAR : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 MDR : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mem2io
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 CE : IN STD_LOGIC;
		 UB : IN STD_LOGIC;
		 LB : IN STD_LOGIC;
		 OE : IN STD_LOGIC;
		 WE : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		 Data_CPU : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Data_Mem : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Switches : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 HEX0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 HEX1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 HEX2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 HEX3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT hexdriver
	PORT(In0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Out0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT test_memory
	PORT(Reset : IN STD_LOGIC;
		 CE : IN STD_LOGIC;
		 UB : IN STD_LOGIC;
		 LB : IN STD_LOGIC;
		 WE : IN STD_LOGIC;
		 OE : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		 I_O : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	gdfx_temp0 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	gdfx_temp1 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	Instruct_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_22 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC_VECTOR(17 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(3 DOWNTO 0);


BEGIN 



b2v_inst : cpu
PORT MAP(Clk => Clk,
		 Reset => Reset,
		 Run => Run,
		 Continue => Continue,
		 ContinueIR => ContinueIR,
		 Mem_Bus => gdfx_temp0,
		 S => S,
		 CE => SYNTHESIZED_WIRE_19,
		 UB => SYNTHESIZED_WIRE_20,
		 LB => SYNTHESIZED_WIRE_21,
		 OE => SYNTHESIZED_WIRE_22,
		 WE => SYNTHESIZED_WIRE_23,
		 Address => SYNTHESIZED_WIRE_24,
		 Instruction => Instruct_ALTERA_SYNTHESIZED,
		 MAR => MAR,
		 MDR => MDR,
		 PC => PC);


b2v_inst1 : mem2io
PORT MAP(clk => Clk,
		 reset => SYNTHESIZED_WIRE_18,
		 CE => SYNTHESIZED_WIRE_19,
		 UB => SYNTHESIZED_WIRE_20,
		 LB => SYNTHESIZED_WIRE_21,
		 OE => SYNTHESIZED_WIRE_22,
		 WE => SYNTHESIZED_WIRE_23,
		 A => SYNTHESIZED_WIRE_24,
		 Data_CPU => gdfx_temp0,
		 Data_Mem => gdfx_temp1,
		 Switches => S,
		 HEX0 => SYNTHESIZED_WIRE_7,
		 HEX1 => SYNTHESIZED_WIRE_8,
		 HEX2 => SYNTHESIZED_WIRE_9,
		 HEX3 => SYNTHESIZED_WIRE_10);


b2v_inst10 : hexdriver
PORT MAP(In0 => Instruct_ALTERA_SYNTHESIZED(7 DOWNTO 4),
		 Out0 => HEX5);


b2v_inst11 : hexdriver
PORT MAP(In0 => Instruct_ALTERA_SYNTHESIZED(3 DOWNTO 0),
		 Out0 => HEX4);


b2v_inst12 : hexdriver
PORT MAP(In0 => SYNTHESIZED_WIRE_7,
		 Out0 => HEX0);


b2v_inst13 : hexdriver
PORT MAP(In0 => SYNTHESIZED_WIRE_8,
		 Out0 => HEX1);


b2v_inst14 : hexdriver
PORT MAP(In0 => SYNTHESIZED_WIRE_9,
		 Out0 => HEX2);


b2v_inst15 : hexdriver
PORT MAP(In0 => SYNTHESIZED_WIRE_10,
		 Out0 => HEX3);


b2v_inst2 : test_memory
PORT MAP(Reset => SYNTHESIZED_WIRE_18,
		 CE => SYNTHESIZED_WIRE_19,
		 UB => SYNTHESIZED_WIRE_20,
		 LB => SYNTHESIZED_WIRE_21,
		 WE => SYNTHESIZED_WIRE_23,
		 OE => SYNTHESIZED_WIRE_22,
		 A => SYNTHESIZED_WIRE_24,
		 I_O => gdfx_temp1);


SYNTHESIZED_WIRE_18 <= NOT(Reset);



b2v_inst8 : hexdriver
PORT MAP(In0 => Instruct_ALTERA_SYNTHESIZED(15 DOWNTO 12),
		 Out0 => HEX7);


b2v_inst9 : hexdriver
PORT MAP(In0 => Instruct_ALTERA_SYNTHESIZED(11 DOWNTO 8),
		 Out0 => HEX6);

Instruct <= Instruct_ALTERA_SYNTHESIZED;

END bdf_type;