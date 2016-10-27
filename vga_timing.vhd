----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:24:49 12/31/2013 
-- Design Name: 
-- Module Name:    vga_timing - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_timing is
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
	Port ( 	clk 		: in  STD_LOGIC;
				HSYNC		: out STD_LOGIC;
				VSYNC		: out STD_LOGIC;
				frame_a 	: out STD_LOGIC;
				h_cnt 	: out integer range 0 to 640;
				v_cnt 	: out integer range 0 to 480
				);
end vga_timing;

architecture Behavioral of vga_timing is

begin

process (clk)
	variable pixel_cnt	: integer range -1 to 800 := -1;
	variable line_cnt		: integer range 0 to 525 := 0;
begin
	if rising_edge (clk) then
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
		if line_cnt = v_sync then -- 2
			VSYNC <= '1';
		elsif line_cnt = (v_sync + v_bp) then -- 31
			frame_a <= '1';
		elsif line_cnt = (v_total - v_fp) then -- 511
			frame_a <= '0';
		elsif line_cnt = (v_total) then -- 521
			VSYNC <= '0';
			line_cnt := 0;
		end if;
		--- End counting lines
		
		if (line_cnt > (v_sync + v_bp)) and (line_cnt < (v_total - v_fp)) then -- 31 < y < 511
			if (pixel_cnt > (h_sync + h_bp)) and (pixel_cnt < (h_total - h_fp)) then -- 144 < x < 784
				h_cnt <= pixel_cnt - (h_sync + h_bp);
				v_cnt <= line_cnt - (v_sync + v_bp);
			end if;
		end if;
	end if;
end process;

end Behavioral;

