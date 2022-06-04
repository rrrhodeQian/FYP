----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:26:30 02/19/2022 
-- Design Name: 
-- Module Name:    transmitter - asyn_trans 
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

entity transmitter is
generic (
	num_bits: natural := 8);
port (
	txd: out std_logic;		--transmit data
	txrdy: out std_logic;	--transmitter ready
	txempty: out std_logic;	--transmitter empty
	ntxc: in std_logic;		--transmit clock
	tranmitter_data: in std_logic_vector (num_bits-1 downto 0);	--8-bit parallel data
	txen: in std_logic		--transmit enable
	);
end transmitter;

architecture asyn_trans of transmitter is

begin


end asyn_trans;

