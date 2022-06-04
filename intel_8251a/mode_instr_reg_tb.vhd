--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:23:51 03/26/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/mode_instr_reg_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mode_instr_reg
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
 
ENTITY mode_instr_reg_tb IS
END mode_instr_reg_tb;
 
ARCHITECTURE behavior OF mode_instr_reg_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mode_instr_reg
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ir : IN  std_logic;
         wr_en : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         op_mode : OUT  std_logic;
         dout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ir : std_logic := '0';
   signal wr_en : std_logic := '0';
   signal din : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal op_mode : std_logic;
   signal dout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mode_instr_reg PORT MAP (
          clk => clk,
          rst => rst,
          ir => ir,
          wr_en => wr_en,
          din => din,
          op_mode => op_mode,
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
      wait for 100 ns;	
		rst <= '1';
		din <= (others => '1');
      wait for clk_period*2;
		
      -- insert stimulus here 
		wr_en <= '1';
		wait for clk_period;
		ir <= '1';
		wait for clk_period;
		wr_en <= '0';
		din <= "11110000";
		wait for clk_period;
		wr_en <= '1';
		din <= "11110010";
		wait for clk_period;
		din <= "11110001";
		wait for clk_period;
		din <= "11110000";
		wait for clk_period;
		ir <= '0';
      wait;
   end process;

END;
