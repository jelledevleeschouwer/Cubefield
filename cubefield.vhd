----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:43:52 10/16/2013 
-- Design Name: 
-- Module Name:    VGA_DRIVER - Behavioral 
-- Project Name: 
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
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;
USE ieee.numeric_std.ALL;
use work.cube_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cubefield is
    Generic (
				------- CONSTANTEN --------
				h_sync  	: integer := 96;
				h_bp     : integer := 48;
				h_active : integer := 640;
				h_total  : integer := 800;
				h_fp     : integer := 16;
				---------------------------
				v_sync  	: integer := 2;
				v_bp     : integer := 29;
				v_active : integer := 480;
				v_total  : integer := 521;
				v_fp     : integer := 10
				---------------------------
				);
    Port ( 	mclk 		: in  STD_LOGIC;
				HSYNC		: out STD_LOGIC;
				VSYNC		: out STD_LOGIC;
				PS2C		: in 	STD_LOGIC;
				PS2D		: in 	STD_LOGIC;
				Led		: inout STD_LOGIC_VECTOR (7 downto 0);
				OutRed	: out STD_LOGIC_VECTOR (2 downto 0);
				OutGreen	: out STD_LOGIC_VECTOR (2 downto 0);
				OutBlue	: out STD_LOGIC_VECTOR (2 downto 1)
				);
end cubefield;

architecture Behavioral of cubefield is

--*************************--
--******** SIGNALS ********--
--*************************--

-----------CLK----------
signal clk_25MHz		: std_logic := '0';

-------- VGA Timing --------
signal frame_active	: std_logic := '0';
--VGA Render binnen scherm--
signal h_cnt : integer range 0 to 640 := 0;
signal v_cnt : integer range 0 to 480 := 0;
signal color : std_logic_vector (7 downto 0):= "00000000";

--- SIGNALEN COMPONENTEN ---
signal address_horizon	: std_logic_vector (8 downto 0) := "000000000";
signal color_horizon		: std_logic_vector (7 downto 0) := "00000000";

--------- KEYBOARD ---------
signal cursor_x 	: h_c := 315;
signal direction  : std_logic := '1';
signal shoot 		: std_logic := '0';
signal shoot_c		: std_logic := '0';
signal rst 			: std_logic := '0';

---------- BLOCKS ----------
--											  .x,  .y, .s,  .en, .rf,.inc	  .t
signal blocks : T_2D (0 to 5):= ((370, 270, 10,  '0',   0,   0, '0'), -- 0
											(345, 270, 10,  '0',   0,   0, '0'), -- 1
											(320, 270, 10,  '0',   0,   0, '0'), -- 2
											(295, 270, 10,  '0',   0,   0, '0'), -- 3
											(270, 270, 10,  '0',   0,   0, '0'), -- 4
											(300, 270, 10,  '0',   0,   0, '0')  -- 5
											);
signal shadows: T_2D2 (0 to 5);
							
signal random_num  : integer range 192 to 447;

----------- GAME ----------
signal score : std_logic_vector (7 downto 0) := "00000000";

--*************************--
--****** COMPONENTEN ******--
--*************************--
component horizon
	port(
		clka	: in std_logic;
		addra	: in std_logic_vector(8 downto 0);
		douta : out std_logic_vector(7 downto 0)
	);
end component;

component rand
	port( 
		clk : in  STD_LOGIC;
      random_num : out integer range 192 to 447
	);
end component;

component PS2_basys2
	port (
		PS2C		: in  STD_LOGIC;
		PS2D 		: in  STD_LOGIC;
		direction: out STD_LOGIC;
		shoot		: out STD_LOGIC;
		rst 		: out STD_LOGIC
	);
end component;

--*************************--
--********* BEGIN *********--
--*************************--
begin

OutRed <= color (7 downto 5);
OutGreen <= color (4 downto 2);
OutBlue <= color (1 downto 0);

Led <= score;

--****************--
--*** PORTMAPS ***--
--****************--
h1 : horizon Port Map (
	clka => clk_25MHz,
	addra => address_horizon,
	douta => color_horizon
);

r1 : rand Port Map (
	clk => PS2D,
	random_num => random_num
);

ps2 : PS2_basys2 Port Map (
	PS2C => PS2C,
	PS2D => PS2D,
	direction => direction,
	shoot	=> shoot,
	rst => rst
);

--****************--
--** PROCESSEN ***--
--****************--

process (mclk) begin
	if rising_edge (mclk) then
		clk_25MHz <= not clk_25MHz; -- Generate 25 MHz CLK
	end if;
end process;

process (clk_25MHz)
	variable pixel_cnt	: integer range 0 to 800 := 0;
	variable line_cnt		: integer range 0 to 525 := 0;
begin
	if rising_edge (clk_25MHz) then
		pixel_cnt := pixel_cnt + 1; -- increment pixels;
		
		--- Begin counting pixels
		if pixel_cnt = h_sync then
			HSYNC <= '1';
		elsif pixel_cnt = (h_total) then
			HSYNC <= '0';
			pixel_cnt := 0;
			line_cnt := line_cnt + 1; -- increment lines;
		end if;
		--- End counting pixels
		
		--- Begin counting lines
		if line_cnt = v_sync then
			VSYNC <= '1';
		elsif line_cnt = (v_sync + v_bp) then
			frame_active <= '1';
		elsif line_cnt = (v_total - v_fp) then
			frame_active <= '0';
		elsif line_cnt = (v_total) then
			VSYNC <= '0';
			line_cnt := 0;
		end if;
		--- End counting lines
		
		if (line_cnt > (v_sync + v_bp)) and (line_cnt < (v_total - v_fp)) then
			if (pixel_cnt > (h_sync + h_bp)) and (pixel_cnt < (h_total - h_fp)) then
				h_cnt <= pixel_cnt - (h_sync + h_bp);
				v_cnt <= line_cnt - (v_sync + v_bp);
			end if;
		end if;
	end if;
end process;

---------RENDERING--------
process (clk_25MHz)
	variable inBlocks: t_t:= 0;
	variable inShadows:t_t:= 0;
begin
	if (rising_edge(clk_25MHz)) then
	
		inBlocks := inBlockArray(h_cnt, v_cnt, blocks);
		inShadows:= inShadowArray(h_cnt, v_cnt, shadows);
		
		if inBlocks = 1 then
			color <= "11000000"; -- BLOCKS
		elsif inShadows = 1 then
			color <= "10100000"; -- SHADOWS
		elsif inBlocks = 2 then
			color <= "00000011"; -- BLOCKS BLUE
		elsif inShadows = 2 then
			color <= "00000010"; -- SHADOWS BLUE
		elsif (h_cnt >= cursor_x) and (h_cnt <= (cursor_x + 10)) and (v_cnt >= 450) and (v_cnt <= 460) then
			color <= "00011000"; -- CURSOR
		elsif (h_cnt > 0) and (h_cnt < 639) and (v_cnt > 1) and (v_cnt <= 480) then 
			address_horizon <= conv_std_logic_vector (v_cnt - 1, 9);
			color <= color_horizon; -- BACKGROUND
		else
			color <= "00000000"; -- BLACK
		end if;
	end if;
end process;

---------ANIMATIE--------
process (frame_active)
	variable refresh_cnt: integer range 0 to 50 := 0;
	variable block_count: integer range 0 to 10 := 0;
	variable cur_x_int  : integer range 0 to 640 := 0;
	variable lost  : std_logic := '0';
begin
	if (falling_edge(frame_active)) then
		--- RESET GAME
		if (rst = '1') then
			lost := '0';
		end if;
		
		if (lost = '0') then
			--- UPDATE CURSOR
			if (direction = '1') then
				cur_x_int := cursor_x + 8;
				if (cur_x_int > 590) then cur_x_int := 50; end if;
			else
				cur_x_int := cursor_x - 8;
				if (cur_x_int < 50) then cur_x_int := 590; end if;
			end if;
			cursor_x <= cur_x_int;
			
			--- UPDATE BLOCKS
			for i in 0 to 5 loop
				if ((cursor_x + 5) > blocks(i).x) and ((cursor_x + 5) < (blocks(i).x + blocks(i).s)) and (blocks(i).y + blocks(i).s = 454) then
					lost := '1';
				else
					blocks(i) <= move(blocks(i), random_num, shoot_c, cursor_x + 5); -- Update positie
					shadows(i) <= shadow(blocks(i)); -- Update shadow
				end if;
			end loop;
			
			
			--- ENABLE BLOCKS
			if (refresh_cnt = 9) then
				refresh_cnt := 0;
				if (blocks(block_count).en = '0') then
					blocks(block_count).en <= '1';
				else
					if (block_count = 5) then
						block_count := 0;
					else
						block_count := block_count + 1;
					end if;
				end if;
			else
				refresh_cnt := refresh_cnt + 1;
			end if;
		end if;
	end if;
end process;

process (shoot,frame_active)
	variable game_shot : std_logic;
begin  
	game_shot := '0';
   if frame_active = '0' then
      shoot_c <= '0';
   elsif (rising_edge(shoot) and shoot = '1') then
      shoot_c <= '1';
   end if;
end process;

end Behavioral;
