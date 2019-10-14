--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:15:30 10/13/2019
-- Design Name:   
-- Module Name:   F:/ISE Projects/LEDMatrix/MatrixDriverTB.vhd
-- Project Name:  LEDMatrix
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MatrixDriver
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
 
ENTITY MatrixDriverTB IS
END MatrixDriverTB;
 
ARCHITECTURE behavior OF MatrixDriverTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MatrixDriver
    PORT(
         RST : IN  std_logic;
         CLK : IN  std_logic;
         RGB1 : OUT  std_logic_vector(2 downto 0);
         RGB2 : OUT  std_logic_vector(2 downto 0);
         ABCD : OUT  std_logic_vector(3 downto 0);
         CLK_OUT : OUT  std_logic;
         OE : OUT  std_logic;
         LAT : OUT  std_logic;
         LED_DEBUG : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal RGB1 : std_logic_vector(2 downto 0);
   signal RGB2 : std_logic_vector(2 downto 0);
   signal ABCD : std_logic_vector(3 downto 0);
   signal CLK_OUT : std_logic;
   signal OE : std_logic;
   signal LAT : std_logic;
   signal LED_DEBUG : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MatrixDriver PORT MAP (
          RST => RST,
          CLK => CLK,
          RGB1 => RGB1,
          RGB2 => RGB2,
          ABCD => ABCD,
          CLK_OUT => CLK_OUT,
          OE => OE,
          LAT => LAT,
          LED_DEBUG => LED_DEBUG
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
