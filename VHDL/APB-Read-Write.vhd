library IEEE;
use IEEE.Std_Logic_1164.all;

package APB_SLAVE is

	generic(
		DATA_WIDTH				:	positive := 31;
		ADDRESS					:	positive	:= 31
	);
	
	type APB_SLAVE_IN_Type is record
		
		apb_s00_clk_i			:		in std_logic;										--width: 1 bit --*
		apb_s00_presetn_i		:		in	std_logic;										--width: 1 bit --*
		apb_s00_paddr_i		:		in std_logic_vector(ADDRESS downto 0);		--width: 32 bits --*
		apb_s00_pselx_i		:		in std_logic;										--width: 1 bit --*
		apb_s00_penable_i		:		in std_logic;										--width: 1 bit --*
		apb_s00_pwrite_i		:		in	std_logic;										--width:	1 bit --*
		apb_s00_pwdata_i		:		in std_logic_vector(DATA_WIDTH downto 0);	--width: DATA_WIDTH = 32 bits --*
		apb_s00_pstrb_i		:		in	std_logic_vector(3 downto 0);				--width: DATA_WIDTH/8 = 4 bits; 

	end record;

	type APB_SLAVE_OUT_Type is record
		apb_s00_pready_o		:		out std_logic;									--width: 1 bit
		apb_s00_prdata_o		:		out std_logic_vector(31 downto 0);		--width: DATA_WIDTH = 32 bits --*
		apb_s00_pslverr_o		:		out std_logic;									--width:	1 bit
		
	end record;

	procedure apb_procedure(
		signal apb_i			:		out APB_SLAVE_IN_Type;
		signal apb_o			:		in	APB_SLAVE_OUT_Type;
		signal apb_address	:		in	std_logic_vector(ADDRESS downto 0);
		signal apb_data		:		in std_logic_vector(DATA_WIDTH downto 0);
		signal apb_pwrite_i	:		in std_logic;
	);
	begin
		case apb_pwrite_i is
			when '1'=>
				apb_i.apb_s00_pselx_i 		<= '1';
				apb_i.apb_s00_penable_i		<= '0';
				apb_i.apb_s00_paddr_i		<= apb_address;
				apb_i.apb_s00_pwrite_i		<= '1';
				
				apb_i.apb_s00_penable_i		<=	'1';
				apb_i.apb_s00_pselx_i		<=	'0';
				
			when '0'=>
				apb_i.apb_s00_pselx_i 		<= '1';
				apb_i.apb_s00_penable_i		<= '0';
				apb_i.apb_s00_paddr_i		<= apb_address;
				apb_i.apb_s00_pwrite_i		<= '0';
				
				apb_i.apb_s00_penable_i		<=	'1';
				apb_i.apb_s00_pselx_i		<=	'0';
			when others =>
		end case;
	end procedure;
end package;