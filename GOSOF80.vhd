-- Top level file for a Gottlieb MA55 compatible Soundboard
-- GOSOF80 03.2020 by bontango www.lisy.dev
--
--
-- adapted from original version by 
-- (c)2015 James Sweet
--
-- This is free software: you can redistribute
-- it and/or modify it under the terms of the GNU General
-- Public License as published by the Free Software
-- Foundation, either version 3 of the License, or (at your
-- option) any later version.
--
-- This is distributed in the hope that it will
-- be useful, but WITHOUT ANY WARRANTY; without even the
-- implied warranty of MERCHANTABILITY or FITNESS FOR A
-- PARTICULAR PURPOSE. See the GNU General Public License
-- for more details.
--
-- Version 0.1

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity gosof80 is
	port(
		clk_50	: in std_logic;
		Reset_l	: in std_logic;
		Test		: in std_logic := '1';
		Audio_O	: out std_logic;
		S1 	   : in STD_LOGIC;						
		S2 	   : in STD_LOGIC;
		S4 	   : in STD_LOGIC;
		S8 	   : in STD_LOGIC;
		sound_tones : in STD_LOGIC;
		attract : in STD_LOGIC;
	   LED_0 	: out STD_LOGIC;						
		LED_1 	: out STD_LOGIC;
		LED_2 	: out STD_LOGIC;
		game_sel	:	in 	std_logic_vector(4 downto 0)  -- game selection S3
		);
end gosof80;

architecture rtl of gosof80 is 

signal cpu_clk	 : std_logic; -- 800 KHz CPU clock


begin
MA55: entity work.MA_55
port map(
	cpu_clk => cpu_clk,
	clk_50 => clk_50,
	reset_l => reset_l,
	S1 => not S1, --GOSOF80 uses active low
	S2 => not S2,
	S4 => not S4,
	S8 => not S8,
	Spare => '1',
	Test => Test,
	Attract => attract,
	Sound_Tones => sound_tones, 
	Audio_o => audio_o,
	game_sel => game_sel
	);

-- cpu clock 532Khz
clock_gen: entity work.cpu_clk_gen 
port map(   
	clk_in => clk_50,
	clk_out	=> cpu_clk
);
	
-- do some signaling on the FPGA board (in built LEDs)
LED_0 <= sound_tones;
LED_1 <= game_sel(0);
LED_2 <= NOT (S1 AND S2 AND S4 AND S8);

end rtl;