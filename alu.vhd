----------------------------------------------------------------------------------
-- Company: Harbin Institute of Technology
-- Engineer: DeathKing<dk@hit.edu.cn>
-- 
-- Create Date:    15:18:23 07/09/2014 
-- Design Name: 
-- Module Name:    alu - Behavioral 
-- Project Name:   CPME48
-- Target Devices: 
-- Tool versions: 
-- Description: alu.vhd is calculate modular.
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

entity alu is
   Port ( en : in STD_LOGIC );
end alu;

architecture Behavioral of alu is

   type reg_group is array(7 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
   
   signal Reg : reg_group;

begin


end Behavioral;

