----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:22:33 04/10/2022 
-- Design Name: 
-- Module Name:    line_mux - rtl 
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

entity line_mux is
	port (
		sr_data	: in std_logic;
      parity	: in std_logic;
      sel		: in std_logic_vector (1 downto 0);
		sbrk		: in std_logic;

      tx_data	: out std_logic
		);
end line_mux;

architecture rtl of line_mux is

	constant	sel_data		: std_logic_vector (1 downto 0) := "00";
	constant	sel_parity	: std_logic_vector (1 downto 0) := "01";
	constant	sel_stop		: std_logic_vector (1 downto 0) := "10";
	constant sel_start	: std_logic_vector (1 downto 0) := "11";

begin

	-----------------------------------------------------------------
	--Determine output
	-----------------------------------------------------------------
	output: process (sbrk, sel, sr_data, parity)
	
	begin
		if (sbrk = '1') then
			tx_data <= '0';
		else
			if (sel = sel_data) then
				tx_data <= sr_data;
			elsif (sel = sel_parity) then
				tx_data <= parity;
			elsif (sel = sel_stop) then
				tx_data <= '1';
			else
				tx_data <= '0';
			end if;
		end if;

	end process;

end rtl;

