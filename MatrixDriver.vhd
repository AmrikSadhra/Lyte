library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity MatrixDriver is
    Port ( RST 		: in  STD_LOGIC;
			  CLK 		: in  STD_LOGIC;
           RGB1 		: out  STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
           RGB2 		: out  STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
           ABCD 		: out  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           CLK_OUT 	: out  STD_LOGIC;
           OE 			: out  STD_LOGIC := '0';
           LAT 		: out  STD_LOGIC := '0';
			  LED_DEBUG : out	 STD_LOGIC := '0');
end MatrixDriver;

architecture Behavioral of MatrixDriver is
--------- INTERNAL SIGNALS -----------
	signal ADDRESS    : UNSIGNED(3 downto 0) := (others => '0'); -- Address to increment
	signal CLK_DIV		: STD_LOGIC				  := '0';
	
	signal SHIFT_RST 	: STD_LOGIC 			  := '0';
	signal SHIFT_EN 	: STD_LOGIC 			  := '0';
	signal SHIFT_DONE : STD_LOGIC 			  := '0';
	
	signal ADDR_EN 	: STD_LOGIC 			  := '0';
	
------------- FSM STATE --------------
	type state_type is (RESET, SHIFTING, LATCHING, ROW_SWITCH);
	signal state, next_state : state_type;
begin

------------ INSTANTIATION ------------
-- Divide the clock by TC of Counter. 50Mhz in, 4 bits, 50Mhz/16 = 2.5Mhz
ClockDivider: entity work.Counter				
	generic map (maxCount => 3)				
	port map(TC  => CLK_DIV,
				CLK => CLK,
				RST => '0',
				EN  => '1',
				COUNT => open);

-- Count up to 64 so RGB data can be shifted into Matrix				
ShiftCounter: entity work.Counter				
	generic map (maxCount => 5)				
	port map(TC  => SHIFT_DONE,
				CLK => CLK_DIV,
				RST => SHIFT_RST,
				EN  => SHIFT_EN,
				COUNT => open);				

-- Roll through all 16 addresses (rows) 				
AddrCounter: entity work.Counter				
	generic map (maxCount => 3)				
	port map(TC  => open,
				CLK => CLK_DIV,
				RST => '0',
				EN  => ADDR_EN,
				COUNT => ABCD);						
				
-- FSM state assignment				
state_assignment: process (CLK_DIV) is
	begin
		if rising_edge(CLK_DIV) then
			if (RST = '0') then
				state <= RESET;
			else
				state <= next_state; 
			end if;
		end if;
end process state_assignment;

-- Definitions for the state transitions .
fsm_process: process (state, SHIFT_DONE, ADDRESS) is
begin
    case state is
			-- Reset state
			when RESET =>
				next_state <= SHIFTING;
				
			-- Shifting data into current row
			-- Shift in 64 times. One row = 64 pixels = b11111
			when SHIFTING =>
				if(SHIFT_DONE = '1') then
					next_state <= LATCHING;
				else 
					next_state <= SHIFTING;
				end if;
				
			-- Latching State (OE and LAT HIGH) 
			when LATCHING =>
				next_state <= ROW_SWITCH;
			
			-- Address change
			when ROW_SWITCH =>
				next_state <= SHIFTING;
				
    end case;
end process fsm_process;

--------- COMBINATORIAL LOGIC ---------
-- Pass through divided clock
CLK_OUT <= CLK_DIV;

-- Enable the address counter only when in row switch state
ADDR_EN <= '1' when state = ROW_SWITCH else
			  '0';

-- Enable the shift counter only when in shift state
SHIFT_RST <= '0' when state = SHIFTING else
				 '1';	 
SHIFT_EN <=  '1' when state = SHIFTING else
				 '0';

-- Latch and OE
OE  <= '1' when state = LATCHING or state = ROW_SWITCH else 
		 '0';
		
LAT <= '1' when state = LATCHING or state = ROW_SWITCH else 
		 '0';

-- Set RGB data only when shifting
RGB1 		 <= "111" when state = SHIFTING else
				 "000";  
RGB2 		 <= "111" when state = SHIFTING else
				 "000";	  
-- Debug
LED_DEBUG <= '1' when state = SHIFTING else 
				 '0';

end Behavioral;

