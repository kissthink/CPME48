----------------------------------------------------------------------------------
-- Company: Harbin Institute of Technology
-- Engineer: DeathKing<dk@hit.edu.cn>
-- 
-- Create Date:    11:12:49 07/14/2014 
-- Design Name: 
-- Module Name:    cpme48 - Behavioral 
-- Project Name:   CPME48
-- Target Devices: 
-- Tool versions: 
-- Description: 
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

entity cpme48 is
   Port (
      rst   : in    STD_LOGIC;
      clk   : in    STD_LOGIC;
      ABUS  : out   STD_LOGIC_VECTOR(15 downto 0);
		ABUSout : out STD_LOGIC_VECTOR(15 downto 0);
      DBUS  : inout STD_LOGIC_VECTOR(15 downto 0);
		DBUSout : out STD_LOGIC_VECTOR(15 downto 0);
		IR    : out   STD_LOGIC_VECTOR(15 downto 0);
      nMREQ : out   STD_LOGIC;
      nRD   : out   STD_LOGIC;
      nWR   : out   STD_LOGIC;
		nBHE  : out   STD_LOGIC;
		nBLE  : out   STD_LOGIC;
      IOAD  : out   STD_LOGIC_VECTOR(2 downto 0);
		IOin  : in    STD_LOGIC_VECTOR(7 downto 0);
		IOout : out   STD_LOGIC_VECTOR(7 downto 0);
		bst   : out   STD_LOGIC_VECTOR(3 downto 0);
      nPREQ : out   STD_LOGIC;
      nPRD  : out   STD_LOGIC;
      nPWR  : out   STD_LOGIC
   ); 

end cpme48;

architecture Behavioral of cpme48 is

   -- Beat Generator Declare
	component beat
		Port ( clk   : in  STD_LOGIC;
             rst   : in  STD_LOGIC;
             reset : out STD_LOGIC;
             bst   : out STD_LOGIC_VECTOR(3 downto 0));
   end component;
   
   -- Instruction Fetch Declare
   component insfetch
		Port ( en       : in  STD_LOGIC;
				 rst      : in  STD_LOGIC;
             IRnew    : in  STD_LOGIC_VECTOR (15 downto 0);
             PCnew    : in  STD_LOGIC_VECTOR (15 downto 0);
             PCupdate : in  STD_LOGIC;
             PC       : out STD_LOGIC_VECTOR (15 downto 0);
			    IRout    : out STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	-- ALU Declare
	component alu
	   Port ( en      : in STD_LOGIC;
             rst     : in STD_LOGIC;
             Rupdate : in STD_LOGIC;
             Rdata   : in STD_LOGIC_VECTOR(7 downto 0);
             Raddr   : in STD_LOGIC_VECTOR(2 downto 0);
             IR      : in STD_LOGIC_VECTOR(15 downto 0);
             Addr    : out STD_LOGIC_VECTOR(15 downto 0);
             ALUout  : out STD_LOGIC_VECTOR(7 downto 0));
	end component;

	-- Memory Access Declare
	component memo
		Port ( en     : in    STD_LOGIC;
             rst    : in    STD_LOGIC;
			    IR     : in    STD_LOGIC_VECTOR(15 downto 0);
             Addr   : in    STD_LOGIC_VECTOR(15 downto 0);
			    ALUout : in    STD_LOGIC_VECTOR(7 downto 0);
			    Rtemp  : in    STD_LOGIC_VECTOR(7 downto 0);
			    nWR    : out   STD_LOGIC;
			    nRD    : out   STD_LOGIC;
             nPREQ  : out   STD_LOGIC;
             nPWR   : out   STD_LOGIC;
             nPRD   : out   STD_LOGIC;
			    MAR    : out   STD_LOGIC_VECTOR(15 downto 0);
			    MDR    : out   STD_LOGIC_VECTOR(7 downto 0);
             IOAD   : out   STD_LOGIC_VECTOR(2 downto 0);
             IOin   : in    STD_LOGIC_VECTOR(7 downto 0);
             IOout  : out   STD_LOGIC_VECTOR(7 downto 0);
			    ACSout : out   STD_LOGIC_VECTOR(7 downto 0));
	end component;

	-- Written Back Declare
	component wrback
		Port ( en     : in   STD_LOGIC;
			    ALUout : in   STD_LOGIC_VECTOR(7 downto 0);
			    IR     : in   STD_LOGIC_VECTOR(15 downto 0);
	          Addr   : in   STD_LOGIC_VECTOR(15 downto 0);
	          PC     : in   STD_LOGIC_VECTOR(15 downto 0);
			    Raddr  : out  STD_LOGIC_VECTOr(2 downto 0);
             Rdata  : out  STD_LOGIC_VECTOR(7 downto 0);
             PCnew  : out  STD_LOGIC_VECTOR(15 downto 0);
             PCupdate : out  STD_LOGIC;
             Rupdate  : out  STD_LOGIC);
	 end component;
	 
	 -- Memory Control Declare
	 component memctrl
		Port ( PC     : in    STD_LOGIC_VECTOR(15 downto 0);
             Addr   : in    STD_LOGIC_VECTOR(15 downto 0);
             ALUout : in    STD_LOGIC_VECTOR(7 downto 0);
             bst    : in    STD_LOGIC_VECTOR(3 downto 0);
			    rst    : in    STD_LOGIC;
             niRD   : in    STD_LOGIC;
             niWR   : in    STD_LOGIC;
             IRnew  : out   STD_LOGIC_VECTOR(15 downto 0);
             Rtemp  : out   STD_LOGIC_VECTOR(7 downto 0);
             nRD    : out   STD_LOGIC;
             nWR    : out   STD_LOGIC;
             nBHE   : out   STD_LOGIC;
             nLHE   : out   STD_LOGIC;
             nMREQ  : out   STD_LOGIC;
             ABUS   : out   STD_LOGIC_VECTOR(15 downto 0);
             DBUS   : inout STD_LOGIC_VECTOR(15 downto 0));
	  end component;
	  
	  signal wire_bst : STD_LOGIC_VECTOR(3 downto 0);
	  signal wire_rst : STD_LOGIC;
	  signal wire_abus : STD_LOGIC_VECTOR(15 downto 0);
	  signal wire_mc2if_mdr2ir : STD_LOGIC_VECTOR(15 downto 0);
	  signal wire_wb2if_pcn2pc : STD_LOGIC_VECTOR(15 downto 0);
	  signal wire_wb2if_pcu2pcu : STD_LOGIC;
	  signal wire_if2mc_pc2pc: STD_LOGIC_VECTOR(15 downto 0);
	  signal wire_if2all_irbus: STD_LOGIC_VECTOR(15 downto 0);
	  signal wire_if2mc_nrd2nfrd : STD_LOGIC;
	  signal wire_wb2alu_ru2ru : STD_LOGIC;
	  signal wire_wb2alu_rd2rd : STD_LOGIC_VECTOR(7 downto 0);
	  signal wire_wb2alu_rad2rad : STD_LOGIC_VECTOR(2 downto 0);
	  signal wire_alu2mm_adr2adr : STD_LOGIC_VECTOR(15 downto 0);
	  signal wire_alu2mm_ao2ao : STD_LOGIC_VECTOR(7 downto 0);
	  signal wire_mc2mm_mdr2rt : STD_LOGIC_VECTOR(7 downto 0);
	  signal wire_mm2mc_nwr2niwr : STD_LOGIC;
	  signal wire_mm2mc_nrd2nird : STD_LOGIC;
	  signal wire_mm2mc_adr2adr  : STD_LOGIC_VECTOR(15 downto 0);
	  signal wire_mm2mc_mdr2mdr  : STD_LOGIC_VECTOR(7 downto 0);
	  
	  signal wire_mm2wb_acs2ao   : STD_LOGIC_VECTOR(7 downto 0);
 
begin

   -- import beat generator unit
   ubeat: beat port map(
      clk   => clk,       -- global clock
      rst   => rst,       -- global reset
      reset => wire_rst,  -- reset out put to all modular
      bst   => wire_bst   -- bst output
   );
   
   -- import fetch instruction unit
   uinsfetch: insfetch port map(
      en       => wire_bst(3),
		rst      => wire_rst,
		IRnew    => wire_mc2if_mdr2ir,
		PCnew    => wire_wb2if_pcn2pc,
		PCupdate => wire_wb2if_pcu2pcu,
		PC       => wire_if2mc_pc2pc,
		IRout    => wire_if2all_irbus
   );

   -- import ALU
   ualu: alu port map(
		en       => wire_bst(2),
		rst      => wire_rst,
		Rupdate  => wire_wb2alu_ru2ru,
      Rdata    => wire_wb2alu_rd2rd,
		Raddr    => wire_wb2alu_rad2rad,
		IR       => wire_if2all_irbus,
		Addr     => wire_alu2mm_adr2adr,
		ALUout   => wire_alu2mm_ao2ao
   );

   -- import memory access unit
   umemo: memo port map(
		en     => wire_bst(1),
		rst    => wire_rst,
		IR     => wire_if2all_irbus,
		Addr   => wire_alu2mm_adr2adr,
		ALUout => wire_alu2mm_ao2ao,
		Rtemp  => wire_mc2mm_mdr2rt,
		nWR    => wire_mm2mc_nwr2niwr,
		nRD    => wire_mm2mc_nrd2nird,
		nPREQ  => nPREQ,
		nPWR   => nPWR,
		nPRD   => nPRD,
		MAR    => wire_mm2mc_adr2adr,
		MDR    => wire_mm2mc_mdr2mdr,
		IOAD   => IOAD,
		IOin   => IOin,
		IOout  => IOout,
		ACSout => wire_mm2wb_acs2ao
   );
   
   -- import written back unit
   uwrback: wrback port map(
		en => wire_bst(0),
		ALUout=> wire_mm2wb_acs2ao,
		IR  => wire_if2all_irbus,
		Addr => wire_mm2mc_adr2adr,
		PC => wire_if2mc_pc2pc,
		Raddr => wire_wb2alu_rad2rad,
		Rdata => wire_wb2alu_rd2rd,
		PCnew => wire_wb2if_pcn2pc,
      PCupdate => wire_wb2if_pcu2pcu,
		Rupdate  => wire_wb2alu_ru2ru
   );
   
   -- import memory control unit
   umemctrl: memctrl port map(
		bst => wire_bst,
		rst => wire_rst,
		PC => wire_if2mc_pc2pc,
		Addr => wire_mm2mc_adr2adr,
		ALUout => wire_mm2mc_mdr2mdr,
		niRD => wire_mm2mc_nrd2nird,
		niWR => wire_mm2mc_nwr2niwr,
		IRnew => wire_mc2if_mdr2ir,
		Rtemp => wire_mc2mm_mdr2rt,
		nRD => nRD,
		nWR => nWR,
		nBHE => nBHE,
		nLHE => nBLE,
		nMREQ => nMREQ,
		ABUS  => wire_ABUS,
      DBUS => DBUS
   );

	IR <= wire_if2all_irbus;
	bst <= wire_bst;
	
	DBUSOut <= DBUS;
	ABUSout <= wire_ABUS;
	ABUS <= wire_ABUS;
end Behavioral;
