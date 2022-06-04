----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:30:31 04/02/2022 
-- Design Name: 
-- Module Name:    data_mux - rtl 
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

entity data_mux is
	port (
		l1		: in std_logic;
		l2		: in std_logic;
		sel	: in std_logic_vector (1 downto 0);
		din	: in std_logic_vector (7 downto 0);
		sync1	: in std_logic_vector (7 downto 0);
		sync2	: in std_logic_vector (7 downto 0);
		
		data	: out std_logic_vector (7 downto 0)
		);
end data_mux;

architecture rtl of data_mux is

	constant data_sel	: std_logic_vector (1 downto 0) := "00";
	constant sync1_sel: std_logic_vector (1 downto 0) := "01";
	constant sync2_sel: std_logic_vector (1 downto 0) := "10";

begin

	process (sel, l1, l2, din, sync1, sync2)
	begin
		case sel is 
			when data_sel =>
				if (l2 = '0') and (l1 = '0') then
					data <= "000" & din (4 downto 0);
				elsif (l2 = '0') and (l1 = '1') then
					data <= "00" & din (5 downto 0);
				elsif (l2 = '1') and (l1 = '0') then
					data <= '0' & din (6 downto 0);
				else
					data <= din;
				end if;
			
			when sync1_sel =>
				if (l2 = '0') and (l1 = '0') then
					data <= "000" & sync1 (4 downto 0);
				elsif (l2 = '0') and (l1 = '1') then
					data <= "00" & sync1 (5 downto 0);
				elsif (l2 = '1') and (l1 = '0') then
					data <= '0' & sync1 (6 downto 0);
				else
					data <= sync1;
				end if;
			
			when sync2_sel =>
				if (l2 = '0') and (l1 = '0') then
					data <= "000" & sync2 (4 downto 0);
				elsif (l2 = '0') and (l1 = '1') then
					data <= "00" & sync2 (5 downto 0);
				elsif (l2 = '1') and (l1 = '0') then
					data <= '0' & sync2 (6 downto 0);
				else
					data <= sync2;
				end if;
				
			when others =>
				data <= (others => '-');
			
		end case;
	end process;

end rtl;

