----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:08:31 04/02/2022 
-- Design Name: 
-- Module Name:    tx - rtl 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tx is
	port (
		b1				: in std_logic;
		b2				: in std_logic;
		l1				: in std_logic;
		l2				: in std_logic;
		pen			: in std_logic;
		ep				: in std_logic;
		s1				: in std_logic;
		s2				: in std_logic;
		sbrk			: in std_logic;
		rst			: in std_logic;
		txclk			: in std_logic;
		tx_rst		: in std_logic;
		txen			: in std_logic;
		tx_buffer_nwr	: in std_logic;
		ncts			: in std_logic;
		sync_char1	: in std_logic_vector (7 downto 0);
		sync_char2	: in std_logic_vector (7 downto 0);
		din			: in std_logic_vector (7 downto 0);
		
		tx_data			: out std_logic;
		tx_ffrdy			: out std_logic;
		tx_sr_empty_n	: out std_logic
		);
end tx;

architecture rtl of tx is
	
	signal buffer_out		: std_logic_vector (7 downto 0);
	signal data_rdy_line	: std_logic;
	signal data_write_in	: std_logic_vector (7 downto 0);
	signal line_mux_sel	: std_logic_vector (1 downto 0);
	signal load_sel		: std_logic_vector (1 downto 0);
	signal shift_en_line	: std_logic;
	signal load_en_line	: std_logic;
	signal buffer_nrd		: std_logic;
	signal parity_line	: std_logic;
	signal sr_out			: std_logic;
	
	component tx_buffer
		port (
			din		: in std_logic_vector (7 downto 0);
			txclk		: in std_logic;
			nrd		: in std_logic;
			nwr		: in std_logic;
			rst		: in std_logic;
			tx_rst	: in std_logic;
			data_rdy	: out std_logic;
			ffrdy		: out std_logic;
			dout		: out std_logic_vector (7 downto 0)
			);
	end component;
	
	component data_mux
		port (
			l1		: in std_logic;
			l2		: in std_logic;
			sel	: in std_logic_vector (1 downto 0);
			din	: in std_logic_vector (7 downto 0);
			sync1	: in std_logic_vector (7 downto 0);
			sync2	: in std_logic_vector (7 downto 0);
			data	: out std_logic_vector (7 downto 0)
			);
	end component;
	
	component tx_cntrl
		port (
			b1				: in std_logic;
			b2				: in std_logic;
			l1				: in std_logic;
			l2				: in std_logic;
			pen			: in std_logic;
			s1				: in std_logic;
			s2				: in std_logic;
			txclk			: in std_logic;
			cts			: in std_logic;
			txen			: in std_logic;
			data_rdy		: in std_logic;
			rst			: in std_logic;
			tx_rst		: in std_logic;
			shift_en		: out std_logic;
			load_en		: out std_logic;
			buffer_nrd		: out std_logic;
			sr_empty_n	: out std_logic;
			line_mux_sel: out std_logic_vector (1 downto 0);
			load_sel		: out std_logic_vector (1 downto 0)
			);
	end component;
	
	component shift_reg
		port (
			data		: in std_logic_vector (7 downto 0);
			shift_en	: in std_logic;
			load_en	: in std_logic;
			txclk		: in std_logic;
			rst		: in std_logic;
			tx_rst	: in std_logic;
			
			shift_reg_out	: out std_logic
			);
	end component;
	
	component parity_gen
		port (
			din		: in std_logic_vector(7 downto 0);
			ep			: in std_logic;
			load_en	: in std_logic;
			txclk		: in std_logic;
			rst		: in std_logic;
			parity	: out std_logic
			);
	end component;
	
	component line_mux
		port (
			sr_data	: in std_logic;
			parity	: in std_logic;
			sel		: in std_logic_vector (1 downto 0);
			sbrk		: in std_logic;
			tx_data	: out std_logic
			);
	end component;

begin

	i_tx_buffer: tx_buffer
	port map (
		din => din,
		txclk => txclk,
		nrd => buffer_nrd,
		nwr => tx_buffer_nwr,
		rst => rst,
		tx_rst => tx_rst,
		data_rdy	=> data_rdy_line,
		ffrdy => tx_ffrdy,
		dout => buffer_out
		);
		
	i_data_mux: data_mux
	port map (
		l1 => l1,
		l2 => l1,
		sel => load_sel,
		din => buffer_out,
		sync1	=> sync_char1,
		sync2	=> sync_char2,
		data => data_write_in
		);
		
	i_tx_cntrl: tx_cntrl
	port map (
		b1 => b1,
		b2 => b2,
		l1 => l1,
		l2 => l2,
		pen => pen,
		s1 => s1,
		s2 => s2,
		txclk => txclk,
		cts => ncts,
		txen => txen,
		data_rdy	=> data_rdy_line,
		rst => rst,
		tx_rst => tx_rst,
		shift_en => shift_en_line,
		load_en => load_en_line,
		buffer_nrd => buffer_nrd,
		sr_empty_n => tx_sr_empty_n,
		line_mux_sel => line_mux_sel,
		load_sel => load_sel
		);

	i_shift_reg: shift_reg
	port map (
		data => data_write_in,
		shift_en => shift_en_line,
		load_en => load_en_line,
		txclk => txclk,
		rst => rst,
		tx_rst => tx_rst,	
		shift_reg_out	=> sr_out
		);

	i_parity_gen: parity_gen
	port map (
		din => data_write_in,
		ep	=> ep,
		load_en => load_en_line,
		txclk => txclk,
		rst => rst,
		parity => parity_line
		);

	i_line_mux: line_mux
	port map(
		sr_data => sr_out,
		parity => parity_line,
		sel => line_mux_sel,
		sbrk => sbrk,
		tx_data => tx_data
		);

end rtl;

