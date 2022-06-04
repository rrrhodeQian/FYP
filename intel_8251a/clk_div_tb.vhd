--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:02:16 04/12/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/clk_div_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clk_div
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
 
ENTITY clk_div_tb IS
END clk_div_tb;
 
ARCHITECTURE behavior OF clk_div_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clk_div
    PORT(
         txclk : IN  std_logic;
         reset : IN  std_logic;
         clr_cnt : IN  std_logic;
         count_en : IN  std_logic;
         b1 : IN  std_logic;
         b2 : IN  std_logic;
         half_tc : OUT  std_logic;
         tc : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal txclk : std_logic := '0';
   signal reset : std_logic := '0';
   signal clr_cnt : std_logic := '0';
   signal count_en : std_logic := '0';
   signal b1 : std_logic := '0';
   signal b2 : std_logic := '0';

 	--Outputs
   signal half_tc : std_logic;
   signal tc : std_logic;

   -- Clock period definitions
   constant txclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clk_div PORT MAP (
          txclk => txclk,
          reset => reset,
          clr_cnt => clr_cnt,
          count_en => count_en,
          b1 => b1,
          b2 => b2,
          half_tc => half_tc,
          tc => tc
        );

   -- Clock process definitions
   txclk_process :process
   begin
		txclk <= '0';
		wait for txclk_period/2;
		txclk <= '1';
		wait for txclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		reset <= '1';
		b2 <= '1';
		b1 <= '0';
      wait for txclk_period*2;

      -- insert stimulus here
		count_en <= '1';
      wait;
   end process;

END;
