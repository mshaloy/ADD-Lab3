--------------------------------------------------------------------
-- Name:	Chris Coulston
-- Date:	Feb 3, 2015 
-- Modified:	Fall 2022
-- File:	lab2_fsm.vhdl
-- HW:	Lab2
--	Crs:	ECE 383
--
-- Purp: The control unit for the audio O'scope
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
use work.signalAcquire_Package.all;			-- include your library here with added components ac97, ac97cmd

entity signalAcquire_Fsm is
    PORT (  clk : in  STD_LOGIC;
            resetn : in  STD_LOGIC;
            sw: in STD_LOGIC_VECTOR(SW_WIDTH - 1 downto 0);
            cw: out STD_LOGIC_VECTOR (CW_WIDTH - 1 downto 0));
end signalAcquire_Fsm;

architecture Behavioral of signalAcquire_Fsm is

	signal state: state_type;
	
	signal SHORT_DELAY_DONE_SW : STD_LOGIC;
	signal LONG_DELAY_DONE_SW : STD_LOGIC;
	signal ALL_CHANNELS_READ_SW : STD_LOGIC;
	signal START_CONV_SW : STD_LOGIC;
	signal BUSY_SW : STD_LOGIC;

begin

    SHORT_DELAY_DONE_SW <= sw(SHORT_DELAY_DONE_SW_BIT_INDEX);
    LONG_DELAY_DONE_SW <= sw(LONG_DELAY_DONE_SW_BIT_INDEX);
    ALL_CHANNELS_READ_SW <= sw(ALL_CHANNELS_HAVE_BEEN_READ_SW_BIT_INDEX);
    START_CONV_SW <= sw(START_CONV_SW_BIT_INDEX);
    BUSY_SW <= sw(BUSY_SW_BIT_INDEX);
    
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
    state_proces: process(clk)
    begin
        if (rising_edge(clk)) then
            if (resetn = '0') then
                state <= RESET_STATE;
            else
                case state is
 
                    when RESET_STATE =>
                        state <= LONG_DELAY_STATE;
 
                    when LONG_DELAY_STATE =>
                        if (LONG_DELAY_DONE_SW = '1') then
                            state <= RESET_AD7606_STATE;
                        end if;
 
                    when RESET_AD7606_STATE =>
                        if (SHORT_DELAY_DONE_SW = '1') then
                            state <= WAIT_TRIGGER_STATE;
                        end if;
 
                    when WAIT_TRIGGER_STATE =>
                        if (START_CONV_SW = '1') then
                            state <= ASSERT_CONVST_STATE;
                        end if;
 
                    when ASSERT_CONVST_STATE =>
                        if (SHORT_DELAY_DONE_SW = '1') then
                            state <= WAIT_BUSY_0_STATE;
                        end if;
 
                    when WAIT_BUSY_0_STATE =>            -- busy is 0, wait for it to rise
                        if (BUSY_SW = '1') then
                            state <= WAIT_BUSY_1_STATE;
                        end if;
 
                    when WAIT_BUSY_1_STATE =>            -- busy is 1, wait for it to fall
                        if (BUSY_SW = '0') then
                            state <= WAIT_VALID_DATA_STATE;
                        end if;
 
                    when WAIT_VALID_DATA_STATE =>
                        if (SHORT_DELAY_DONE_SW = '1') then
                            state <= LATCH_STATE;
                        end if;
 
                    when LATCH_STATE =>
                        state <= PAUSE_BETWEEN_CHANNELS_STATE;
 
                    when PAUSE_BETWEEN_CHANNELS_STATE =>
                        if (SHORT_DELAY_DONE_SW = '1') then
                            if (ALL_CHANNELS_READ_SW = '1') then
                                state <= WAIT_TRIGGER_STATE;
                            else
                                state <= CLEAR_SHORT_COUNTER_STATE;
                            end if;
                        end if;
 
                    when CLEAR_SHORT_COUNTER_STATE =>
                        state <= WAIT_VALID_DATA_STATE;
 
                end case;
            end if;
        end if;
    end process;


    -------------------------------------------------------------------------------
    -- LPT: List all the bits of your control word and define their purpose.
    --      cw              Purpose
    --
    -- LPT: Add the truth table for any BBB which are used in the datapath
    --  counter control     Function
    -------------------------------------------------------------------------------
    output_process: process (state)
    begin
        case state is
            when RESET_STATE                    => cw <= "11101111110";  -- 0x77E
            when LONG_DELAY_STATE               => cw <= "11101011000";  -- 0x758
            when RESET_AD7606_STATE             => cw <= "11110010000";  -- 0x790
            when WAIT_TRIGGER_STATE             => cw <= "11100011110";  -- 0x71E
            when ASSERT_CONVST_STATE            => cw <= "01100010000";  -- 0x310
            when WAIT_BUSY_0_STATE              => cw <= "11100011000";  -- 0x718
            when WAIT_BUSY_1_STATE              => cw <= "11100011000";  -- 0x718
            when WAIT_VALID_DATA_STATE          => cw <= "10000010000";  -- 0x410
            when LATCH_STATE                    => cw <= "10000011001";  -- 0x419
            when PAUSE_BETWEEN_CHANNELS_STATE   => cw <= "11000010000";  -- 0x610
            when CLEAR_SHORT_COUNTER_STATE      => cw <= "11000011100";  -- 0x61C
        end case;
    end process;

end Behavioral;



