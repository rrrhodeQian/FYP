--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:47:16 03/18/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/data_buffer_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: data_buffer
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
 
ENTITY data_buffer_tb IS
END data_buffer_tb;
 
ARCHITECTURE behavior OF data_buffer_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_buffer
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         nwr : IN  std_logic;
         ncs : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         buffered_din : INOUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal nwr : std_logic := '0';
   signal ncs : std_logic := '0';
   signal din : std_logic_vector(7 downto 0) := (others => '0');

	--BiDirs
   signal buffered_din : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_buffer PORT MAP (
          clk => clk,
          rst => rst,
          nwr => nwr,
          ncs => ncs,
          din => din,
          buffered_din => buffered_din
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
      wait for 155 ns;
      -- insert stimulus here 
			nwr <= '0';
			ncs <= '0';
			din <= "00110100";
		wait for clk_period;
			nwr <= '0';
			ncs <= '1';
			din <= "00110101";
		wait for clk_period;
			nwr <= '1';
			ncs <= '0';
		wait for clk_period;
			nwr <= '1';
			ncs <= '1';
		wait for clk_period;
			nwr <= '0';
			ncs <= '0';
      wait;
   end process;

END;
