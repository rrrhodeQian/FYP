----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:29:56 02/24/2022 
-- Design Name: 
-- Module Name:    mode_instr_reg - mode_instr_reg 
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

entity mode_instr_reg is
port (
	clk: 						in std_logic;
	rst: 						in std_logic;
	ir: 						in std_logic;								--internal state reset signal
	wr_en: 					in std_logic;								--write enable for mode register
	din: 						in std_logic_vector (7 downto 0);	--data_in
	
	op_mode: 				out std_logic; 							--indication of sync or async mode
	dout: 					out std_logic_vector (7 downto 0)	--data out of instruction info to tx and rx
	);
end mode_instr_reg;

architecture rtl of mode_instr_reg is

signal mux_dout: std_logic_vector (7 downto 0);		--dout for different conditions
signal int_dout: std_logic_vector (7 downto 0);		--internal dout

begin
-------------------------------------------------
--continuous assignments
-------------------------------------------------
dout <= int_dout;
op_mode <= '1' when int_dout(1 downto 0) = "00" else '0';			--sync mode when Bit 0 and Bit 1 of reg are both 0

-------------------------------------------------
--combinatinal process that select mux_dout
-------------------------------------------------
process (ir, wr_en, din, int_dout)			
	begin
		if (ir = '0') then							--internal state reset is asserted
			mux_dout <= (others => '0');			--reset mux_dout
		elsif (wr_en = '1') then					--enable write to the register
			mux_dout <= din;
		else
			mux_dout <= int_dout;					--remain unchanged
		end if;
end process;

process (clk, rst)
	begin
		if (rst = '0') then
			int_dout <= (others => '0');
		elsif rising_edge(clk) then				--rising edge
			int_dout <= mux_dout;					--output mux_dout
		end if;
end process;

end rtl;

