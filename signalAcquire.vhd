--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Fall 2022
-- File:	signalAcquire.vhd
--
-- Purp: Tie the datapath and control unit together
--
-- Documentation:	No help
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.signalAcquire_package.all;

					-- Include any packages that are instantiated


entity signalAcquire is
    PORT ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
		   btn: in	STD_LOGIC_VECTOR(2 downto 0);
		   an7606data: in STD_LOGIC_VECTOR(15 downto 0);
		   an7606convst, an7606cs, an7606rd, an7606reset: out STD_LOGIC;
		   an7606od: out STD_LOGIC_VECTOR(2 downto 0);
		   an7606busy : in STD_LOGIC;
		   reg0Magnitude: out STD_LOGIC_VECTOR(3 downto 0));		   
end signalAcquire;

architecture behavior of signalAcquire is
    signal sw: STD_LOGIC_VECTOR(SW_WIDTH-1 downto 0);
    signal cw: STD_LOGIC_VECTOR (CW_WIDTH - 1 downto 0);
	signal rfData: STD_LOGIC_VECTOR(15 downto 0);
	signal btnPrev: STD_LOGIC_VECTOR(2 downto 0);
	signal btnChange: STD_LOGIC_VECTOR(2 downto 0);
begin

    cu: signalAcquireFsm
	   PORT MAP(
	       clk => clk;
	       resetn => resetn;
	       sw => sw;
	       cw => cw;
	   );
	
	dataP: signalAcquire_Datapath
		PORT MAP(
			clk => clk;
        	resetn => resetn;
			cw => cw;
			sw => sw;
		    an7606data => an7606data;
		    rfAddr => '000';
		    rfData => rfData;
		);
	
	first_compare: genericCompare
        GENERIC MAP(16)
        PORT MAP(x => rfData, y => FIRST_THRESHOLD_CONSTANT, g => reg0Magnitude[FIRST_THRESHOLD_BIT_INDEX], e => open, l => open);
 
	second_compare: genericCompare
        GENERIC MAP(16)
        PORT MAP(x => rfData, y => SECOND_THRESHOLD_CONSTANT, g => reg0Magnitude[SECOND_THRESHOLD_BIT_INDEX], e => open, l => open);

	third_compare: genericCompare
        GENERIC MAP(16)
        PORT MAP(x => rfData, y => THIRD_THRESHOLD_CONSTANT, g => reg0Magnitude[THIRD_THRESHOLD_BIT_INDEX], e => open, l => open);

	fourth_compare: genericCompare
        GENERIC MAP(16)
        PORT MAP(x => rfData, y => FOURTH_THRESHOLD_CONSTANT, g => reg0Magnitude[FOURTH_THRESHOLD_BIT_INDEX], e => open, l => open);
	
	btnChange <= btnPrev xor btn;

	process(clk)
	begin
		if rising_edge(clk) then 
			if resetn = '0' then
				btnPrev <= (others => '1');
				btnChange <= (others => '0');
			else
				sw[START_CONV_SW_BIT_INDEX] <=  '0' when btnChange = "000" else
												'1' when (btnChange[0] = '1' and btn[0] = '0')
													or (btnChange[1] = '1' and btn[1] = '0')
													or (btnChange[2] = '1' and btn[2] = '0') else
												'0';
				btnPrev <= btn;
			end if;
		end if;
		
end behavior;
