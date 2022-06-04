--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:46:13 03/27/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/mode_sel_fsm_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mode_sel_fsm
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
 
ENTITY mode_sel_fsm_tb IS
END mode_sel_fsm_tb;
 
ARCHITECTURE behavior OF mode_sel_fsm_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mode_sel_fsm
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ir : IN  std_logic;
         wr_en : IN  std_logic;
         esd : IN  std_logic;
         scs : IN  std_logic;
         op_mode : IN  std_logic;
         mode_conf_done : OUT  std_logic;
         sync_char1_en : OUT  std_logic;
         sync_char2_en : OUT  std_logic;
         wr_MIR_en : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ir : std_logic := '0';
   signal wr_en : std_logic := '0';
   signal esd : std_logic := '0';
   signal scs : std_logic := '0';
   signal op_mode : std_logic := '0';

 	--Outputs
   signal mode_conf_done : std_logic;
   signal sync_char1_en : std_logic;
   signal sync_char2_en : std_logic;
   signal wr_MIR_en : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mode_sel_fsm PORT MAP (
          clk => clk,
          rst => rst,
          ir => ir,
          wr_en => wr_en,
          esd => esd,
          scs => scs,
          op_mode => op_mode,
          mode_conf_done => mode_conf_done,
          sync_char1_en => sync_char1_en,
          sync_char2_en => sync_char2_en,
          wr_MIR_en => wr_MIR_en
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
		ir <= '1';
      wait for 175 ns;

      -- insert stimulus here 
		-- full sequence
		wr_en <= '1';
		wait for clk_period;
		op_mode <= '1';
		esd <= '0';
		wait for clk_period*4;
		ir <= '0';
		
		--esd mode
		wait for clk_period*2;
		ir <= '1';
		wr_en <= '0';
		wait for clk_period;
		wr_en <= '1';
		wait for clk_period;
		esd <= '1';
		
		--scs mode
		wait for clk_period*2;
		rst <= '0';
		wr_en <= '0';
		wait for clk_period;
		rst <= '1';
		wr_en <= '1';
		wait for clk_period;
		esd <= '0';
		wait for clk_period;
		scs <= '1';
		
		--async mode
		wait for clk_period*2;
		rst <= '0';
		wr_en <= '0';
		wait for clk_period;
		rst <= '1';
		wr_en <= '1';
		wait for clk_period;
		op_mode <= '0';
      wait;
   end process;

END;
