----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:37:28 03/14/2022 
-- Design Name: 
-- Module Name:    sync_char_reg - rtl 
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

entity sync_char_reg is
port (
	clk: 	in std_logic;
	rst:	in std_logic;
	ir: 	in std_logic;
	en: 	in std_logic;
	din: 	in std_logic_vector (7 downto 0);
	
	dout: out std_logic_vector (7 downto 0)
	);
end sync_char_reg;

architecture rtl of sync_char_reg is
signal mux_dout: std_logic_vector (7 downto 0);
signal int_dout: std_logic_vector (7 downto 0);

begin
process (ir, en, din, int_dout) begin
	if (ir = '0') then
		mux_dout <= (others => '0');
	elsif (en = '1') then
		mux_dout <= din;
	else
		mux_dout <= int_dout;
	end if;
end process;

process (clk, rst) begin
	if (rst = '0') then
		int_dout <= (others => '0');
	elsif rising_edge(clk) then
		int_dout <= mux_dout;
	end if;
end process;

dout <= int_dout;

end rtl;

