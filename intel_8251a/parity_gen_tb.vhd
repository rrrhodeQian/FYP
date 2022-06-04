--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:06:20 04/30/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/parity_gen_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: parity_gen
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
 
ENTITY parity_gen_tb IS
END parity_gen_tb;
 
ARCHITECTURE behavior OF parity_gen_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT parity_gen
    PORT(
         din : IN  std_logic_vector(7 downto 0);
         ep : IN  std_logic;
         load_en : IN  std_logic;
         txclk : IN  std_logic;
         rst : IN  std_logic;
         parity : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal din : std_logic_vector(7 downto 0) := (others => '0');
   signal ep : std_logic := '0';
   signal load_en : std_logic := '0';
   signal txclk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal parity : std_logic;

   -- Clock period definitions
   constant txclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: parity_gen PORT MAP (
          din => din,
          ep => ep,
          load_en => load_en,
          txclk => txclk,
          rst => rst,
          parity => parity
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
		rst <= '1';
      wait for txclk_period*2;

      -- insert stimulus here 
		
		wait for txclk_period;
		din <= "00100110";
		
		wait for txclk_period;
		load_en <= '1';
		
		wait for txclk_period;
		rst <= '0';
		load_en <= '0';
		
		wait for txclk_period;
		rst <= '1';
		din <= "00100110";
		ep <= '1';
		
		wait for txclk_period;
		load_en <= '1';
		
      wait;
   end process;

END;
