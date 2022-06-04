----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:25:06 04/14/2022 
-- Design Name: 
-- Module Name:    data_cnt - rtl 
-- Project Name: 
-- Target Devicount_ens: 
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_cnt is
	port 
	(
		rst: 			in std_logic;
		txclk: 		in std_logic;
		clr_cnt: 	in std_logic;
		count_en: 	in std_logic;
		l1: 			in std_logic;
		l2: 			in std_logic;

		data_tc: 	out std_logic
	);
end data_cnt;

architecture rtl of data_cnt is

	signal bit_num: 		std_logic_vector(2 downto 0) := "000"; 
	signal next_bit_cnt: std_logic_vector(2 downto 0) := "000";
	signal bit_cnt: 		std_logic_vector(2 downto 0) := "000";


begin

	bit_num	<= "1" & l2 & l1;

	process (bit_cnt, rst, bit_num)
	begin
		if (rst = '0') then
			data_tc <= '0';
		elsif (bit_cnt = bit_num) then
			data_tc <= '1';
		else
			data_tc <= '0';
		end if;
	end process;

	process (clr_cnt, rst, count_en, bit_cnt)
	begin
		if (clr_cnt = '1') or (rst = '0') then
			next_bit_cnt <= "000";
		elsif  (count_en = '1') then
			next_bit_cnt <= bit_cnt + "1";
		else
			next_bit_cnt <= bit_cnt;
		end if;
	end process;

	process (rst, txclk)
	begin
  		if (rst = '0') then
			bit_cnt <= (others => '0');
		elsif falling_edge (txclk) then
			bit_cnt <= next_bit_cnt;
		end if;
	end process;

end rtl;

