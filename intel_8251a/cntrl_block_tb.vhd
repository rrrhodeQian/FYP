--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:19:52 03/28/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/cntrl_block_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cntrl_block
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
 
ENTITY cntrl_block_tb IS
END cntrl_block_tb;
 
ARCHITECTURE behavior OF cntrl_block_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cntrl_block
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         nwr : IN  std_logic;
         nrd : IN  std_logic;
         cnd : IN  std_logic;
         ncs : IN  std_logic;
         mode_conf_done : IN  std_logic;
         ntxc : IN  std_logic;
         nrxc : IN  std_logic;
         rx_rst : OUT  std_logic;
         tx_rst : OUT  std_logic;
         cmd_mode_wr_en : OUT  std_logic;
         rx_read : OUT  std_logic;
         sts_read : OUT  std_logic;
         tx_buffer_nwr : OUT  std_logic;
         cmd_reg_wr_en : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal nwr : std_logic := '0';
   signal nrd : std_logic := '0';
   signal cnd : std_logic := '0';
   signal ncs : std_logic := '1';
   signal mode_conf_done : std_logic := '0';
   signal ntxc : std_logic := '0';
   signal nrxc : std_logic := '0';

 	--Outputs
   signal rx_rst : std_logic;
   signal tx_rst : std_logic;
   signal cmd_mode_wr_en : std_logic;
   signal rx_read : std_logic;
   signal sts_read : std_logic;
   signal tx_buffer_nwr : std_logic;
   signal cmd_reg_wr_en : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
	constant ntxc_period : time := 10 ns;
	constant nrxc_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cntrl_block PORT MAP (
          rst => rst,
          clk => clk,
          nwr => nwr,
          nrd => nrd,
          cnd => cnd,
          ncs => ncs,
          mode_conf_done => mode_conf_done,
          ntxc => ntxc,
          nrxc => nrxc,
          rx_rst => rx_rst,
          tx_rst => tx_rst,
          cmd_mode_wr_en => cmd_mode_wr_en,
          rx_read => rx_read,
          sts_read => sts_read,
          tx_buffer_nwr => tx_buffer_nwr,
          cmd_reg_wr_en => cmd_reg_wr_en
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	txclk_process :process
   begin
		ntxc <= '0';
		wait for ntxc_period/2;
		ntxc <= '1';
		wait for ntxc_period/2;
   end process;
	
	rxclk_process :process
   begin
		nrxc <= '0';
		wait for nrxc_period/2;
		nrxc <= '1';
		wait for nrxc_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 500 ns;
		rst <= '1';
		
      wait for clk_period*2; --1
		
      -- insert stimulus here
		mode_conf_done <= '1';
		ncs <= '0';
		nwr <= '0';
		cnd <= '1';
		nrd <= '1';
		
		wait for clk_period*2; --2
		nrd <= '0';
		nwr <= '1';
		
		wait for clk_period*2; --3
		cnd <= '0';
		
		wait for clk_period*2; --4
		nrd <= '1';
		nwr <= '0';
		
--		wait for clk_period*2; --5
--		nrd <= '0';
--		nwr <= '1';
--		
		wait for clk_period*2; --6
		ncs <= '1';
      wait;
   end process;

END;
