----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:51:47 04/09/2022 
-- Design Name: 
-- Module Name:    parity_gen - rtl 
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

entity parity_gen is
	port (
		din		: in std_logic_vector(7 downto 0);
		ep			: in std_logic;
		load_en	: in std_logic;
		txclk		: in std_logic;
		rst		: in std_logic;

		parity	: out std_logic
		);
end parity_gen;

architecture rtl of parity_gen is

	signal   int_parity	: std_logic;
	signal	local_par	: std_logic;
	signal	mux_par		: std_logic;

begin

	parity <= int_parity;

	process(din, ep)

		variable temp_par: std_logic;

	begin

		temp_par := '0';

		-----------------------------------------------------------------
		--Determine parity
		-----------------------------------------------------------------
    	for i in 1 to 7 loop
			if i = 1 then
				temp_par := din(i-1) xor din(i);
			else
            temp_par := temp_par xor din(i);
			end if;
		end loop;
    
		if (ep = '0') then
    		local_par <= not temp_par;
   	else
    		local_par <= temp_par;
		end if;

	end process;


	process (load_en, local_par, int_parity)
	begin
		if (load_en = '1') then
			mux_par <= local_par;
		else
			mux_par <= int_parity;
		end if;
	end process;


	process (rst, txclk)
	begin
		if (rst = '0') then
			int_parity <='0'; 
		elsif falling_edge(txclk) then
			int_parity <= mux_par;
		end if;
	end process;
	
end rtl;

