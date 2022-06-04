--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:00:06 03/28/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/sync_char_reg_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sync_char_reg
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
 
ENTITY sync_char_reg_tb IS
END sync_char_reg_tb;
 
ARCHITECTURE behavior OF sync_char_reg_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sync_char_reg
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ir : IN  std_logic;
         en : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         dout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ir : std_logic := '0';
   signal en : std_logic := '0';
   signal din : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal dout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sync_char_reg PORT MAP (
          clk => clk,
          rst => rst,
          ir => ir,
          en => en,
          din => din,
          dout => dout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 500 ns;	
		rst <= '1';
      wait for clk_period*2;

      -- insert stimulus here 
		ir <= '1';
		din <= (others => '1');
		wait for clk_period*2;
		en <= '1';
		wait for clk_period*2;
		ir <= '0';
      wait;
   end process;

END;
