----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:40:28 04/15/2022 
-- Design Name: 
-- Module Name:    cntrl_fsm - rtl 
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

entity cntrl_fsm is
	port 
		(
			rst:				in  std_logic;
			txclk: 			in  std_logic;
			tx_rst: 			in  std_logic;
			data_tc: 		in  std_logic;								--data bit terminal count done indication
			b1: 				in  std_logic;								--baud rate factor bit 1
			b2: 				in  std_logic;								--baud rate factor bit 0
			tc: 				in  std_logic;								--tx clock divider count done indication
			half_tc: 		in  std_logic;								--tx clock divider count half done indication
			txen: 			in  std_logic;								--tx enable
			data_rdy: 		in  std_logic;								--tx data ready signal
			cts: 				in  std_logic;								--clear to send signal 
			parity_en: 		in  std_logic;								--parity enable
			s1: 				in  std_logic;								--number of stop bits bit 1
			s2: 				in  std_logic;								--number of stop bits bit 2

			data_cnt_en: 	out std_logic;								--data bit counter count enable
			data_cnt_clr: 	out std_logic;								--data bit counter clear
			sr_empty_n: 	out std_logic;								--tx shift register empty signal
			buffer_nrd: 		out std_logic;								--tx buffer read signal
			div_cnt_en: 	out std_logic;								--tx clock divider count enable
			div_cnt_clr: 	out std_logic;								--tx clock divider count clear
			shift_en: 		out std_logic;								--tx shift register enable
			load_en: 		out std_logic;								--tx shift register load enable
			load_sel: 		out std_logic_vector(1 downto 0);	--tx shift register load data select
			line_mux_sel: 	out std_logic_vector(1 downto 0)		--tx shift register line mux select
		);
end cntrl_fsm;

architecture rtl of cntrl_fsm is
	-------------------------------------------------------------------------------
	--states of FSM
	-------------------------------------------------------------------------------
	type tx_state is 
	(
		init,		--init state (both modes)
		start,	--start bit state (async mode)
		sync1,	--sync character one state (sync mode)
		sync2,	--sync character two state (sync mode)
		data,		--data state (both modes)
		parity,	-- parity state (both modes)
		stop1,	-- stop bit one state (async mode)
		stop2		-- stop bit two state (async mode)
	);

	-------------------------------------------------------------------------------
	--tx shift register input mux select values
	-------------------------------------------------------------------------------
	constant	data_sel: 		std_logic_vector(1 downto 0) := "00";
	constant	sync1_sel: 		std_logic_vector(1 downto 0) := "01";
	constant sync2_sel: 		std_logic_vector(1 downto 0) := "10";
	constant dont_care_sel: std_logic_vector(1 downto 0) := "--";
                
	-------------------------------------------------------------------------------
	--tx shift register output mux select values
	-------------------------------------------------------------------------------
	constant	mux_sel_data: 		std_logic_vector(1 downto 0) := "00";
	constant	mux_sel_parity: 	std_logic_vector(1 downto 0) := "01";
	constant	mux_sel_stop: 		std_logic_vector(1 downto 0) := "10";
	constant	mux_sel_start: 	std_logic_vector(1 downto 0) := "11";

	-------------------------------------------------------------------------------
	--signals for current state and next state
	-------------------------------------------------------------------------------
	signal state: 				tx_state;
	signal next_state: 		tx_state;
	signal next_buffer_nrd: 	std_logic;

begin
	
	-------------------------------------------------------------------------------
	--register for state and buffer_nrd
	-------------------------------------------------------------------------------
	process (txclk, rst)
	begin
		if (rst = '0') then
			buffer_nrd	<= '1';
			state <= init;
		elsif falling_edge (txclk) then
			buffer_nrd	<= next_buffer_nrd;
			state <= next_state;
		end if;
	end process;
	
	-------------------------------------------------------------------------------
	--logic for state transition and outputs
	-------------------------------------------------------------------------------
	process (state, tx_rst, txen, b1, b2, tc, half_tc, data_tc, cts, s1, s2, parity_en, data_rdy)
	begin
		if (tx_rst = '0') then
			next_state		<= init;
			sr_empty_n		<=	'0';
      	next_buffer_nrd 	<= '1';
	 		data_cnt_en    <= '0';  
			data_cnt_clr 	<= '1';
			load_en			<= '0';
	 		load_sel			<= data_sel;  
	 		div_cnt_en		<= '0';  
			div_cnt_clr 	<= '1';
			shift_en 		<= '0';
	  		line_mux_sel   <= mux_sel_stop;
		else
			------------------------------------------
			-- if in synchronous mode
			------------------------------------------
			if (b1 = '0') and (b2 = '0') then
				case state is
				
				
	        		when init =>
						data_cnt_en		<= '0';   
						div_cnt_en     <= '0';   
						shift_en 		<= '0';
						line_mux_sel	<= mux_sel_stop;
						
						if (data_rdy = '1') and (cts = '0') and (txen = '1') then
							next_state		<= data;
							div_cnt_clr		<= '1';
							data_cnt_clr	<= '1';
							load_en			<= '1';
							sr_empty_n		<=	'1';
      					next_buffer_nrd	<= '0';
	 						load_sel			<= data_sel;
	 					else  
							next_state		<= init;
							div_cnt_clr		<= '1';
							data_cnt_clr	<= '1';
							load_en			<= '0';
							sr_empty_n		<=	'0';
      					next_buffer_nrd	<= '1';
	 						load_sel			<= data_sel;  
						end if;


	        		when data =>
						div_cnt_en 		<= '0';
						div_cnt_clr 	<= '1';
						line_mux_sel 	<= mux_sel_data;
						data_cnt_en 	<= '1';
						shift_en 		<= '1';
	
						if data_tc = '1' then
							data_cnt_clr 	<= '1';
							
							if (parity_en = '1') then
								next_state			<= parity;
								sr_empty_n		<=	'0';
      						next_buffer_nrd	<= '1';
								load_en			<= '0';
	 							load_sel			<= dont_care_sel;
							elsif (cts = '0') and (txen = '1') then
								load_en	<= '1';
								
								if (data_rdy = '0') then
									next_state 		<= sync1;
									sr_empty_n		<=	'0';
      							next_buffer_nrd	<= '1';
	 								load_sel			<= sync1_sel;  
								else
									next_state 		<= data;
									sr_empty_n		<=	'1';
      							next_buffer_nrd	<= '0';
	 								load_sel			<= data_sel;  
								end if;
								
							else
								next_state 		<= init;
								sr_empty_n		<=	'1';
      						next_buffer_nrd	<= '1';
								load_en			<= '1';
	 							load_sel			<= dont_care_sel; 
							end if;

						else
							next_state 		<= data;
							data_cnt_clr 	<= '0';
							sr_empty_n		<=	'1';
      					next_buffer_nrd	<= '1';
							load_en			<= '0';
	 						load_sel			<= dont_care_sel;  
						end if;


	        		when sync1 =>
						div_cnt_en 		<= '0';
						div_cnt_clr 	<= '1';
						line_mux_sel 	<= mux_sel_data;
						data_cnt_en 	<= '1';
						shift_en 		<= '1';
	
						if (data_tc = '1') then
							data_cnt_clr 	<= '1';

							if (parity_en = '1') then
								next_state			<= parity;
								sr_empty_n		<=	'0';
      						next_buffer_nrd	<= '1';
								load_en			<= '0';
	 							load_sel			<= dont_care_sel;  
							elsif (cts = '0') and (txen = '1') then
								load_en	<= '1';

								if (data_rdy = '0') then
								
									if (s2 = '1') then 
										next_state 		<= sync1;
										sr_empty_n		<=	'0';
      								next_buffer_nrd	<= '1';
	 									load_sel			<= sync1_sel;
	 								else
										next_state 		<= sync2;
										sr_empty_n		<=	'0';
      								next_buffer_nrd	<= '1';
	 									load_sel			<= sync2_sel;
	 								end if;  
	
								else
								
									if (s2 = '1') then 
										next_state 		<= data;
										sr_empty_n		<=	'0';
      								next_buffer_nrd	<= '0';
	 									load_sel			<= data_sel;
	 								else
										next_state 		<= sync2;
										sr_empty_n		<=	'0';
      								next_buffer_nrd	<= '1';
	 									load_sel			<= sync2_sel;
	 								end if;
								
								end if;

							else
								next_state 		<= init;
								sr_empty_n		<=	'1';
      						next_buffer_nrd	<= '1';
								load_en			<= '1';
	 							load_sel			<= dont_care_sel;
							end if;

						else
							next_state 			<= sync1;
							data_cnt_clr 		<= '0';
							sr_empty_n		<=	'1';
      					next_buffer_nrd	<= '1';
							load_en			<= '0';
	 						load_sel			<= dont_care_sel;  
						end if;
						
						
	        		when sync2 =>
						div_cnt_en 		<= '0';
						div_cnt_clr 	<= '1';
						line_mux_sel 	<= mux_sel_data;
						data_cnt_en 	<= '1';
						shift_en 		<= '1';
	
						if (data_tc = '1') then
							data_cnt_clr 	<= '1';
							
							if (parity_en = '1') then
								next_state		<= parity;
								sr_empty_n		<=	'0';
      						next_buffer_nrd	<= '1';
								load_en			<= '0';
	 							load_sel			<= dont_care_sel;  
	
							elsif (cts = '0') and (txen = '1') then
								load_en	<= '1';

								if (data_rdy = '0') then
									next_state 		<= sync1;
									sr_empty_n		<=	'0';
      							next_buffer_nrd	<= '1';
	 								load_sel			<= sync1_sel;
								else
									next_state 		<= data;
									sr_empty_n		<=	'0';
      							next_buffer_nrd	<= '1';
	 								load_sel			<= data_sel;
								end if;

							else
								next_state 		<= init;
								sr_empty_n		<=	'1';
      						next_buffer_nrd	<= '1';
								load_en			<= '1';
	 							load_sel			<= dont_care_sel;  
							end if;

						else
							next_state 		<= sync2;
							data_cnt_clr 	<= '0';
							sr_empty_n		<=	'1';
      					next_buffer_nrd	<= '1';
							load_en			<= '0';
	 						load_sel			<= dont_care_sel;  
						end if;
						
						
	        		when parity =>
						data_cnt_en		<= '0';   
						shift_en			<= '0';
						data_cnt_clr	<= '0';
						line_mux_sel 	<= mux_sel_parity;
						div_cnt_en 		<= '1';
						div_cnt_clr 	<= '1';
						load_en			<= '1';

						if (cts = '0') and (txen = '1') then
						
							if (data_rdy = '0') then
								next_state 		<= sync1;
								sr_empty_n		<=	'0';
      						next_buffer_nrd	<= '1';
	 							load_sel			<= sync1_sel;		
							else
								next_state 		<= data;
								sr_empty_n		<=	'0';
      						next_buffer_nrd	<= '1';
	 							load_sel			<= data_sel;
							end if;

						else
							next_state 		<= init;
							sr_empty_n		<=	'1';
      					next_buffer_nrd	<= '1';
							load_en			<= '1';
	 						load_sel			<= dont_care_sel;  
						end if;


	      		when others =>
						next_state		<= init;
						sr_empty_n		<=	'0';
      	  			next_buffer_nrd	<= '1';
	 					data_cnt_en    <= '0';  
						data_cnt_clr 	<= '0';
						load_en			<= '0';
	 					load_sel			<= data_sel;  
	 					div_cnt_en    	<= '0';  
						div_cnt_clr 	<= '0';
						shift_en 		<= '0';
	  					line_mux_sel	<= mux_sel_stop;
				end case;

			--------------------------------------------
			-- if in asynchronous mode
			--------------------------------------------
			else
				case state is
				
				
        			when init =>
						data_cnt_en		<= '0';   
						div_cnt_en     <= '0';   
						shift_en 		<= '0';
						data_cnt_clr 	<= '1';
  						sr_empty_n		<= '0'; 
						line_mux_sel	<= "10";   

						if (data_rdy = '1') and (cts = '0') and (txen = '1') then
							next_state		<= start;
							load_sel			<= data_sel;
							div_cnt_clr		<= '1';
							load_en			<= '1';
      					next_buffer_nrd	<= '0';
						else
							next_state 		<= init;
							load_sel			<= data_sel;
							div_cnt_clr		<= '0';
							load_en			<= '0';
      					next_buffer_nrd	<= '1';
						end if;


					when start =>
						load_sel			<= data_sel;
						data_cnt_en		<= '0';   
						load_en			<= '0';   
						shift_en			<= '0';
						data_cnt_clr	<= '0';
      				next_buffer_nrd	<= '1';
  						sr_empty_n		<= '0'; 
						div_cnt_en 		<= '1';
						line_mux_sel 	<= "11";
		  
		  				if (tc = '1') then
							div_cnt_clr	<= '1';
							next_state	<= data;
						else
							div_cnt_clr	<= '0';
							next_state 	<= start;
						end if;


					when data =>
						div_cnt_en		<= '1';
						line_mux_sel 	<= "00";
      				next_buffer_nrd	<= '1';
  						sr_empty_n		<= '0'; 
						load_en			<= '0';   
						load_sel			<= data_sel;
		  
		  				if (tc = '1') then
							div_cnt_clr <= '1';
							data_cnt_en	<= '1';
							shift_en 	<= '1';

							if (data_tc = '1') then
								data_cnt_clr 	<= '1';
								
								if (parity_en = '1') then
									next_state	<= parity;
								else
									next_state	<= stop1;
								end if;

							else
								data_cnt_clr	<= '0';
								next_state 		<= data;
							end if;

						else
							data_cnt_clr	<= '0';
							div_cnt_clr 	<= '0';
							data_cnt_en 	<= '0';
							shift_en 		<= '0';
							next_state 		<= data;
						end if;


        			when parity =>
						data_cnt_en		<= '0';   
						shift_en			<= '0';
						data_cnt_clr	<= '0';
      				next_buffer_nrd	<= '1';
  						sr_empty_n		<= '0'; 
						line_mux_sel 	<= "01";
						div_cnt_en 		<= '1';
						load_en			<= '0';   
						load_sel			<= data_sel;
		  
		  				if (tc = '1') then
							next_state	<= stop1;
							div_cnt_clr	<= '1';
						else
							next_state 	<= parity;
							div_cnt_clr <= '0';
						end if;


        			when stop1 =>
						load_sel			<= data_sel;
						data_cnt_en		<= '0';   
						shift_en			<= '0';
						data_cnt_clr	<= '0';
						line_mux_sel 	<= "10";
						div_cnt_en 		<= '1';

		  				if tc = '1' then
							div_cnt_clr <= '1';

				    		if s2 = '1' then
								next_state 			<= stop2;
								load_en 			<= '0';
      						next_buffer_nrd	<= '1';
  								sr_empty_n 		<= '0';
							else

								if (data_rdy = '1') and (cts = '0') and (txen = '1') then
									next_state		<= start;
									load_en 			<= '1';
      							next_buffer_nrd	<= '0';
  									sr_empty_n 		<= '0';
								else
									next_state			<= init;
									load_en 			<= '0';
      							next_buffer_nrd	<= '1';
  									sr_empty_n 		<= '1';
								end if;

							end if;

						else
  							sr_empty_n		<= '0'; 
							load_en 			<= '0';
      					next_buffer_nrd	<= '1';
							div_cnt_clr 	<= '0';
				    		next_state		<= stop1;
						end if;


        			when stop2 =>
						load_sel			<= data_sel;
						data_cnt_en		<= '0';   
						shift_en			<= '0';
						data_cnt_clr	<= '0';
						line_mux_sel 	<= "10";
						div_cnt_en 		<= '1';
		  
		  				if ((tc = '1') and (s1 = '1')) or ((half_tc = '1') and (s1 = '0')) then
							div_cnt_clr <= '1';

							if (data_rdy = '1') and (cts = '0') and (txen = '1') then
								next_state		<= start;
								load_en 			<= '1';
      						next_buffer_nrd	<= '0';
  								sr_empty_n		<= '0';
							else
								next_state		<= init;
								load_en			<= '0';
      						next_buffer_nrd	<= '1';
  								sr_empty_n 		<= '1';
							end if;

						else
							next_state		<= stop2;
							load_en 			<= '0';
      					next_buffer_nrd	<= '1';
  							sr_empty_n		<= '0'; 
							div_cnt_clr		<= '0';
						end if;


      			when others =>
						next_state		<= init;
						sr_empty_n		<=	'0';
      	  			next_buffer_nrd	<= '1';
	 					data_cnt_en    <= '0';  
						data_cnt_clr 	<= '0';
						load_en			<= '0';
	 					load_sel			<= data_sel;  
	 					div_cnt_en     <= '0';  
						div_cnt_clr 	<= '0';
						shift_en 		<= '0';
	  					line_mux_sel   <= mux_sel_stop;
				end case;
			end if;
		end if;
	end process;

end rtl;

