----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:36:57 12/26/2013 
-- Design Name: 
-- Module Name:    Rand - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rand is
    Port ( clk : in  STD_LOGIC;
           random_num : out integer range 192 to 447
			 );
end rand;

architecture Behavioral of rand is
begin

process(clk)
	variable rand_temp : std_logic_vector(7 downto 0):="10000000";
	variable temp : std_logic := '0';
	variable x : integer range 192 to 447 := 192;
begin
	if (rising_edge(clk)) then
		temp := rand_temp(7) xor rand_temp(6);
		rand_temp(7 downto 1) := rand_temp(6 downto 0);
		rand_temp(0) := temp;

		x := (192 + (conv_integer(rand_temp)));
		
		random_num <= x;
	end if;
end process;


end Behavioral;

