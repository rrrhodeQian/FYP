----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:55:28 02/28/2022 
-- Design Name: 
-- Module Name:    data_buffer - rtl 
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

entity data_buffer is
port (
	clk: 				in std_logic;
	rst: 				in std_logic;
	nwr: 				in std_logic;								--write control
	ncs: 				in std_logic;								--chip select
	din: 				in std_logic_vector (7 downto 0);	--data in
	
	buffered_din: 	inout std_logic_vector (7 downto 0)
	);
end data_buffer;

architecture rtl of data_buffer is

signal int_buffered_din: std_logic_vector (7 downto 0);		--internal signal for buffered data

begin
-------------------------------------------------
--continuous assignments
-------------------------------------------------
int_buffered_din <= din when (ncs = '0' and nwr = '0') else buffered_din;	--assign with din when ncs = 0 and nwr = 0

-------------------------------------------------
--output register
-------------------------------------------------
	process (clk, rst)
	begin
		if (rst = '0') then
			buffered_din <= (others => '0');
		elsif rising_edge(clk) then
			buffered_din <= int_buffered_din;
		end if;
	end process;


end rtl;
