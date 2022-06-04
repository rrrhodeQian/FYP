--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:36:08 04/30/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/data_mux_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: data_mux
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
 
ENTITY data_mux_tb IS
END data_mux_tb;
 
ARCHITECTURE behavior OF data_mux_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_mux
    PORT(
         l1 : IN  std_logic;
         l2 : IN  std_logic;
         sel : IN  std_logic_vector(1 downto 0);
         din : IN  std_logic_vector(7 downto 0);
         sync1 : IN  std_logic_vector(7 downto 0);
         sync2 : IN  std_logic_vector(7 downto 0);
         data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal l1 : std_logic := '0';
   signal l2 : std_logic := '0';
   signal sel : std_logic_vector(1 downto 0) := (others => '0');
   signal din : std_logic_vector(7 downto 0) := (others => '0');
   signal sync1 : std_logic_vector(7 downto 0) := (others => '0');
   signal sync2 : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal data : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_mux PORT MAP (
          l1 => l1,
          l2 => l2,
          sel => sel,
          din => din,
          sync1 => sync1,
          sync2 => sync2,
          data => data
        );

   -- Clock process definitions
--   clock_process :process
--   begin
--		clock <= '0';
--		wait for clock_period/2;
--		clock <= '1';
--		wait for clock_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for clock_period*5;
		
      -- insert stimulus here
		din <= "10110111";
		sync1 <= "00011000";
		sync2 <= "01100110";
		sel <= "00";
		l1 <= '0';
		l2 <= '0';
		
		wait for clock_period;
		l1 <= '1';
		
		wait for clock_period;
		l2 <= '1';
		l1 <= '0';
		
		wait for clock_period;
		l1 <= '1';
		
		wait for clock_period;
		sel <= "01";
		
		wait for clock_period;
		sel <= "10";

      wait;
   end process;

END;
