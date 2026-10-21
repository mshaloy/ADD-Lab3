--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 3, 2015
-- Modified:	Sept 2022
-- File:	lab2_datapath.vhdl
-- HW:	Lab 2
--	Crs:	ECE 383 and EENG 498
--
-- Purp: The datapath for the audio O'scope
--
-- Documentation:	No help, though I used an example from my Digital
--						Design text book.
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use work.basicBuildingBlocks_package.all;
use work.signalAcquire_package.all;

entity signalAcquire_Datapath is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
		   cw : in STD_LOGIC_VECTOR(CW_WIDTH - 1 downto 0);
		   sw : out STD_LOGIC_VECTOR(DATAPATH_SW_WIDTH - 1 downto 0);
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);
		   rfAddr: in STD_LOGIC_VECTOR(2 downto 0);
		   rfData: out STD_LOGIC_VECTOR(15 downto 0) );
end signalAcquire_Datapath;

architecture behavior of signalAcquire_Datapath is

  	signal rf_cnt: STD_LOGIC_VECTOR(3 downto 0);
  	signal short_cnt: STD_LOGIC_VECTOR(7 downto 0);
  	signal long_cnt: STD_LOGIC_VECTOR(23 downto 0);

begin
    
	addr_counter: genericCounter
        GENERIC MAP(4)
        PORT MAP(c => cw(2 downto 1), d => x"0", q => rf_cnt, clk =>clk, resetn => resetn);
        
    short_counter: genericCounter
        GENERIC MAP(8)
        PORT MAP(c => cw(4 downto 3), d => x"00", q => short_cnt, clk =>clk, resetn => resetn);
        
    long_counter: genericCounter
        GENERIC MAP(8)
        PORT MAP(c => cw(6 downto 5), d => x"00", q => long_cnt, clk =>clk, resetn => resetn);
        
    signalRegister: generic8RegisterFile
        GENERIC MAP(16)
        PORT MAP(clk => clk, resetn => resetn, write => cw(0), wrAddr => rf_cnt, rdAddr => rfAddr, D => an7606data, Q => rfData);
        
    addr_compare: genericCompare
        GENERIC MAP(4)
        PORT MAP(x => rf_cnt, y => "0111", g => open, e => sw(ALL_CHANNELS_HAVE_BEEN_READ_SW_BIT_INDEX), l => open);

    short_compare: genericCompare
        GENERIC MAP(8)
        PORT MAP(x => short_cnt, y => SHORT_DELAY_50Mhz_COUNTS, g => open, e => sw(SHORT_DELAY_DONE_SW_BIT_INDEX), l => open);
        
    long_compare: genericCompare
        GENERIC MAP(24)
        PORT MAP(x => long_cnt, y => LONG_DELAY_50Mhz_COUNTS, g => open, e => sw(LONG_DELAY_DONE_SW_BIT_INDEX), l => open);
   
end behavior;
