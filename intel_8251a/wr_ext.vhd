----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:55:14 03/10/2022 
-- Design Name: 
-- Module Name:    wr_ext - rtl 
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

entity wr_ext is
port (
	rst: 			in std_logic;
	ncs: 			in std_logic;
	nwr: 			in std_logic;
	shift_done: in std_logic;		--signal to indicate shift operation is done
	
	ext_nwr: 	inout std_logic	--extended nwr
	);
end wr_ext;

architecture rtl of wr_ext is

begin
process (rst, nwr, ncs, shift_done) begin
	if (rst = '0') or (shift_done = '1') then
		ext_nwr <= '1';
	elsif rising_edge(nwr) then
		if (ncs = '0') or (ext_nwr = '0') then
			ext_nwr <= '0';
		else
			ext_nwr <= '1';
		end if;
	end if;
end process;

end rtl;

