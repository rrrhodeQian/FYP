----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:02:03 04/28/2022 
-- Design Name: 
-- Module Name:    cntrlop_gen - rtl 
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

entity cntrlop_gen is
	port (
		tx_ffrdy			: in std_logic;
		ncts				: in std_logic;
		txen				: in std_logic;
		tx_sr_empty_n	: in std_logic;

		txempty			: out std_logic;
		txrdy				: out std_logic
		);
end cntrlop_gen;

architecture rtl of cntrlop_gen is

begin

	txrdy <= tx_ffrdy and not ncts and txen;
	txempty <= tx_ffrdy and not tx_sr_empty_n;

end rtl;

