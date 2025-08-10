library IEEE;
use IEEE.Std_Logic_1164.all;

entity UART-IP-CORE-VHDL is
	port(
		clk_in	:	in 	std_logic;
		rx			:	in 	std_logic;
		tx			:	out 	std_logic;
		
		data		:	in		std_logic;
		start		:	in		std_logic;
		
	);
end UART-IP-CORE-VHDL;

architecture BEHAV of UART-IP-CORE-VHDL is
--	BEGIN Signals declaration	--
signal 

--	END Signals declaration		--
begin 
--Concurrential

end BEHAV;