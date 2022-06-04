--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:34:32 03/27/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/cmd_instr_reg_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cmd_instr_reg
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
 
ENTITY cmd_instr_reg_tb IS
END cmd_instr_reg_tb;
 
ARCHITECTURE behavior OF cmd_instr_reg_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cmd_instr_reg
    PORT(
         clk : IN  std_logic;
         rxclk : IN  std_logic;
         rst : IN  std_logic;
         int_state_rst : IN  std_logic;
         wr_en : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         txen : OUT  std_logic;
         ndtr : OUT  std_logic;
         rxen : OUT  std_logic;
         sbrk : OUT  std_logic;
         er : OUT  std_logic;
         nrts : OUT  std_logic;
         ir : OUT  std_logic;
         eh : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rxclk : std_logic := '0';
   signal rst : std_logic := '0';
   signal int_state_rst : std_logic := '0';
   signal wr_en : std_logic := '0';
   signal din : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal txen : std_logic;
   signal ndtr : std_logic;
   signal rxen : std_logic;
   signal sbrk : std_logic;
   signal er : std_logic;
   signal nrts : std_logic;
   signal ir : std_logic;
   signal eh : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
   constant rxclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cmd_instr_reg PORT MAP (
          clk => clk,
          rxclk => rxclk,
          rst => rst,
          int_state_rst => int_state_rst,
          wr_en => wr_en,
          din => din,
          txen => txen,
          ndtr => ndtr,
          rxen => rxen,
          sbrk => sbrk,
          er => er,
          nrts => nrts,
          ir => ir,
          eh => eh
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   rxclk_process :process
   begin
		rxclk <= '0';
		wait for rxclk_period/2;
		rxclk <= '1';
		wait for rxclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 500 ns.
      wait for 500 ns;	
		rst <= '1';
		int_state_rst <= '1';

      -- insert stimulus here 
      wait for clk_period*2; --wr_en check
		wr_en <= '1';
		din <= "00000011";
		
		wait for clk_period;	--er check
		din <= "00010011";
		
		wait for clk_period;
		wr_en <= '0';
		
		
		wait for clk_period*4; --ir check
		wr_en <= '1';
		din <= "01010011";
		wait for 50 ns;
		int_state_rst <= '0';
		wr_en <= '0';
		
		wait for clk_period;	--eh check
		int_state_rst <= '1';
		wait for 50 ns;
		wr_en <= '1';
		din <= "10000000";
		
		wait for 50 ns;
		wr_en <= '0';
      wait;
   end process;

END;
