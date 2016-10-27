----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:53:55 10/16/2012 
-- Design Name: 
-- Module Name:    PS2_basys2 - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PS2_basys2 is
    Port ( PS2C 		: in  STD_LOGIC;
           PS2D 		: in  STD_LOGIC;
			  direction	: out STD_LOGIC;
			  shoot		: out STD_LOGIC;
			  rst 		: out STD_LOGIC
			);
end PS2_basys2;

architecture Behavioral of PS2_basys2 is
	signal data_driver	: std_logic_vector (10 downto 0) := "00000000000";
	signal count 			: integer range 0 to 10	:= 0;
begin

process (PS2C) begin
	if (falling_edge (PS2C)) then
		count <= count + 1;
		data_driver(count) <= PS2D;
		
		if (count = 10) then
			count <= 0;
			case(data_driver(8 downto 1)) is
				when "01101011" => 
					direction <= '0';
					shoot <= '0';
					rst <= '0';
				when "01110100" => 
					direction <= '1';
				when "01110101" => 
					shoot <= '1';
					rst <= '0';
				when "00010001" => 
					rst <= '1';
					shoot <= '0';
				when others =>
					shoot <= '0';
					rst <= '0';
			end case;
		end if;
	end if;
end process;


end Behavioral;

