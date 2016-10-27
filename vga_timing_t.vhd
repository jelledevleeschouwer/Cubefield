-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;
use work.cube_pkg.all;

ENTITY testbench_vga IS
END testbench_vga;

ARCHITECTURE behavior OF testbench_vga IS
	component vga_timing
	port(
		clk 		: in  STD_LOGIC;
		HSYNC		: out STD_LOGIC;
		VSYNC		: out STD_LOGIC;
		frame_a 	: out STD_LOGIC;
		h_cnt 	: out integer range 0 to 640;
		v_cnt 	: out integer range 0 to 480
	);
	end component;
	
	CONSTANT PERIOD : time := 39.722ns;

	SIGNAL clk	: STD_LOGIC := '0';
	SIGNAL HSYNC: STD_LOGIC := '0';
	SIGNAL VSYNC: STD_LOGIC := '0';
	SIGNAL frame: STD_LOGIC := '0';
	SIGNAL h_cnt: integer range 0 to 640;
	SIGNAL v_cnt: integer range 0 to 480;
	
BEGIN
  
  -- Component Instantiation
	vga : vga_timing Port Map (
		clk => clk,
		HSYNC => HSYNC,
		VSYNC => VSYNC,
		frame_a => frame,
		h_cnt => h_cnt,
		v_cnt => v_cnt
	);
	
	clk_process : PROCESS
	BEGIN
		clk <= '0';
		wait for PERIOD/2;
		clk <= '1';
		wait for PERIOD/2;
	END PROCESS clk_process;
END;
