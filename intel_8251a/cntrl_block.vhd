----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:43:33 03/08/2022 
-- Design Name: 
-- Module Name:    cntrl_block - rtl 
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

entity cntrl_block is
port (
	rst: 					in std_logic;
	clk: 					in std_logic;
	nwr: 					in std_logic;
	nrd: 					in std_logic;
	cnd: 					in std_logic;
	ncs: 					in std_logic;
	mode_conf_done: 	in std_logic;		--mode configuration done signal from fsm
	ntxc:					in std_logic;
	nrxc:					in std_logic;
	
	rx_rst:				out std_logic;
	tx_rst:				out std_logic;
	cmd_mode_wr_en: 	out std_logic;		--write enable to interface with the fsm
	rx_read: 			out std_logic;
	sts_read: 			out std_logic;
	tx_buffer_nwr: 		out std_logic;		--enable to write to tx buffer
	cmd_reg_wr_en: 	out std_logic		--wrtie enable to interface cmd instr reg
	);
end cntrl_block;

architecture rtl of cntrl_block is

signal cnd_write_in: std_logic;	--wire that transmit synced cnd signal
signal shift_done_wire: std_logic;
signal nwr_write_in: std_logic;
		
	component cnd_buffer
		port (
			clk: in std_logic;
			rst: in std_logic;
			cnd: in std_logic;
			ncs: in std_logic;
			nwr: in std_logic;
			
			buffered_cnd: inout std_logic
		);
	end component;

	component wr_ext
		port (
			rst: in std_logic;
			nwr: in std_logic;
			ncs: in std_logic;
			shift_done: in std_logic;
			ext_nwr: inout std_logic
		);
	end component;
	
	component pre_proc
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
			rx_rst: 				out std_logic;
			tx_rst: 				out std_logic
			);
		end component;
	
begin
	
	i_cnd_buffer: cnd_buffer
		port map (
			clk => clk,
			rst => rst,
			cnd => cnd,
			nwr => nwr,
			ncs => ncs,
			buffered_cnd => cnd_write_in
		);
	
	i_wr_ext: wr_ext
		port map (
			rst => rst,
			nwr => nwr,
			ncs => ncs,
			shift_done => shift_done_wire,
			ext_nwr => nwr_write_in
		);
	
	i_pre_proc: pre_proc
		port map (
			clk => clk,
			rst => rst,
			txclk => ntxc,
			rxclk => nrxc,
			nwr => nwr,
			nrd => nrd,
			cnd => cnd,
			ncs => ncs,
			ext_nwr => nwr_write_in,
			ext_cnd => cnd_write_in,
			mode_conf_done => mode_conf_done,
			regs_wr_en => cmd_mode_wr_en,
			rx_read => rx_read,
			sts_read => sts_read,
			tx_buffer_nwr => tx_buffer_nwr,
			cmd_reg_wr_en => cmd_reg_wr_en,
			shift_done => shift_done_wire,
			rx_rst => rx_rst,
			tx_rst => tx_rst
		);

end rtl;

