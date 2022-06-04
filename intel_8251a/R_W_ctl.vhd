----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:45:13 02/17/2022 
-- Design Name: 
-- Module Name:    R_W_ctl - R_W_ctl 
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

entity R_W_ctl is
port (
	cnd: 					in std_logic;		--control/data select
	nrd: 					in std_logic;		--read control for the registers
	nwr: 					in std_logic;		--write control for the registers
	ncs: 					in std_logic;		--chip select
	clk: 					in std_logic;
	rst: 					in std_logic;
	nrxc: 				in std_logic;		--receive clock
	ntxc: 				in std_logic; 		--transmit clock
	din: 					in std_logic_vector (7 downto 0);		--parallel data input
	
	txen: 				out std_logic;		--transmitter enable
	ndtr: 				out std_logic;		--data_terminal ready
	rxen: 				out std_logic;		--receiver enable
	sbrk: 				out std_logic;		--send break character
	er:					out std_logic;		--error reset
	nrts:					out std_logic;		--request to send
	eh: 					out std_logic;		--enter hunt
	rx_read: 			out std_logic;		
	sts_read: 			out std_logic;
	tx_buffer_nwr: 		out std_logic;		--write enable for tx_buffer
	mode_conf_done: 	out std_logic;		--mode configuration done
	rx_rst:				out std_logic;
	tx_rst:				out std_logic;
	buffered_data:		out std_logic_vector (7 downto 0);
	mode_instr_out: 	out std_logic_vector (7 downto 0);	--mode instruction register output
	sync_char1:			out std_logic_vector (7 downto 0);
	sync_char2: 		out std_logic_vector (7 downto 0)
	);
end R_W_ctl;

architecture R_W_ctl of R_W_ctl is

signal data_write_in:		std_logic_vector (7 downto 0);
signal op_wire: 				std_logic;	--wire that transmit operation mode signal
signal MIR_dout: 				std_logic_vector (7 downto 0);	--signal that transmit mode instruction reg's dout
signal conf_done: 			std_logic; 	--wire that transmit mode configuration done signal
signal sync1_en:				std_logic;
signal sync2_en:				std_logic;
signal MIR_en:					std_logic;
signal int_esd:				std_logic;
signal int_scs:				std_logic;
signal ir_wire: 				std_logic;	--wire that transmit internal state rst signal
signal fsm_wr_en: 			std_logic;	--wire that transmit mode instruction reg write enable signal
signal cmd_write:				std_logic;	--wire that transmit write enable signal for cmd instr reg

-------------------------------------------------
--component declarations
-------------------------------------------------
	
	component data_buffer
		port (
			clk: in std_logic;
			rst: in std_logic;
			nwr: in std_logic;
			ncs: in std_logic;
			din: in std_logic_vector (7 downto 0);
		
			buffered_din: inout std_logic_vector (7 downto 0)
		);
	end component;
	
	component mode_instr_reg
		port (
			clk: 						in std_logic;
			rst: 						in std_logic;
			ir: 						in std_logic;
			wr_en: 					in std_logic;
			din: 						in std_logic_vector (7 downto 0);
			op_mode: 				out std_logic;
			dout: 					out std_logic_vector (7 downto 0)
		);
	end component;
	
	component mode_sel_fsm
		port (
			clk: 					in std_logic;
			rst: 					in std_logic;
			ir: 					in std_logic;
			wr_en: 				in std_logic;
			esd: 					in std_logic;
			scs: 					in std_logic;
			op_mode: 			in std_logic;
			mode_conf_done:	out std_logic;
			sync_char1_en: 	out std_logic;
			sync_char2_en: 	out std_logic;
			wr_MIR_en: 			out std_logic
		);
	end component;
	
	component cmd_instr_reg
		port (
			clk: 					in std_logic;
			rxclk: 				in std_logic;
			rst: 					in std_logic;
			int_state_rst: 	in std_logic;
			wr_en: 				in std_logic;
			din: 					in std_logic_vector (7 downto 0);
			txen: 				out std_logic;
			ndtr: 				out std_logic;
			rxen: 				out std_logic;
			sbrk: 				out std_logic;
			er: 					out std_logic;
			nrts: 				out std_logic;
			ir: 					out std_logic;
			eh: 					out std_logic
		);
	end component;
	
	component cntrl_block
		port (
			rst: 					in std_logic;
			clk: 					in std_logic;
			nwr: 					in std_logic;
			nrd: 					in std_logic;
			cnd: 					in std_logic;
			ncs: 					in std_logic;
			mode_conf_done: 	in std_logic;
			ntxc:					in std_logic;
			nrxc:					in std_logic;
			rx_rst:				out std_logic;
			tx_rst:				out std_logic;
			cmd_mode_wr_en: 	out std_logic;
			rx_read: 			out std_logic;
			sts_read: 			out std_logic;
			tx_buffer_nwr: 	out std_logic;
			cmd_reg_wr_en: 	out std_logic
		);
	end component;
	
	component sync_char_reg
		port (
			clk: 	in std_logic;
			rst:	in std_logic;
			ir: 	in std_logic;
			en: 	in std_logic;
			din: 	in std_logic_vector (7 downto 0);
			dout: out std_logic_vector (7 downto 0)
		);
	end component;


begin
-------------------------------------------------
--continuous assignments
-------------------------------------------------
int_esd <= MIR_dout (6);
int_scs <= MIR_dout (7);
mode_conf_done <= conf_done;
mode_instr_out <= MIR_dout;
buffered_data <= data_write_in;

-------------------------------------------------
--component instantiations
-------------------------------------------------
	
	i_data_buffer: data_buffer
		port map (
			clk => clk,
			rst => rst,
			nwr => nwr,
			ncs => ncs,
			din => din,
			buffered_din => data_write_in
		);
	
	i_mode_instr_reg: mode_instr_reg
		port map (
			clk => clk,
			rst => rst,
			ir => ir_wire,
			wr_en => MIR_en,
			din => data_write_in,
			op_mode => op_wire,
			dout => MIR_dout
		);
		
	i_mode_sel_fsm: mode_sel_fsm
		port map (
			clk => clk,
			rst => rst,
			ir => ir_wire,
			wr_en => fsm_wr_en,
			esd => int_esd,
			scs => int_scs,
			op_mode => op_wire,
			mode_conf_done => conf_done,
			sync_char1_en => sync1_en,
			sync_char2_en => sync2_en,
			wr_MIR_en => MIR_en
		);
	
	i_cmd_instr_reg: cmd_instr_reg
		port map (
			clk => clk,
			rxclk => nrxc,
			rst => rst,
			int_state_rst => ir_wire,
			wr_en => cmd_write,
			din => data_write_in,
			txen => txen,
			ndtr => ndtr,
			rxen => rxen,
			sbrk => sbrk,
			er => er,
			nrts => nrts,
			ir => ir_wire,
			eh => eh 
		);

	
	i_cntrl_block: cntrl_block
		port map (
			rst => rst,
			clk => clk,
			nwr => nwr,
			nrd => nrd,
			cnd => cnd,
			ncs => ncs,
			nrxc => nrxc,
			ntxc => ntxc,
			mode_conf_done => conf_done,
			rx_read => rx_read,
			sts_read => sts_read,
			tx_buffer_nwr => tx_buffer_nwr,
			cmd_mode_wr_en => fsm_wr_en,
			cmd_reg_wr_en => cmd_write,
			tx_rst => tx_rst,
			rx_rst => rx_rst
		);	
	
	i_sync_char_reg1: sync_char_reg
		port map (
			clk => clk,
			rst => rst,
			ir => ir_wire,
			en => sync1_en,
			din => data_write_in,
			dout => sync_char1
		);
	
	i_sync_char_reg2: sync_char_reg
		port map (
			clk => clk,
			rst => rst,
			ir => ir_wire,
			en => sync2_en,
			din => data_write_in,
			dout => sync_char2
		);

end R_W_ctl;

