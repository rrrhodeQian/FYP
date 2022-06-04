----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:01:04 02/23/2022 
-- Design Name: 
-- Module Name:    cmd_instr_reg - cmd_instr_reg 
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

entity cmd_instr_reg is
port (
	clk: 					in std_logic;								--master clock
	rxclk: 				in std_logic;								--receive clock
	rst: 					in std_logic;								--external reset
	int_state_rst: 	in std_logic;								--internal state rst
	wr_en: 				in std_logic;								--command reg write enable
	din: 					in std_logic_vector (7 downto 0);	--data in
	
	txen: 				out std_logic;								--transmit enable
	ndtr: 				out std_logic;								--data terminal ready
	rxen: 				out std_logic;								--receiver enable
	sbrk: 				out std_logic;								--send break character
	er: 					out std_logic;								--error reset
	nrts: 				out std_logic;								--request to send
	ir: 					out std_logic;								--internal reset
	eh: 					out std_logic								--enter hunt
	);
end cmd_instr_reg;

architecture rtl of cmd_instr_reg is

signal cmd_reg: 			std_logic_vector (7 downto 0);
signal cmd_reg1: 			std_logic_vector (7 downto 0);
signal int_eh: 			std_logic;
signal int_eh1: 			std_logic;
signal int_eh2: 			std_logic;
signal int_er: 			std_logic;
signal int_ir: 			std_logic;
signal int_ir1:			std_logic;
signal int_dtr: 			std_logic;
signal int_rts: 			std_logic;
signal int_rxen: 			std_logic;
signal int_txen: 			std_logic;
signal int_sbrk: 			std_logic;

begin
-------------------------------------------------
--continuous assignments
-------------------------------------------------
txen 		<= int_txen;
ndtr 		<= int_dtr;
rxen 		<= int_rxen;
sbrk 		<= int_sbrk;
er 		<= int_er;
nrts 		<= int_rts;
ir 		<= int_ir;
eh 		<= int_eh;

int_txen <= cmd_reg(0);
int_dtr 	<= not cmd_reg(1);
int_rxen <= cmd_reg(2);
int_sbrk <= cmd_reg(3);
int_er 	<= not cmd_reg(4);
int_rts 	<= not cmd_reg(5);
int_ir 	<= (not cmd_reg(6)) or int_ir1;
int_eh 	<= (not int_eh2) and int_eh1;



process (int_state_rst, int_er, int_eh, wr_en, din, cmd_reg) begin
	if (int_state_rst = '0') then														--internal state reset is asserted
		cmd_reg1 <= (others => '0');
	elsif (int_er = '0') then															--error reset is asserted
		cmd_reg1 <= cmd_reg (7 downto 5) & '0' & cmd_reg (3 downto 0);
	elsif (int_eh = '1') then															--entry hunt is asserted
		cmd_reg1 <= '0' & cmd_reg (6 downto 0);
	elsif (wr_en = '1') then															--enable write to cmd instr reg
		cmd_reg1 <= din;
	else
		cmd_reg1 <= cmd_reg;
	end if;
end process;

-------------------------------------------------
--two cascade DFFs for internal state reset
-------------------------------------------------
process (rst, clk) begin
	if (rst = '0') then
		cmd_reg <= (others => '0');
		int_ir1 <= '0';
	elsif rising_edge (clk) then
		cmd_reg <= cmd_reg1;
		int_ir1 <= cmd_reg(6);
	end if;
end process;

-------------------------------------------------
--two cascade DFFs for internal entry hunt signal
-------------------------------------------------
process (rst, rxclk) begin
	if (rst = '0') then
		int_eh1 <= '0';
		int_eh2 <= '0';
	elsif rising_edge (rxclk) then
		int_eh1 <= cmd_reg(7);
		int_eh2 <= int_eh1;
	end if;
end process;

end rtl;

