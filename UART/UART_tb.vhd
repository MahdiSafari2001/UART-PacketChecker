--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:13:41 03/18/2024
-- Design Name:   
-- Module Name:   C:/Users/asus/Desktop/New folder/My_Project/UART_tb.vhd
-- Project Name:  My_Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART
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
 
ENTITY UART_tb IS
END UART_tb;
 
ARCHITECTURE behavior OF UART_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART
	 generic (
        STOP_BITS   : integer := 1;
        CLK_FREQ    : integer := 100_000_000;
        BAUD_RATE   : integer := 19200
    );
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         Rx : IN  std_logic;
         Tx : OUT  std_logic;
         dataIn : IN  std_logic_vector(7 downto 0);
         dataInRdy : IN  std_logic;
         dataOut : OUT  std_logic_vector(7 downto 0);
         dataOutRdy : OUT  std_logic;
         error : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal Rx : std_logic := '1';--idle state
   signal dataIn : std_logic_vector(7 downto 0) := (others => '0');
   signal dataInRdy : std_logic := '0';--not ready

 	--Outputs
   signal Tx : std_logic;
   signal dataOut : std_logic_vector(7 downto 0);
   signal dataOutRdy : std_logic;
   signal error : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	constant bit_period : time := 52083 ns; -- 1/baudrate
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART PORT MAP (
          clk => clk,
          rst => rst,
          Rx => Rx,
          Tx => Tx,
          dataIn => dataIn,
          dataInRdy => dataInRdy,
          dataOut => dataOut,
          dataOutRdy => dataOutRdy,
          error => error
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
		--round 1
      rst <= '1';
      wait for 100 ns;--hold reset for 100 ns	
		rst <= '0';
		dataInRdy <= '1';
		Rx <= '0';--start bit
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00000001";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
	
		--round 2
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00000010";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 3
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00000011";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 4
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00000100";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 5
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00000101";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 6
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00000110";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 7
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00000111";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 8
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00001000";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 9
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00001001";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 10
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00001010";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 11
      rst <= '1';
      wait for 100 ns;--hold reset for 100 ns	
		rst <= '0';
		dataInRdy <= '1';
		Rx <= '0';--start bit
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00001011";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
	
		--round 12
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00001100";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 13
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00001101";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 14
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00001110";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 15
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00001111";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 16
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00010000";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 17
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00010001";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 18
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00010010";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 19
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00010011";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 20
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00010100";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 21
      rst <= '1';
      wait for 100 ns;--hold reset for 100 ns	
		rst <= '0';
		dataInRdy <= '1';
		Rx <= '0';--start bit
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00010101";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
	
		--round 22
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00010110";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 23
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00010111";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 24
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00011000";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 25
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00011001";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 26
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00011010";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 27
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00011011";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 28
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00011100";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 29
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '0'; 
      dataInRdy <= '1'; 
		dataIn <= "00011101";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
		
		--round 30
		Rx <= '0';--start bit
		dataInRdy <= '1';
      wait for bit_period;-- waiting for start bit to finish
		Rx <= '1'; 
      dataInRdy <= '1'; 
		dataIn <= "00011110";
		wait for bit_period*8;-- wait for a byte to be sent
		dataInRdy <= '0';
		Rx <= '1';
		wait for bit_period; -- wait for stop bit
      wait;
   end process;

END;
