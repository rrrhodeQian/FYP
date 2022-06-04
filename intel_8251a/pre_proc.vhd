----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:26:40 03/12/2022 
-- Design Name: 
-- Module Name:    pre_proc - rtl 
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

entity pre_proc is
port (
	clk: 					in std_logic;
	rst: 					in std_logic;
	txclk: 				in std_logic;
	rxclk: 				in std_logic;
	nwr: 					in std_logic;
	nrd: 					in std_logic;
	cnd: 					in std_logic;
	ncs: 					in std_logic;
	ext_nwr: 			in std_logic;
	ext_cnd: 			in std_logic;
	mode_conf_done: 	in std_logic;
	
	regs_wr_en: 		out std_logic;
	rx_read: 			out std_logic;		
	sts_read: 			out std_logic;
	tx_buffer_nwr: 		out std_logic;
	cmd_reg_wr_en: 	out std_logic;
	shift_done: 		out std_logic;
	rx_rst: 				out std_logic;		--rx reset
	tx_rst: 				out std_logic		--tx reset
	);
end pre_proc;

architecture rtl of pre_proc is
signal int_regs_wr_en:		std_logic;
signal regs_wr_en0:			std_logic;
signal regs_wr_en1:			std_logic;
signal regs_wr_en2: 			std_logic;
signal int_cmd_reg_wr_en:	std_logic;
signal cmd_reg_wr_en0:		std_logic;
signal cmd_reg_wr_en1:		std_logic;
signal cmd_reg_wr_en2:		std_logic;
signal int_tx_buffer_nwr:		std_logic;

begin
--rx_rst 	<= int_rx_rst;
--tx_rst 	<= int_tx_rst;

-------------------------------------------------
--process for rx reset and tx reset signal
-------------------------------------------------
process (rst, rxclk, mode_conf_done) begin
	if (rst = '0') or (mode_conf_done = '0') then
		rx_rst <= '0';
	elsif rising_edge (rxclk) then
		rx_rst <= '1';
	end if;
end process;

process (rst, txclk, mode_conf_done) begin
	if (rst = '0') or (mode_conf_done = '0') then
		tx_rst <= '0';
	elsif rising_edge (txclk) then
		tx_rst <= '1';
	end if;
end process;

-------------------------------------------------
--process that generates write enable signal
--for fsm
-------------------------------------------------
process (ext_cnd, ext_nwr) begin
	if (ext_nwr = '0' and ext_cnd = '1') then
		regs_wr_en0 <= '1';
	else
		regs_wr_en0 <= '0';
	end if;
end process;

process (cnd, ncs, nwr, nrd, ext_cnd, ext_nwr, mode_conf_done) begin
	if (mode_conf_done = '1' and ext_cnd = '1' and ext_nwr = '0') then
		cmd_reg_wr_en0 <= '1';
	else
		cmd_reg_wr_en0 <= '0';
	end if;
	
	if (mode_conf_done = '1' and cnd = '0' and nrd = '0' and nwr = '1' and ncs = '0') then
		rx_read <= '1';
	else
		rx_read <= '0';
	end if;
	
	if (mode_conf_done = '1' and cnd = '1' and nrd = '0' and nwr = '1' and ncs = '0') then
		sts_read <= '1';
	else
		sts_read <= '0';
	end if;
	
	if (mode_conf_done = '1' and cnd = '0' and nrd = '1' and nwr = '0' and ncs = '0') then
		int_tx_buffer_nwr <= '0';
	else
		int_tx_buffer_nwr <= '1';
	end if;
end process;

-------------------------------------------------
--process to sync output
-------------------------------------------------
process (rst, clk) begin
	if (rst = '0') then
		regs_wr_en1 <= '0';
		regs_wr_en2 <= '0';
		cmd_reg_wr_en1 <= '0';
		cmd_reg_wr_en2 <= '0';
	elsif rising_edge (clk) then
		regs_wr_en1 <= regs_wr_en0;
		regs_wr_en2 <= regs_wr_en1;
		cmd_reg_wr_en1 <= cmd_reg_wr_en0;
		cmd_reg_wr_en2 <= cmd_reg_wr_en1;
	end if;
end process;

int_regs_wr_en <= regs_wr_en1 and regs_wr_en2;
regs_wr_en <= int_regs_wr_en;

int_cmd_reg_wr_en <= cmd_reg_wr_en1 and cmd_reg_wr_en2;
cmd_reg_wr_en <= int_cmd_reg_wr_en;

tx_buffer_nwr <= int_tx_buffer_nwr;

shift_done <= int_regs_wr_en or not int_tx_buffer_nwr or int_cmd_reg_wr_en;

end rtl;

