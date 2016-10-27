-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;
use work.cube_pkg.all;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS
	component horizon
	port(
		clka	: in std_logic;
		addra	: in std_logic_vector(8 downto 0);
		douta : out std_logic_vector(7 downto 0)
	);
	end component;

	SIGNAL clk 		 			: STD_LOGIC := '0';
	signal address_horizon	: std_logic_vector (8 downto 0) := "000000000";
	signal color_horizon		: std_logic_vector (7 downto 0) := "00000000";
	signal x_s : integer range 0 to 640;
	signal y_s : integer range 0 to 480;
	CONSTANT PERIOD : time := 39.722ns;
	
BEGIN
  
  -- Component Instantiation
	h1 : horizon Port Map (
		clka => clk,
		addra => address_horizon,
		douta => color_horizon
	);
	
	clk_process : PROCESS
	BEGIN
		clk <= '0';
		wait for PERIOD/2;
		clk <= '1';
		wait for PERIOD/2;
	END PROCESS clk_process;
	
	cnt_process: PROCESS
	BEGIN
		for y in 0 to 480 loop
			for x in 0 to 640 loop
				address_horizon <= conv_std_logic_vector(y,9);
				x_s <= x;
				y_s <= y;
				wait for PERIOD;
			end loop;
		end loop;
	END PROCESS cnt_process;

END;
