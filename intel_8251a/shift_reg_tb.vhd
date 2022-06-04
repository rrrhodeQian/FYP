--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:56:59 04/30/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/shift_reg_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shift_reg
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
 
ENTITY shift_reg_tb IS
END shift_reg_tb;
 
ARCHITECTURE behavior OF shift_reg_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shift_reg
    PORT(
         data : IN  std_logic_vector(7 downto 0);
         shift_en : IN  std_logic;
         load_en : IN  std_logic;
         txclk : IN  std_logic;
         rst : IN  std_logic;
         tx_rst : IN  std_logic;
         shift_reg_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal data : std_logic_vector(7 downto 0) := (others => '0');
   signal shift_en : std_logic := '0';
   signal load_en : std_logic := '0';
   signal txclk : std_logic := '0';
   signal rst : std_logic := '0';
   signal tx_rst : std_logic := '0';

 	--Outputs
   signal shift_reg_out : std_logic;

   -- Clock period definitions
   constant txclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shift_reg PORT MAP (
          data => data,
          shift_en => shift_en,
          load_en => load_en,
          txclk => txclk,
          rst => rst,
          tx_rst => tx_rst,
          shift_reg_out => shift_reg_out
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
		tx_rst <= '1';
		
      wait for txclk_period*2;

      -- insert stimulus here 
		data <= "10100110";
		
		wait for txclk_period;
		load_en <= '1';
		wait for txclk_period;
		load_en <= '0';
		wait for txclk_period;
		shift_en <= '1';
      wait;
   end process;

END;
