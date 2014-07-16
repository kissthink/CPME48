----------------------------------------------------------------------------------
-- Company: Harbin Institute of Technology
-- Engineer: DeathKing<dk@hit.edu.cn>
-- 
-- Create Date:    15:21:39 07/09/2014 
-- Design Name: 
-- Module Name:    insfetch - Behavioral 
-- Project Name:   CPME48
-- Target Devices: 
-- Tool versions: 
-- Description: insfetch.vhd is instruction fetch modular.
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

-- PC:       output port for PC
-- PCnew:    new PC value
-- PCupdate: signal that suggest PC must update
entity insfetch is
    Port ( en       : in  STD_LOGIC;
           IRnew    : in  STD_LOGIC_VECTOR (15 downto 0);
           PCnew    : in  STD_LOGIC_VECTOR (15 downto 0);
           PCupdate : in  STD_LOGIC;
           PC       : out STD_LOGIC_VECTOR (15 downto 0);
			  IRout    : out STD_LOGIC_VECTOR (15 downto 0);
           nRD      : out STD_LOGIC);
end insfetch;

architecture Behavioral of insfetch is

   signal rPC : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
   signal rIR : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

begin

   process (en, IRnew)
   begin
      if en'event and en = '1' then
			nRD <= '0';
		elsif en'event and en = '0' then
			nRD <= '1';
		elsif en = '1' then
		report("1");
			rIR <= IRnew;
      end if;
   end process;
   
--   process (IRnew)
--   begin
--      if en = '1' then
--         rIR <= IRnew;
--      end if;
--   end process;
   
   -- Some jump instructions like JMP JZ will affect PC
   -- so insfetch must update rPC
   process (PCupdate)
   begin
      if PCupdate = '1' then
         rPC <= PCnew;
      end if;
   end process;
   
   PC <= rPC;
   IRout <= rIR;
   
end Behavioral;

