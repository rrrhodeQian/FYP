----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:58:53 02/28/2022 
-- Design Name: 
-- Module Name:    cnd_buffer - rtl 
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

entity cnd_buffer is
port (
	clk: in std_logic;
	rst: in std_logic;
	cnd: in std_logic;				--control/data select
	ncs: in std_logic;				--chip select
	nwr: in std_logic;				--write control of the signal
	
	buffered_cnd: inout std_logic	--registed reflection of cnd signal
	);
end cnd_buffer;

architecture rtl of cnd_buffer is
signal int_buffered_cnd: std_logic;

begin

int_buffered_cnd <= cnd when (ncs = '0' and nwr ='0') else buffered_cnd;	--assign with cnd when ncs = 0 and nwr = 0

	process (clk, rst) begin
		if rst = '0' then
			buffered_cnd <= '0';
		elsif rising_edge (clk) then
			buffered_cnd <= int_buffered_cnd;
		end if;
	end process;



end rtl;

