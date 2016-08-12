---------------------------------------------------------------------------
--      SLC3_2.vhd                                                       --
--      Stephen Kempf                                                    --
--      Created Spring 2006                                              --
--      Revised 3-22-2007                                                --
--                                                                       --
--      Spring 2007 Distribution                                         --
--                                                                       --
--      For use with ECE 385 Lab 10 (Test_Memory)                        --
--      UIUC ECE Department                                              --
---------------------------------------------------------------------------

-- TO USE: Include this file in your project, and paste the following 2 lines
--   (uncommented) into whatever file needs to reference the functions &
--   constants included in this file, just after the usual library references:
--library work;
--use work.SLC3_2.all;


library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

package SLC3_2 is
  
  -- Declare constants

   constant op_ADD : std_logic_vector(3 downto 0) := "0001"; -- opcode aliases
   constant op_AND : std_logic_vector(3 downto 0) := "0101";
   constant op_NOT : std_logic_vector(3 downto 0) := "1001";
   constant op_BR  : std_logic_vector(3 downto 0) := "0000";
   constant op_JMP : std_logic_vector(3 downto 0) := "1100";
   constant op_JSR : std_logic_vector(3 downto 0) := "0100";
   constant op_LDR : std_logic_vector(3 downto 0) := "0110";
   constant op_STR : std_logic_vector(3 downto 0) := "0111";
   constant op_PSE : std_logic_vector(3 downto 0) := "1101";

   constant NO_OP : std_logic_vector(15 downto 0) := x"0000"; -- "branch never" is a no op

   constant R0 : std_logic_vector(2 downto 0) := "000"; -- register aliases
   constant R1 : std_logic_vector(2 downto 0) := "001";
   constant R2 : std_logic_vector(2 downto 0) := "010";
   constant R3 : std_logic_vector(2 downto 0) := "011";
   constant R4 : std_logic_vector(2 downto 0) := "100";
   constant R5 : std_logic_vector(2 downto 0) := "101";
   constant R6 : std_logic_vector(2 downto 0) := "110";
   constant R7 : std_logic_vector(2 downto 0) := "111";

   constant p   : std_logic_vector(2 downto 0) := "001"; -- branch condition aliases
   constant z   : std_logic_vector(2 downto 0) := "010";
   constant zp  : std_logic_vector(2 downto 0) := "011";
   constant n   : std_logic_vector(2 downto 0) := "100";
   constant np  : std_logic_vector(2 downto 0) := "101";
   constant nz  : std_logic_vector(2 downto 0) := "110";
   constant nzp : std_logic_vector(2 downto 0) := "111";

   constant outHEX  : integer := -1; -- I/O address aliases
   constant inSW    : integer := -1;

  -- Declare functions and procedure

   -- The instruction functions
   function opCLR  ( DR : std_logic_vector ) return std_logic_vector; -- Alias for ANDi(DR, DR, 0)
   function opAND  ( DR, SR1, SR2 : std_logic_vector ) return std_logic_vector;
   function opANDi ( DR, SR : std_logic_vector; imm5 : integer ) return std_logic_vector;
   function opADD  ( DR, SR1, SR2 : std_logic_vector ) return std_logic_vector;
   function opADDi ( DR, SR : std_logic_vector; imm5 : integer ) return std_logic_vector;
   function opINC  ( DR : std_logic_vector ) return std_logic_vector; -- Alias for ADDi(DR, DR, 1)
   function opDEC  ( DR : std_logic_vector ) return std_logic_vector; -- Alias for ADDi(DR, DR, -1)
   function opNOT  ( DR, SR : std_logic_vector ) return std_logic_vector;
   function opBR   ( condition : std_logic_vector; PCoffset9 : integer ) return std_logic_vector;
   function opJMP  ( BaseR : std_logic_vector ) return std_logic_vector;
   constant opRET : std_logic_vector := op_JMP & "000" & R7 & "000000"; -- RET is so simple it can just be a constant; also an alias for JMP(R7)
   function opJSR  ( PCoffset11 : integer ) return std_logic_vector;
   function opLDR  ( DR, BaseR : std_logic_vector; offset6 : integer ) return std_logic_vector;
   function opSTR  ( SR, BaseR : std_logic_vector; offset6 : integer ) return std_logic_vector;
   function opPSE  ( ledVect12 : std_logic_vector ) return std_logic_vector;

--  function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
--  procedure <procedure_name>	(<type_declaration> <constant_name>	: in <type_declaration>);

end SLC3_2;


package body SLC3_2 is

function opCLR ( DR : std_logic_vector ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_AND;
   instruction(11 downto  9) := DR;
   instruction( 8 downto  6) := DR;
   instruction( 5 )          := '1';
   instruction( 4 downto  0) := conv_std_logic_vector(0,5);
   return instruction;
end opCLR;

function opAND ( DR, SR1, SR2 : std_logic_vector ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_AND;
   instruction(11 downto  9) := DR;
   instruction( 8 downto  6) := SR1;
   instruction( 5 downto  3) := "000";
   instruction( 2 downto  0) := SR2;
   return instruction;
end opAND;

function opANDi ( DR, SR : std_logic_vector; imm5 : integer ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_AND;
   instruction(11 downto  9) := DR;
   instruction( 8 downto  6) := SR;
   instruction( 5 )          := '1';
   instruction( 4 downto  0) := conv_std_logic_vector(imm5,5);
   return instruction;
end opANDi;

function opADD ( DR, SR1, SR2 : std_logic_vector ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_ADD;
   instruction(11 downto  9) := DR;
   instruction( 8 downto  6) := SR1;
   instruction( 5 downto  3) := "000";
   instruction( 2 downto  0) := SR2;
   return instruction;
end opADD;

function opADDi ( DR, SR : std_logic_vector; imm5 : integer ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_ADD;
   instruction(11 downto  9) := DR;
   instruction( 8 downto  6) := SR;
   instruction( 5 )          := '1';
   instruction( 4 downto  0) := conv_std_logic_vector(imm5,5);
   return instruction;
end opADDi;

function opINC ( DR : std_logic_vector ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_ADD;
   instruction(11 downto  9) := DR;
   instruction( 8 downto  6) := DR;
   instruction( 5 )          := '1';
   instruction( 4 downto  0) := conv_std_logic_vector(1,5);
   return instruction;
end opINC;

function opDEC ( DR : std_logic_vector ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_ADD;
   instruction(11 downto  9) := DR;
   instruction( 8 downto  6) := DR;
   instruction( 5 )          := '1';
   instruction( 4 downto  0) := conv_std_logic_vector(-1,5);
   return instruction;
end opDEC;

function opNOT ( DR, SR : std_logic_vector ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_NOT;
   instruction(11 downto  9) := DR;
   instruction( 8 downto  6) := SR;
   instruction( 5 downto  0) := "111111";
   return instruction;
end opNOT;

function opBR ( condition : std_logic_vector; PCoffset9 : integer ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_BR;
   instruction(11 downto  9) := condition;
   instruction( 8 downto  0) := conv_std_logic_vector(PCoffset9,9);
   return instruction;
end opBR;

function opJMP ( BaseR : std_logic_vector ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_JMP;
   instruction(11 downto  9) := "000";
   instruction(8  downto  6) := BaseR;
   instruction(5  downto  0) := "000000";
   return instruction;
end opJMP;

function opJSR ( PCoffset11 : integer ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_JSR;
   instruction(11)           := '1';
   instruction(10 downto  0) := conv_std_logic_vector(PCoffset11,11);
   return instruction;
end opJSR;

function opLDR ( DR, BaseR : std_logic_vector; offset6 : integer ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_LDR;
   instruction(11 downto  9) := DR;
   instruction( 8 downto  6) := BaseR;
   instruction( 5 downto  0) := conv_std_logic_vector(offset6,6);
   return instruction;
end opLDR;

function opSTR ( SR, BaseR : std_logic_vector; offset6 : integer ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_STR;
   instruction(11 downto  9) := SR;
   instruction( 8 downto  6) := BaseR;
   instruction( 5 downto  0) := conv_std_logic_vector(offset6,6);
   return instruction;
end opSTR;

function opPSE ( ledVect12 : std_logic_vector ) return std_logic_vector is
   variable instruction : std_logic_vector(15 downto 0);
begin
   instruction(15 downto 12) := op_PSE;
   instruction(11 downto  0) := ledVect12;
   return instruction;
end opPSE;

end SLC3_2;     
