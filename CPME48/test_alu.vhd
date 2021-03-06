--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:44:18 07/13/2014
-- Design Name:   
-- Module Name:   D:/Code/VHDL/CPME48/test_alu.vhd
-- Project Name:  CPME48
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_UNSIGNED.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_alu IS
END test_alu;
 
ARCHITECTURE behavior OF test_alu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
      Port ( en      : in  STD_LOGIC;
             rst     : in  STD_LOGIC;
             Rupdate : in  STD_LOGIC;
             Rdata   : in  STD_LOGIC_VECTOR(7 downto 0);
             Raddr   : in  STD_LOGIC_VECTOR(2 downto 0);
             IR      : in  STD_LOGIC_VECTOR(15 downto 0);
             PC      : in  STD_LOGIC_VECTOR(15 downto 0);
             SPnew   : in  STD_LOGIC_VECTOR(7  downto 0);
             Addr    : out STD_LOGIC_VECTOR(15 downto 0);
             CSout   : out STD_LOGIC_VECTOR(15 downto 0);
             SPout   : out STD_LOGIC_VECTOR(7 downto 0);
             Reg0    : out STD_LOGIC_VECTOR(7 downto 0);
             Reg1    : out STD_LOGIC_VECTOR(7 downto 0);
             ALUout  : out STD_LOGIC_VECTOR(7 downto 0));
    END COMPONENT;
    

   --Inputs
   signal en : std_logic := '0';
   signal rst : std_logic := '0';
   signal Rupdate : std_logic := '0';
   signal Rdata : std_logic_vector(7 downto 0) := (others => '0');
   signal Raddr : std_logic_vector(2 downto 0) := (others => '0');
   signal IR : std_logic_vector(15 downto 0) := (others => '0');
   signal PC : std_logic_vector(15 downto 0) := (others => '0');
   signal SPnew : std_logic_vector(7 downto 0);

 	--Outputs
   signal ALUout : std_logic_vector(7 downto 0);
	signal Addr : std_logic_vector(15 downto 0);
   signal Reg0 : std_logic_vector(7 downto 0);
   signal Reg1 : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace en below with 
   -- appropriate port name 
 
   constant en_period : time := 10 ns;
   
   -- instruction tables
   constant iNOP : STD_LOGIC_VECTOR := "00000";
	constant iJMP : STD_LOGIC_VECTOR := "00001";
	constant iJZ  : STD_LOGIC_VECTOR := "00010";
	constant iSUB : STD_LOGIC_VECTOR := "00100";
	constant iADD : STD_LOGIC_VECTOR := "00110";
	constant iMVI : STD_LOGIC_VECTOR := "01000";
	constant iMOV : STD_LOGIC_VECTOR := "01010";
	constant iSTA : STD_LOGIC_VECTOR := "01100";
	constant iLDA : STD_LOGIC_VECTOR := "01110";
	constant iOUT : STD_LOGIC_VECTOR := "10000";
	constant iIN  : STD_LOGIC_VECTOR := "10010";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          en => en,
          rst => rst,
          Rupdate => Rupdate,
          Rdata => Rdata,
          Raddr => Raddr,
          SPnew => SPnew,
          IR => IR,
          PC => PC,
          ALUout => ALUout,
          Reg0 => Reg0,
          Reg1 => Reg1,
			 Addr => Addr
        );

   -- Clock process definitions
   en_process :process
   begin
		en <= '0';
		wait for en_period/2;
		en <= '1';
		wait for en_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for en_period/2;
      rst <= '1';
      wait for en_period/2;
      rst <= '0';
      wait for en_period;
      ---
      Rupdate <= '1';
      Raddr <= "000";
      Rdata <= "10101010";
      wait for en_period/2;
      Rupdate <= '0';
      wait for en_period/2;
      ---
      Rupdate <= '1';
      Raddr <= "001";
      Rdata <= "01010101";
      wait for en_period/2;
      Rupdate <= '0';
      wait for en_period/2;
      ---
      Rupdate <= '1';
      Raddr <= "111";
      Rdata <= "11111111";
      wait for en_period/2;
      Rupdate <= '0';
      wait for en_period/2;
      ---
      IR <= iADD & "000" & "00000" & "001";
		wait for en_period;
      --
		IR <= iSUB & "000" & "00000" & "001";
		wait for en_period;
		--
		IR <= iMOV & "000" & "00000" & "001";
		wait for en_period;
		--
		IR <= iMVI & "000" & "11111111";
		wait for en_period;
		--
		IR <= iJMP & "000" & "11110000";
		wait for en_period;
		--
		IR <= iJZ  & "000" & "00001111";
		wait for en_period;
      --
		IR <= iSTA & "000" & "10101010";
		wait for en_period;
		--
		IR <= iLDA & "000" & "01010101";
		wait for en_period;
      wait;
   end process;

END;
