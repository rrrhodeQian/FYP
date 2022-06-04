----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:35:02 04/12/2022 
-- Design Name: 
-- Module Name:    clk_div - rtl 
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_div is
	port (
		txclk: 		in std_logic;
		rst: 			in std_logic;
		clr_cnt: 	in std_logic;
		count_en: 	in std_logic;
		b1: 			in std_logic;
		b2: 			in std_logic;

		half_tc: 	out std_logic;
		tc: 			out std_logic
	);
end clk_div;

architecture rtl of clk_div is

	signal comp_one: 	std_logic_vector(6 downto 0) := "0000000"; 
	signal comp_half: std_logic_vector(6 downto 0) := "0000000"; 
	signal mux_cnt: 	std_logic_vector(6 downto 0) := "0000000";
	signal int_cnt:	std_logic_vector(6 downto 0) := "0000000";
	signal int_tc: 	std_logic;
	signal int_half: 	std_logic;

begin

	half_tc 	<= int_half and count_en;
	tc			<= int_tc   and count_en;

-------------------------------------------------
--define clock rate
-------------------------------------------------
	clock_rate: process (b1, b2)
	begin
		if (b2  = '0') then			--sync or divide-by-1
			comp_one  <= "0000000";
			comp_half <= "0000000";
		elsif (b1 = '1') then		--divide-by-64
			comp_one  <= "0111111";
			comp_half <= "0011111";
		else								--divide-by-16
			comp_one  <= "0001111";
			comp_half <= "0000111";
		end if;
	end process;
	
	process (b2, comp_one, comp_half, int_cnt)
	begin
		if (b2  = '0') or (int_cnt = comp_one) then
    		int_tc <= '1';
		else
    		int_tc <= '0';
		end if;
		
		if (b2  = '0') or (int_cnt = comp_half) then
    		int_half <= '1';
		else
    		int_half <= '0';
		end if;
	end process;
	
	process (clr_cnt, count_en, int_cnt)
	begin
		if (clr_cnt = '1') then
			mux_cnt <= (others => '0');
		elsif (count_en = '1') then
			mux_cnt	<= int_cnt + "1";
		else
			mux_cnt	<= int_cnt;
		end if;
	end process;


	sync_proc: process(rst, txclk)
	begin
		if (rst = '0') then
			int_cnt	<= (others => '0');
		elsif falling_edge (txclk) then
			int_cnt	<= mux_cnt;
		end if;
	end process;

end rtl;

