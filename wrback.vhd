----------------------------------------------------------------------------------
-- Company: Harbin Institute of Technology
-- Engineer: DeathKing<dk@hit.edu.cn>
-- 
-- Create Date:    16:21:38 07/11/2014 
-- Design Name: 
-- Module Name:    wrback - Behavioral 
-- Project Name:   CPME48
-- Target Devices: 
-- Tool versions: 
-- Description: Write back unit.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity wrback is
    Port ( en    : in   STD_LOGIC;
			  IRin  : in   STD_LOGIC_VECTOR (15 downto 0);
	        Addr  : in   STD_LOGIC_VECTOR (15 downto 0);
	        PCold : in   STD_LOGIC_VECTOR (15 downto 0);
			  Raddr : out  STD_LOGIC_VECTOR (15 downto 0);
           Rdata : out  STD_LOGIC_VECTOR (15 downto 0);
           PCnew : out  STD_LOGIC_VECTOR (15 downto 0);
           PCupdate : out  STD_LOGIC;
           Rupdate  : out  STD_LOGIC);
end wrback;

architecture Behavioral of wrback is

	alias OP  : STD_LOGIC_VECTOR(4 downto 0) is IR(15 downto 12);
	alias AD1 : STD_LOGIC_VECTOR(2 downto 0) is IR(10 downto 8);
	
	-- instructions table
	constant _JMP : STD_LOGIC_VECTOR := "00000";
	constant _JZ  : STD_LOGIC_VECTOR := "00010";
	constant _SUB : STD_LOGIC_VECTOR := "00100";
	constant _ADD : STD_LOGIC_VECTOR := "00110";
	constant _MVI : STD_LOGIC_VECTOR := "01000";
	constant _MOV : STD_LOGIC_VECTOR := "01010";
	constant _STA : STD_LOGIC_VECTOR := "01100";
	constant _LDA : STD_LOGIC_VECTOR := "01110";
	constant _OUT : STD_LOGIC_VECTOR := "10000";
	constant _IN  : STD_LOGIC_VECTOR := "10010";

begin

	process (IR)
	begin
		if OP = _JMP or OP = _JZ then
			PCnew <= Addr;
		else
			PCnew <= PCold + 1;
		end if;
		PCupdate <= '1';
	end process;
	
	process (en)
	begin
		if en'event and en = '0' then
			PCupdate <= '0';
		end if;
	end process;

end Behavioral;

