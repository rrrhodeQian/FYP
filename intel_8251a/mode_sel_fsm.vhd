----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:07:48 02/26/2022 
-- Design Name: 
-- Module Name:    mode_sel_fsm - mode_sel_fsm 
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

entity mode_sel_fsm is
port (
	clk: 					in std_logic;
	rst: 					in std_logic;				--async total state reset
	ir: 					in std_logic;				--internal state reset signal
	wr_en: 				in std_logic;				--write enable
	esd: 					in std_logic;				--external sync detect
	scs: 					in std_logic;				--single character sync
	op_mode: 			in std_logic;				--operation mode: sync/async
	
	mode_conf_done:	out std_logic;				--configuration of sync/async mode operation is done
	sync_char1_en: 	out std_logic;				--sync character one enable
	sync_char2_en: 	out std_logic;				--sync character two enable
	wr_MIR_en: 			out std_logic				--write to MIR enable
	);
end mode_sel_fsm;

architecture mode_sel_fsm of mode_sel_fsm is

type conf_state is (idle, mode, sync1, sync2, wait_rst);

signal state: 				conf_state;
signal next_state: 		conf_state;
signal sync_char1_gate: std_logic;	--AND gate input for sync_char1_en
signal sync_char2_gate: std_logic;	--AND gate input for sync_char2_en
signal wr_MIR_gate: 		std_logic;	--AND gate input for wr_MIR_en

begin
-------------------------------------------------
--continuous assignments
-------------------------------------------------
sync_char1_en <= wr_en and sync_char1_gate;
sync_char2_en <= wr_en and sync_char2_gate;
wr_MIR_en <= wr_en and wr_MIR_gate;

-------------------------------------------------
--register for state
-------------------------------------------------
process (clk, rst, ir) begin				
	if (rst = '0') or (ir = '0')then
		state <= idle;
	elsif rising_edge(clk) then
		state <= next_state;
	end if;
end process;

-------------------------------------------------
--state transition
-------------------------------------------------
process (state, wr_en, op_mode, esd, scs) begin
	case state is
		when idle =>
			if (wr_en = '1') then
				next_state <= mode;
			else
				next_state <= idle;
			end if;
		when mode =>
			if (op_mode = '1') and (esd = '0') then		--if it's sync mode and no external sync detected
				next_state <= sync1;
			else
				next_state <= wait_rst;
			end if;
		when sync1 =>
			if (scs = '0') then									--if it's single character sync
				if (wr_en = '1') then
					next_state <= sync2;
				else
					next_state <= sync1;
				end if;
			else
				if (wr_en = '1') then
					next_state <= wait_rst;
				else
					next_state <= sync1;
				end if;
			end if;
		when sync2 =>
			if (wr_en = '1') then
				next_state <= wait_rst;
			else
				next_state <= sync2;
			end if;
		when wait_rst =>
			next_state <= wait_rst;
		when others =>
			next_state <= idle;
		end case;
end process;

-------------------------------------------------
--output registers
-------------------------------------------------
process (clk, rst, ir, state, wr_en, op_mode, esd, scs) begin
	if (rst = '0') or (ir = '0')then
		mode_conf_done <= '0';
		sync_char1_gate <= '0';
		sync_char2_gate <= '0';
		wr_MIR_gate	<= '0';
	elsif rising_edge(clk) then
		case state is
			when idle =>
				mode_conf_done <= '0';
				sync_char1_gate <= '0';
				sync_char2_gate <= '0';
				wr_MIR_gate	<= '1';
				
			when mode =>
				sync_char1_gate <= '0';
				sync_char2_gate <= '0';
				wr_MIR_gate	<= '0';
				
				if (op_mode = '1') and (esd = '0') then
					mode_conf_done <= '0';
				else
					mode_conf_done <= '1';
				end if;
				
			when sync1 =>
				sync_char1_gate <= '1';
				sync_char2_gate <= '0';
				wr_MIR_gate	<= '0';
				
				if (scs = '0') then
					if (wr_en = '1') then
						mode_conf_done <= '0';				
					else
						mode_conf_done <= '0';
					end if;
				else
					if (wr_en = '1') then
						mode_conf_done <= '1';
					else
						mode_conf_done <= '0';
					end if;
				end if;
				
			when sync2 =>
				sync_char1_gate <= '0';
				sync_char2_gate <= '1';
				wr_MIR_gate	<= '0';
				
				if (wr_en = '1') then
					mode_conf_done <= '1';
				else
					mode_conf_done <= '0';
				end if;
				
			when wait_rst =>
				mode_conf_done <= '1';
				sync_char1_gate <= '0';
				sync_char2_gate <= '0';
				wr_MIR_gate	<= '0';
				
			when others =>
				mode_conf_done <= '0';
				sync_char1_gate <= '0';
				sync_char2_gate <= '0';
				wr_MIR_gate	<= '0';

			end case;
	end if;
end process;

end mode_sel_fsm;

