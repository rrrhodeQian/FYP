----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:57:53 04/03/2022 
-- Design Name: 
-- Module Name:    tx_buffer - rtl 
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

entity tx_buffer is
	port (
		din		: in std_logic_vector (7 downto 0);
		txclk		: in std_logic;
		nrd		: in std_logic;
		nwr		: in std_logic;
		rst		: in std_logic;
		tx_rst	: in std_logic;
		
		data_rdy	: out std_logic;
		ffrdy		: out std_logic;
		dout		: out std_logic_vector (7 downto 0)
		);
end tx_buffer;

architecture rtl of tx_buffer is

signal clear: std_logic;
signal full_flag: std_logic;
signal stack: std_logic_vector (7 downto 0);

begin

ffrdy <= not full_flag;
data_rdy <= full_flag;

process (rst, tx_rst, nwr) begin
	if (rst = '0') or (tx_rst = '0') then
		stack <= (others => '0');
	elsif falling_edge (nwr) then
		stack <= din;
	end if;
end process;

process (rst, tx_rst, nwr) begin
	if (rst = '0') or (tx_rst = '0') then
		dout <= (others => '0');
	elsif rising_edge (nwr) then
		dout <= stack;
	end if;
end process;

process (rst, tx_rst, clear, nwr) begin
	if (rst = '0') or (tx_rst = '0') or (clear = '1') then
		full_flag <= '0';
	elsif rising_edge (nwr) then
		full_flag <= '1';
	end if;
end process;

process (rst, tx_rst, full_flag, nrd, txclk) begin
	if (rst = '0') or (tx_rst = '0') or (full_flag = '0') then
		clear <= '0';
	elsif rising_edge (txclk) then
		clear <= not nrd;
	end if;
end process;


end rtl;

