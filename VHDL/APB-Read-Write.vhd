library IEEE;
use IEEE.Std_Logic_1164.all;

package APB_SLAVE is

	constant DATA_WIDTH				:	positive := 32;
	constant ADDRESS					:	positive	:= 32;
	type APB_SLAVE_IN_Type is record
		
		apb_s00_paddr_i		:		std_logic_vector(ADDRESS-1 downto 0);		--width: 32 bits --*
		apb_s00_pselx_i		:		std_logic;										--width: 1 bit --*
		apb_s00_penable_i		:		std_logic;										--width: 1 bit --*
		apb_s00_pwrite_i		:		std_logic;										--width:	1 bit --*
		apb_s00_pwdata_i		:		std_logic_vector(DATA_WIDTH-1 downto 0);	--width: DATA_WIDTH = 32 bits --*
		

	end record;

	type APB_SLAVE_OUT_Type is record
		apb_s00_pready_o		:		std_logic;									--width: 1 bit
		apb_s00_prdata_o		:		std_logic_vector(31 downto 0);		--width: DATA_WIDTH = 32 bits --*

		
	end record;
	procedure apb_procedure(
		signal clk				:		in std_logic;
		signal apb_i			:		out APB_SLAVE_IN_Type;
		signal apb_o			:		in	APB_SLAVE_OUT_Type;
		signal apb_address	:		in	std_logic_vector(ADDRESS-1 downto 0);
		signal apb_data		:		inout std_logic_vector(DATA_WIDTH-1 downto 0);
		signal apb_pwrite_i	:		in std_logic
	);
end package;

package body APB_SLAVE is
	
	procedure apb_procedure(
		signal clk				:		in std_logic;
		signal apb_i			:		out APB_SLAVE_IN_Type;
		signal apb_o			:		in	APB_SLAVE_OUT_Type;
		signal apb_address	:		in	std_logic_vector(ADDRESS-1 downto 0);
		signal apb_data		:		inout std_logic_vector(DATA_WIDTH-1 downto 0);
		signal apb_pwrite_i	:		in std_logic
	) is

	begin
	
	apb_i.apb_s00_pselx_i     <= '0';
	apb_i.apb_s00_penable_i   <= '0';
	apb_i.apb_s00_pwrite_i    <= '0';
	apb_i.apb_s00_paddr_i     <= (others => '0');
	apb_i.apb_s00_pwdata_i    <= (others => '0');
		case apb_pwrite_i is
			when '1'=>
				apb_i.apb_s00_pselx_i 		<= '1';
				apb_i.apb_s00_penable_i		<= '0';
				apb_i.apb_s00_paddr_i		<= apb_address;
				apb_i.apb_s00_pwrite_i		<= '1';
				apb_i.apb_s00_pwdata_i		<= apb_data;
				wait until rising_edge(clk);			
				
				-- Enable phase
				apb_i.apb_s00_penable_i		<=	'1';
				
				-- Wait until slave is ready
				loop
					wait until rising_edge(clk);
					exit when apb_o.apb_s00_pready_o = '1';
				end loop;
				
				-- End of transfer
				apb_i.apb_s00_pselx_i		<=	'0';
				apb_i.apb_s00_pwrite_i		<= '0';
				apb_i.apb_s00_penable_i		<= '0';
				
			when '0'=>
				apb_i.apb_s00_pselx_i 		<= '1';
				apb_i.apb_s00_penable_i		<= '0';
				apb_i.apb_s00_paddr_i		<= apb_address;
				apb_i.apb_s00_pwrite_i		<= '0';
				wait until rising_edge(clk);
				-- Enable phase
				apb_i.apb_s00_penable_i		<=	'1';
				
				-- Wait until slave is ready
				loop
					wait until rising_edge(clk);
					exit when apb_o.apb_s00_pready_o = '1';
				end loop;
				
				-- Capture read data
				apb_data <= apb_o.apb_s00_prdata_o;
				
				-- End transfer
				apb_i.apb_s00_pselx_i		<=	'0';
				apb_i.apb_s00_penable_i		<= '0';
				
			when others =>
				apb_i.apb_s00_pselx_i 		<= '0';
				apb_i.apb_s00_penable_i		<= '0';
				
		end case;
	end procedure;
end package;