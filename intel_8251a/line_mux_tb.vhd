--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:25:51 04/30/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/line_mux_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: line_mux
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY line_mux_tb IS
END line_mux_tb;
 
ARCHITECTURE behavior OF line_mux_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT line_mux
    PORT(
         sr_data : IN  std_logic;
         parity : IN  std_logic;
         sel : IN  std_logic_vector(1 downto 0);
         sbrk : IN  std_logic;
         tx_data : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal sr_data : std_logic := '0';
   signal parity : std_logic := '0';
   signal sel : std_logic_vector(1 downto 0) := (others => '0');
   signal sbrk : std_logic := '0';

 	--Outputs
   signal tx_data : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: line_mux PORT MAP (
          sr_data => sr_data,
          parity => parity,
          sel => sel,
          sbrk => sbrk,
          tx_data => tx_data
        );
 
 
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for clock_period;
		
      -- insert stimulus here 
		sel <= "00";
		sr_data <= '1';
		wait for clock_period;
		sr_data <= '0';
		
		wait for clock_period;
		sel <= "01";
		parity <= '1';
		
		wait for clock_period;
		parity <= '0';
		
		wait for clock_period;
		sel <= "10";
		
      wait;
   end process;

END;
