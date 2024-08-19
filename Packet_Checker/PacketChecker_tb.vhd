--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:31:40 03/30/2024
-- Design Name:   
-- Module Name:   C:/Users/asus/Desktop/New folder/MyProject/PacketChecker_tb.vhd
-- Project Name:  MyProject
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PacketChecker
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
 
ENTITY PacketChecker_tb IS
END PacketChecker_tb;
 
ARCHITECTURE behavior OF PacketChecker_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PacketChecker
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         dataIn : IN  std_logic_vector(7 downto 0);
         dataInRdy : IN  std_logic;
         dataOut : OUT  std_logic_vector(7 downto 0);
         dataOutRdy : OUT  std_logic;
         wrAddress : OUT  std_logic_vector(15 downto 0);
         wrData : OUT  std_logic_vector(31 downto 0);
         wrEn : OUT  std_logic;
         rdAddress : OUT  std_logic_vector(15 downto 0);
         rdData : IN  std_logic_vector(31 downto 0);
         rdRdy : IN  std_logic;
         rdEn : OUT  std_logic;
         error : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic;
   signal rst : std_logic := '0';
   signal dataIn : std_logic_vector(7 downto 0) := (others => '0');
   signal dataInRdy : std_logic := '0';
   signal rdData : std_logic_vector(31 downto 0) := (others => '0');
   signal rdRdy : std_logic := '0';

 	--Outputs
   signal dataOut : std_logic_vector(7 downto 0);
   signal dataOutRdy : std_logic;
   signal wrAddress : std_logic_vector(15 downto 0);
   signal wrData : std_logic_vector(31 downto 0);
   signal wrEn : std_logic;
   signal rdAddress : std_logic_vector(15 downto 0);
   signal rdEn : std_logic;
   signal error : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PacketChecker PORT MAP (
          clk => clk,
          rst => rst,
          dataIn => dataIn,
          dataInRdy => dataInRdy,
          dataOut => dataOut,
          dataOutRdy => dataOutRdy,
          wrAddress => wrAddress,
          wrData => wrData,
          wrEn => wrEn,
          rdAddress => rdAddress,
          rdData => rdData,
          rdRdy => rdRdy,
          rdEn => rdEn,
          error => error
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
----------------testing write command------------------------------------	
      -- hold reset state for 102 ns.
		rst <= '1';
      wait for 102 ns;--10.2 clock cycle	
		rst <= '0';
		dataInRdy <= '1';
		dataIn <= x"00";--header byte (start receiving data from UART)
      wait for clk_period;
		dataInRdy <= '0';
      wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"00";--command byte (write command)
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"00";--AddressH
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"01";--AddressL
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"01";--Data 4
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"02";--Data 3
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"03";--Data 2
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"04";--Data 1
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"00";--CheckSumH
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"0B";--CheckSumL = 0 + 0 + 0 + 1 + 1 + 2 + 3 + 4 = 11 which is "B" in hex
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
----------------testing read command/response------------------------------------	
      wait for 100 ns;--10 clock cycle	
		dataInRdy <= '1';
		dataIn <= x"00";--header byte (start receiving data from UART)
      wait for clk_period;
		dataInRdy <= '0';
      wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"FF";--command byte (read command)	FF = 15*16 + 15 = 255 (eight 1s)
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"00";--AddressH
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"01";--AddressL
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"01";--CheckSumH
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		dataInRdy <= '1';
		dataIn <= x"00";--CheckSumL = 0 + 255 + 0 + 1 = 256 which is "0100" in hex
		wait for clk_period;
		dataInRdy <= '0';
		wait for clk_period*10;
		rdRdy <= '1';--it's time to read data from RAM
		rdData <= x"00FF0101";--header, command, Data 4 and Data 3 are sent
		wait for clk_period;
		rdRdy <= '0';
		wait for clk_period*10;
		rdRdy <= '1';--it's time to read data from RAM
		rdData <= x"01010103";--Data 1, Data 2, CheckSumH and CheckSumL are sent (check sum = 0 + 255 + 1 + 1 + 1 + 1 = 259 = x"103")
		wait for clk_period;
		rdRdy <= '0';
      wait;
   end process;

END;
