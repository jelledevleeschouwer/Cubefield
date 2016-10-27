--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package cube_pkg is

subtype h_c is integer range 0 to 640;
subtype v_c is integer range 270 to 480;
subtype s_t is integer range 10 to 100;
subtype rf_t is integer range 0 to 25;
subtype t_t is integer range 0 to 2;

type blok is
	record
		x : h_c;
		y : v_c;
		s : s_t;
		en : std_logic;
		rf : rf_t;
		inc: rf_t;
		t	: std_logic;
	end record;

type blok_s is
	record
		x : h_c;
		y : v_c;
		s : s_t;
		en : std_logic;
		t	: std_logic;
	end record;

type shot is
	record
		x : h_c;
		y : v_c;
		en : std_logic;
	end record;

-- CUSTOM SUBTYPES
subtype test is integer range 0 to 640;
-- CUSTOM TYPES
type T_2D is array (natural range <>) of blok;
type T_2D2 is array (natural range <>) of blok_s;
-- FUNCTIONS
function move(block_input: blok; new_x: integer range 192 to 447; shot: std_logic; x: h_c) return blok;
function reset(new_x: integer range 192 to 447) return blok;
function shadow(block_input: blok) return blok_s;
function inBlockArray(h_cnt: integer range 0 to 640; v_cnt: integer range 0 to 480; block_array: T_2D) return t_t;
function inShadowArray(h_cnt: integer range 0 to 640; v_cnt: integer range 0 to 480; block_array: T_2D2) return t_t;

end cube_pkg;

package body cube_pkg is

function move(block_input: blok; new_x: integer range 192 to 447; shot: std_logic; x: h_c) return blok is
	variable block_in: blok;
begin
	block_in := block_input;
	
	if (block_input.en = '1') then -- IF BLOCK = enabled
		if (block_input.y >= 480) then
			block_in := reset(new_x);
		else
			block_in.rf := block_input.rf + 1; -- INCREMENT refresh_cnt
		
			if (block_input.rf = 25) then
				block_in.inc := block_input.inc + 1; -- INCREMENT EFFECT
				block_in.rf := 0; -- RESET vertical refresh_cnt
			end if;
			
			block_in.y := block_in.y + block_in.inc; -- UPDATE vertical position
			
			if (block_input.rf = 5)
			or (block_input.rf = 10)
			or (block_input.rf = 15)
			or (block_input.rf = 20)
			or (block_input.rf = 25)
			then
				block_in.s := block_input.s + 2; -- UPDATE size
				if (block_input.x > 330) then
					block_in.x := block_input.x + 4; -- UPDATE horizontal position
				elsif (block_input.x < 310) then
					block_in.x := block_input.x - 4; -- UPDATE horizontal position
				end if;
			end if;
			
			if (x > block_input.x) and (x < block_input.x + block_input.s) and (shot = '1') then
				block_in.t := '1';
			end if;
		end if;
	end if;
		
	return block_in; 
end move;

function reset(new_x: integer range 192 to 447) return blok is
	variable block_in: blok;
begin
	block_in.x 		:= new_x;  	 -- x
	block_in.y 		:= 270;		 -- y
	block_in.s 		:= 10;		 -- s
	return block_in;
end reset;

function shadow(block_input: blok) return blok_s is
	variable block_in: blok_s;
begin
	block_in.x := block_input.x + 1;
	block_in.y := block_input.y - 1;
	block_in.s := block_input.s - 2;
	block_in.en := block_input.en;
	block_in.t := block_input.t;
	
	return block_in;
end shadow;

function inBlockArray(h_cnt: integer range 0 to 640; v_cnt: integer range 0 to 480; block_array: T_2D) return t_t is
	variable isIn: integer range 0 to 2 := 0;
begin
	for i in 0 to 5 loop
		if ((h_cnt >=  block_array(i).x) and (h_cnt <= (block_array(i).x + block_array(i).s)) and (v_cnt > block_array(i).y) and (v_cnt <= (block_array(i).y + block_array(i).s)) and (block_array(i).en = '1')) then
			if (block_array(i).t = '1') then
				isIn := 2;
			else
				isIn := 1;
			end if;
		end if;
	end loop;
	
	return isIn;
end inBlockArray;

function inShadowArray(h_cnt: integer range 0 to 640; v_cnt: integer range 0 to 480; block_array: T_2D2) return t_t is
	variable isIn: integer range 0 to 2 := 0;
begin
	for i in 0 to 5 loop
		if ((h_cnt >=  block_array(i).x) and (h_cnt <= (block_array(i).x + block_array(i).s)) and (v_cnt > block_array(i).y) and (v_cnt <= (block_array(i).y + block_array(i).s)) and (block_array(i).en = '1')) then
			if (block_array(i).t = '1') then
				isIn := 2;
			else
				isIn := 1;
			end if;
		end if;
	end loop;
	
	return isIn;
end inShadowArray;

end cube_pkg;
