----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:23:02 02/16/2022 
-- Design Name: 
-- Module Name:    top - top 
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

entity top is
port (
	clk			: in std_logic;
	rst			: in std_logic;
	cnd			: in std_logic;		--control/data select from microprocessor
	din			: in std_logic_vector (7 downto 0);		--parallel data input from microprocessor
	extsyncd		: in std_logic;		--external sync detect
	ncs			: in std_logic;		--chip select from microprocessor
	ncts			: in std_logic;		--clear to send; modem signal
	ndsr			: in std_logic;		--data set ready; modem signal
	nrd			: in std_logic;		--read control for the registers
	nrxc			: in std_logic;		--receive clock
	ntxc			: in std_logic;		--transmit clock
	nwr			: in std_logic;		--write control for the registers
	rxd			: in std_logic;		--receive data

	dout			: out std_logic_vector	(7 downto 0);	--parallel data output to microprocessor
	ndtr			: out std_logic;		--data terminal ready; modem signal
	nen			: out std_logic;		--output enable for the output data bus
	nrts			: out std_logic;		--request to send; modem signal
	rxrdy			: out std_logic;		--receiver ready
	syn_brk		: out std_logic;		--sync/break detect
	txd			: out std_logic;		--transmit data
	txempty		: out std_logic; 		--transmitter empty
	txrdy			: out std_logic		--transmitter ready
	);
end top;

architecture top of top is
	
	signal sbrk			: std_logic;
	signal txen			: std_logic;
	signal data_wrtin	: std_logic_vector (7 downto 0);
	signal tb_nwr		: std_logic;
	signal tx_rst		: std_logic;
	signal mode_out	: std_logic_vector (7 downto 0);
	signal sync1		: std_logic_vector (7 downto 0);
	signal sync2		: std_logic_vector (7 downto 0);
	signal ffrdy		: std_logic;
	signal sr_empty_n	: std_logic;
	signal b1			: std_logic;
	signal b2  			: std_logic;
	signal l1			: std_logic;
	signal l2			: std_logic;
	signal parity_en	: std_logic;
	signal even_parity: std_logic;
	signal s1			: std_logic;
	signal s2			: std_logic;
	signal rxen			: std_logic;
	signal er			: std_logic;
	signal rx_read		: std_logic;
	signal sts_read	: std_logic;
	signal mode_conf_done: std_logic;
	signal rx_rst		: std_logic;
	signal eh			: std_logic;

--------------------------------------------------------------------------------------
--component declarations
--------------------------------------------------------------------------------------

	component R_W_ctl
		port (
			cnd: 					in std_logic;
			nrd: 					in std_logic;
			nwr: 					in std_logic;
			ncs: 					in std_logic;
			clk: 					in std_logic;
			rst: 					in std_logic;
			nrxc: 				in std_logic;
			ntxc: 				in std_logic;
			din: 					in std_logic_vector (7 downto 0);
			
			txen: 				out std_logic;
			ndtr: 				out std_logic;
			rxen: 				out std_logic;
			sbrk: 				out std_logic;
			er:					out std_logic;
			nrts:					out std_logic;
			eh: 					out std_logic;
			rx_read: 			out std_logic;		
			sts_read: 			out std_logic;
			tx_buffer_nwr: 	out std_logic;
			mode_conf_done: 	out std_logic;
			rx_rst:				out std_logic;
			tx_rst:				out std_logic;
			buffered_data:		out std_logic_vector (7 downto 0);
			mode_instr_out: 	out std_logic_vector (7 downto 0);
			sync_char1:			out std_logic_vector (7 downto 0);
			sync_char2: 		out std_logic_vector (7 downto 0)
			);
	end component;
	
	component tx
		port (
			b1				: in std_logic;
			b2				: in std_logic;
			l1				: in std_logic;
			l2				: in std_logic;
			pen			: in std_logic;
			ep				: in std_logic;
			s1				: in std_logic;
			s2				: in std_logic;
			sbrk			: in std_logic;
			rst			: in std_logic;
			txclk			: in std_logic;
			tx_rst		: in std_logic;
			txen			: in std_logic;
			tx_buffer_nwr	: in std_logic;
			ncts			: in std_logic;
			sync_char1	: in std_logic_vector (7 downto 0);
			sync_char2	: in std_logic_vector (7 downto 0);
			din			: in std_logic_vector (7 downto 0);
			
			tx_data			: out std_logic;
			tx_ffrdy			: out std_logic;
			tx_sr_empty_n	: out std_logic
			);
	end component;
	
	component cntrlop_gen
		port (
			tx_ffrdy			: in std_logic;
			ncts				: in std_logic;
			txen				: in std_logic;
			tx_sr_empty_n	: in std_logic;
			
			txempty			: out std_logic;
			txrdy				: out std_logic
			);
	end component;

begin

	b1					<= mode_out(0);
	b2  				<= mode_out(1);
	l1					<= mode_out(2);
	l2					<= mode_out(3);
	parity_en		<= mode_out(4);
	even_parity		<= mode_out(5);
	s1					<= mode_out(6);
	s2					<= mode_out(7);
--------------------------------------------------------------------------------------
--component instantiations
--------------------------------------------------------------------------------------
	i_R_W_ctl: R_W_ctl
		port map (
			cnd => cnd,
			nrd => nrd,
			nwr => nwr,
			ncs => ncs,
			clk => clk,
			rst => rst,
			nrxc => nrxc,
			ntxc => ntxc,
			din => din,
			txen => txen,
			ndtr => ndtr,
			rxen => rxen,
			sbrk => sbrk,
			er => er,
			nrts => nrts,
			eh => eh,
			rx_read => rx_read,
			sts_read => sts_read,
			tx_buffer_nwr => tb_nwr,
			mode_conf_done => mode_conf_done,
			rx_rst => rx_rst,
			tx_rst => tx_rst,
			buffered_data => data_wrtin,
			mode_instr_out => mode_out,
			sync_char1 => sync1,
			sync_char2 => sync2
			);
	
	i_tx: tx
		port map (
			b1 => b1,
			b2 => b2,
			l1 => l1,
			l2 => l2,
			pen => parity_en,
			ep => even_parity,
			s1 => s1,
			s2 => s2,
			sbrk => sbrk,
			rst => rst,
			txclk => ntxc,
			tx_rst => tx_rst,
			txen => txen,
			tx_buffer_nwr => tb_nwr,
			ncts => ncts,
			sync_char1 => sync1,
			sync_char2 => sync2,
			din => data_wrtin,
			tx_data => txd,
			tx_ffrdy => ffrdy,
			tx_sr_empty_n => sr_empty_n
			);
	
	i_cntrlop_gen: cntrlop_gen
		port map (
			tx_ffrdy => ffrdy,
			ncts => ncts,
			txen => txen,
			tx_sr_empty_n => sr_empty_n,
			txempty => txempty,
			txrdy => txrdy
			);
	
end top;

