library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter is
	 generic (maxCount : natural);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           EN : in  STD_LOGIC;
           TC : out  STD_LOGIC;
           COUNT : out  STD_LOGIC_VECTOR (maxCount downto 0));
end Counter;

architecture Behavioral of Counter is
	signal MAX_CHECK 		 	:	UNSIGNED (maxCount downto 0) := (others => '1');
	signal COUNT_INTERNAL 	:	UNSIGNED (maxCount downto 0) := (others => '0');
	signal TC_INTERNAL 		:	std_logic := '0';
begin

Counting : process (CLK) 
begin
	if (rising_edge(CLK)) then
		if(RST = '1') then 
			COUNT_INTERNAL <= (others => '0');
		else 
			if (EN = '1') then
				COUNT_INTERNAL <= COUNT_INTERNAL + 1;
				if(COUNT_INTERNAL = MAX_CHECK) then
					TC_INTERNAL <= '1';
				else
					TC_INTERNAL <= '0';
				end if;
			end if;
		end if;
	end if;
end process Counting;

TC 	<= TC_INTERNAL;
COUNT <= std_logic_vector(COUNT_INTERNAL);

end Behavioral;

