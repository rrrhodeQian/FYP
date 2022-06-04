--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:27:01 04/30/2022
-- Design Name:   
-- Module Name:   C:/Users/qianyutian/Desktop/intel_8251a/intel_8251a/top_tb.vhd
-- Project Name:  intel_8251a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
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
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         cnd : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         extsyncd : IN  std_logic;
         ncs : IN  std_logic;
         ncts : IN  std_logic;
         ndsr : IN  std_logic;
         nrd : IN  std_logic;
         nrxc : IN  std_logic;
         ntxc : IN  std_logic;
         nwr : IN  std_logic;
         rxd : IN  std_logic;
         dout : OUT  std_logic_vector(7 downto 0);
         ndtr : OUT  std_logic;
         nen : OUT  std_logic;
         nrts : OUT  std_logic;
         rxrdy : OUT  std_logic;
         syn_brk : OUT  std_logic;
         txd : OUT  std_logic;
         txempty : OUT  std_logic;
         txrdy : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal cnd : std_logic := '0';
   signal din : std_logic_vector(7 downto 0) := (others => '0');
   signal extsyncd : std_logic := '0';
   signal ncs : std_logic := '1';
   signal ncts : std_logic := '0';
   signal ndsr : std_logic := '0';
   signal nrd : std_logic := '0';
   signal nrxc : std_logic := '0';
   signal ntxc : std_logic := '0';
   signal nwr : std_logic := '1';
   signal rxd : std_logic := '0';

 	--Outputs
   signal dout : std_logic_vector(7 downto 0);
   signal ndtr : std_logic;
   signal nen : std_logic;
   signal nrts : std_logic;
   signal rxrdy : std_logic;
   signal syn_brk : std_logic;
   signal txd : std_logic;
   signal txempty : std_logic;
   signal txrdy : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
	constant txclk_period : time := 2 ns;
	constant rxclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clk => clk,
          rst => rst,
          cnd => cnd,
          din => din,
          extsyncd => extsyncd,
          ncs => ncs,
          ncts => ncts,
          ndsr => ndsr,
          nrd => nrd,
          nrxc => nrxc,
          ntxc => ntxc,
          nwr => nwr,
          rxd => rxd,
          dout => dout,
          ndtr => ndtr,
          nen => nen,
          nrts => nrts,
          rxrdy => rxrdy,
          syn_brk => syn_brk,
          txd => txd,
          txempty => txempty,
          txrdy => txrdy
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
		wait for txclk_period/2;
		ntxc <= '1';
		wait for txclk_period/2;
   end process;
	
	rxclk_process :process
   begin
		nrxc <= '0';
		wait for rxclk_period/2;
		nrxc <= '1';
		wait for rxclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		rst <= '1';
      wait for clk_period*2;

      -- insert stimulus here 
		cnd <= '1';
		nrd <= '1';
		nwr <= '0';
		ncs <= '0';
		din <= "01111101";	--async, 8-bit, divide-by-1, one stop bit, even parity
		
		wait for clk_period;
		nwr <= '1';
		
		--enable loading tx buffer 
		wait for clk_period*4;	
--		cnd <= '0';
		nwr <= '0';
		din <= "11001100";
		
		wait for clk_period;
		cnd <= '0';
		
		--load cmd_instr_reg
		wait for clk_period;
		cnd <= '1';
		din <= "00000001";
		
		wait for clk_period;
		nwr <= '1';
		
      wait;
   end process;

END;
