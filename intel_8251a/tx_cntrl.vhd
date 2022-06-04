----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:37:45 04/15/2022 
-- Design Name: 
-- Module Name:    tx_cntrl - rtl 
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

entity tx_cntrl is
	port (
		b1				: in std_logic;
		b2				: in std_logic;
		l1				: in std_logic;
		l2				: in std_logic;
		pen			: in std_logic;
		s1				: in std_logic;
		s2				: in std_logic;
		txclk			: in std_logic;
		cts			: in std_logic;
		txen			: in std_logic;
		data_rdy		: in std_logic;
		rst			: in std_logic;
		tx_rst		: in std_logic;
		
		shift_en		: out std_logic;
		load_en		: out std_logic;
		buffer_nrd		: out std_logic;
		sr_empty_n	: out std_logic;
		line_mux_sel: out std_logic_vector (1 downto 0);
		load_sel		: out std_logic_vector (1 downto 0)
		);
end tx_cntrl;

architecture rtl of tx_cntrl is

	signal half_tc_line	: std_logic;
	signal tc_line			: std_logic;
	signal data_tc_line	: std_logic;
	signal div_cnt_clr	: std_logic;
	signal div_cnt_en		: std_logic;
	signal data_cnt_clr	: std_logic;
	signal data_cnt_en	: std_logic;
	
	
	component clk_div
		port (
			txclk: 		in std_logic;
			rst: 			in std_logic;
			clr_cnt: 	in std_logic;
			count_en: 	in std_logic;
			b1: 			in std_logic;
			b2: 			in std_logic;
			half_tc: 	out std_logic;
			tc: 			out std_logic
		);
	end component;
	
	component data_cnt
		port (
			rst: 			in std_logic;
			txclk: 		in std_logic;
			clr_cnt: 	in std_logic;
			count_en: 	in std_logic;
			l1: 			in std_logic;
			l2: 			in std_logic;
			data_tc: 	out std_logic
		);
	end component;
	
	component cntrl_fsm
		port (
			rst:				in  std_logic;
			txclk: 			in  std_logic;
			tx_rst: 			in  std_logic;
			data_tc: 		in  std_logic;
			b1: 				in  std_logic;
			b2: 				in  std_logic;
			tc: 				in  std_logic;
			half_tc: 		in  std_logic;
			txen: 			in  std_logic;
			data_rdy: 		in  std_logic;
			cts: 				in  std_logic;
			parity_en: 		in  std_logic;
			s1: 				in  std_logic;
			s2: 				in  std_logic;

			data_cnt_en: 	out std_logic;
			data_cnt_clr: 	out std_logic;
			sr_empty_n: 	out std_logic;
			buffer_nrd: 		out std_logic;
			div_cnt_en: 	out std_logic;
			div_cnt_clr: 	out std_logic;
			shift_en: 		out std_logic;
			load_en: 		out std_logic;
			load_sel: 		out std_logic_vector(1 downto 0);
			line_mux_sel: 	out std_logic_vector(1 downto 0)
			);
	end component;

begin
	
	i_clk_div: clk_div
	port map (
		txclk => txclk,
		rst => rst,
		clr_cnt => div_cnt_clr,
		count_en => div_cnt_en,
		b1 => b1,
		b2 => b2,
		half_tc => half_tc_line,
		tc => tc_line
		);
		
	i_data_cnt: data_cnt
	port map (
		rst => rst,
		txclk => txclk,
		clr_cnt => data_cnt_clr,
		count_en => data_cnt_en,
		l1 => l1,
		l2 => l2,
		data_tc => data_tc_line
		);
	
	i_cntrl_fsm: cntrl_fsm
	port map (
		rst => rst,
		txclk => txclk,
		tx_rst => tx_rst,
		data_tc => data_tc_line,
		b1 => b1,
		b2 => b2,
		tc => tc_line,
		half_tc => half_tc_line,
		txen => txen,
		data_rdy => data_rdy,
		cts => cts,
		parity_en => pen,
		s1 => s1,
		s2 => s2,
		data_cnt_en => data_cnt_en,
		data_cnt_clr => data_cnt_clr,
		sr_empty_n => sr_empty_n,
		buffer_nrd => buffer_nrd,
		div_cnt_en => div_cnt_en,
		div_cnt_clr => div_cnt_clr,
		shift_en => shift_en,
		load_en => load_en,
		load_sel => load_sel,
		line_mux_sel => line_mux_sel
		);
		
end rtl;

