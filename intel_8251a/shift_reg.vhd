----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:12:11 04/03/2022 
-- Design Name: 
-- Module Name:    shift_reg - rtl 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift_reg is
	port (
		data		: in std_logic_vector (7 downto 0);
		shift_en	: in std_logic;
		load_en	: in std_logic;
		txclk		: in std_logic;
		rst		: in std_logic;
		tx_rst	: in std_logic;
		
		shift_reg_out	: out std_logic
		);
end shift_reg;

architecture rtl of shift_reg is

	signal next_data	: std_logic_vector (7 downto 0);
	signal int_data	: std_logic_vector (7 downto 0);

begin

	process (tx_rst, shift_en, load_en, data, int_data) begin
		if tx_rst = '0' then
			next_data <= (others => '0');
		elsif load_en = '1' then
			next_data <= data;
		elsif shift_en ='1' then
			next_data <= '0' & int_data (7 downto 1);
		else
			next_data <= int_data;
		end if;
	end process;
		
	process (txclk, rst) begin
		if rst = '0' then
			int_data <= (others => '0');
		elsif falling_edge (txclk) then
			int_data <= next_data;
		end if;
	end process;

	shift_reg_out <= int_data(0);

end rtl;

