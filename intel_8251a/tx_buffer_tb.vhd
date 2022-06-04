--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:49:48 04/28/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/tx_buffer_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: tx_buffer
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
 
ENTITY tx_buffer_tb IS
END tx_buffer_tb;
 
ARCHITECTURE behavior OF tx_buffer_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT tx_buffer
    PORT(
         din : IN  std_logic_vector(7 downto 0);
         txclk : IN  std_logic;
         nrd : IN  std_logic;
         nwr : IN  std_logic;
         rst : IN  std_logic;
         tx_rst : IN  std_logic;
         data_rdy : OUT  std_logic;
         ffrdy : OUT  std_logic;
         dout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal din : std_logic_vector(7 downto 0) := (others => '0');
   signal txclk : std_logic := '0';
   signal nrd : std_logic := '1';
   signal nwr : std_logic := '1';
   signal rst : std_logic := '0';
   signal tx_rst : std_logic := '0';

 	--Outputs
   signal data_rdy : std_logic;
   signal ffrdy : std_logic;
   signal dout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant txclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: tx_buffer PORT MAP (
          din => din,
          txclk => txclk,
          nrd => nrd,
          nwr => nwr,
          rst => rst,
          tx_rst => tx_rst,
          data_rdy => data_rdy,
          ffrdy => ffrdy,
          dout => dout
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

      wait for txclk_period*2;
		rst <= '1';
		tx_rst <= '1';
		din <= (others => '1');
		
      wait for txclk_period*2;

      -- insert stimulus here 
		nrd <= '0';
		
		wait for txclk_period;
		nrd <= '1';

		wait for txclk_period;
		nwr <= '0';
		
		wait for txclk_period;
		nwr <= '1';
		
		wait for txclk_period;
		nwr <= '1';
		din <= "10110011";
		
		wait for txclk_period;
		nrd <= '0';
		
		wait for txclk_period;
		nrd <= '1';
		din <= "01010001";
		
		wait for txclk_period;
		nrd <= '0';
		
		wait for txclk_period;
		nrd <= '1';
		
		wait for txclk_period;
		nwr <= '0';
		
		wait for txclk_period;
		nwr <= '1';
		
		wait;
   end process;

END;
