library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
entity UART is
 generic (
        STOP_BITS   : integer := 1;
        CLK_FREQ    : integer := 100_000_000;
        BAUD_RATE   : integer := 19200
    );
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        Rx          : in  std_logic;
        Tx          : out std_logic;
        dataIn      : in  std_logic_vector(7 downto 0);
        dataInRdy   : in  std_logic;
        dataOut     : out std_logic_vector(7 downto 0);
        dataOutRdy  : out std_logic;
        error       : out std_logic
    );
end UART;

architecture Behavioral of UART is
constant clk_per_bit : integer := CLK_FREQ / BAUD_RATE;
--RX Signals
type Rx_SM is (R_Idle, R_Start_Bit, R_Data_Bits,R_Stop_Bit, R_Cleanup);-- A state machine for Receiver (RX)
signal R_SM : Rx_SM := R_Idle;-- the default state is Idle state
signal r_Clk_Count : integer range 0 to clk_per_bit-1 := 0;--a counter for clock which is set to 0
signal r_Bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
signal RX_Data   : std_logic := '0';
signal r_output   : std_logic_vector(7 downto 0) := (others => '0');-- a temporary signal to be connected to the output signal
--TX Singals
type Tx_SM is (T_Idle, T_Start_Bit, T_Data_Bits,T_Stop_Bit, T_Cleanup);-- A state machine for Transmitter (TX)
signal T_SM : Tx_SM := T_Idle;-- the default state is Idle state
signal t_Clk_Count : integer range 0 to clk_per_bit-1 := 0;--a counter for clock which is set to 0 
signal t_Bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
signal t_input   : std_logic_vector(7 downto 0) := (others => '0');-- a temporary signal to be connected to the input signal
begin
--------------------------------RX Section------------------------------------------------------------
 --state machine
 UART_RXTX : process (clk)
 begin
	 if rising_edge(clk) then
	 --reinitializing when the reset is driven high
		if rst = '1' then
					R_SM <= R_Idle;
					r_Clk_Count <= 0;
					r_output <= (others => '0');
					r_Bit_Index <= 0;
					RX_Data <= '0';
					T_SM <= T_Idle;
					t_Clk_Count <= 0;
					t_input <= (others => '0');
					t_Bit_Index <= 0;
					dataOut <= (others => '0');
					Tx <= '1'; --idle state
					error <= '0';
					dataOutRdy <= '0';
		end if;
		   --sampling
			RX_Data <= Rx;
			case R_SM is
			  when R_Idle =>
				 dataOutRdy   <= '0';-- data is not ready to be put in the output
				 r_Clk_Count <= 0;
				 r_Bit_Index <= 0;
	 
				 if RX_Data = '0' then     -- Start bit detected
					R_SM <= R_Start_Bit;	-- going to the next state
				 else
					R_SM <= R_Idle;		-- State doesn't change 
				 end if;
			  -- Check middle of start bit to make sure it's still low
			  when R_Start_Bit =>
				 if r_Clk_Count = (clk_per_bit)/2 then
					if RX_Data = '0' then
					  r_Clk_Count <= 0;  -- reset counter since we found the middle
					  R_SM   <= R_Data_Bits;
					else
					  error <= '1';
					  R_SM   <= R_Idle;
					end if;
				 else
					r_Clk_Count <= r_Clk_Count + 1;
					R_SM   <= R_Start_Bit;
				 end if;
			  -- Wait clks_per_bit-1 clock cycles to sample serial data
			  when R_Data_Bits =>
				 if r_Clk_Count < clk_per_bit-1 then
					r_Clk_Count <= r_Clk_Count + 1;
					R_SM   <= R_Data_Bits;
				 else
					r_Clk_Count <= 0;
					r_output(r_Bit_Index) <= RX_Data;
					 
					-- Check if we have sent out all bits
					if r_Bit_Index < 7 then
					  r_Bit_Index <= r_Bit_Index + 1;
					  R_SM   <= R_Data_Bits;
					else
					  r_Bit_Index <= 0;
					  R_SM   <= R_Stop_Bit;
					end if;
				 end if;
			    -- Receive Stop bit. Stop bit = 1
			  when R_Stop_Bit =>
			   if Rx = '1' and STOP_BITS = 1 then
				  error <= '0';
				else
				  error <= '1';--error detection
				end if;
				 -- Wait clks_per_bit-1 clock cycles for Stop bit to finish
				 if r_Clk_Count < clk_per_bit-1 then
					r_Clk_Count <= r_Clk_Count + 1;
					R_SM   <= R_Stop_Bit;
				 else
					dataOutRdy  <= '1'; -- Data is now ready to be put in the output
					r_Clk_Count <= 0;
					dataOut <= r_output;
					R_SM   <= R_Cleanup;
				 end if;
				-- 1 clock cycle for clean up
			  when R_Cleanup =>
			    error <= '0';
				 R_SM <= R_Idle;
			  when others =>
				 R_SM <= R_Idle;
	 
			  end case;
	
--------------------------------TX Section--------------------------------------------------------------------         
      case T_SM is
 
        when T_Idle =>
          t_Clk_Count <= 0;
          t_Bit_Index <= 0;
 
          if dataInRdy = '1' then
            t_input <= dataIn;
            T_SM <= T_Start_Bit;
          else
            T_SM <= T_Idle;
          end if;
		   -- Send out Start Bit. Start bit = 0
        when T_Start_Bit =>
           Tx <= '0';
 
          -- Wait clks_per_bit-1 clock cycles for start bit to finish
          if t_Clk_Count < clk_per_bit-1 then
            t_Clk_Count <= t_Clk_Count + 1;
            T_SM   <= T_Start_Bit;
          else
            t_Clk_Count <= 0;
            T_SM   <= T_Data_Bits;
          end if;
			-- Wait clks_per_bit-1 clock cycles for data bits to finish
        when T_Data_Bits =>
          Tx <= t_input(t_Bit_Index);
           
          if t_Clk_Count < clk_per_bit-1 then
            t_Clk_Count <= t_Clk_Count + 1;
            T_SM   <= T_Data_Bits;
          else
            t_Clk_Count <= 0;
             
            -- Check if we have sent out all bits
            if t_Bit_Index < 7 then
              t_Bit_Index <= t_Bit_Index + 1;
              T_SM   <= T_Data_Bits;
            else
              t_Bit_Index <= 0;
              T_SM   <= T_Stop_Bit;
            end if;
          end if;
			when T_Stop_Bit =>
          if STOP_BITS = 1 then
				Tx <= '1';--integer to string conversion
			 else
				error <= '1';--error detection
				Tx <= '0';--integer to string conversion
			 end if;
          -- Wait clks_per_bit-1 clock cycles for Stop bit to finish
				 if t_Clk_Count < clk_per_bit-1 then
					t_Clk_Count <= t_Clk_Count + 1;
					T_SM   <= T_Stop_Bit;
				 else
					r_Clk_Count <= 0;
					T_SM   <= T_Cleanup;
          end if;
			-- 1 clock cycle for clean up
		  when T_Cleanup =>
          T_SM   <= T_Idle;
			 error <= '0';
        when others =>
          T_SM <= T_Idle;
		end case;
	 end if;
 end process UART_RXTX;
end Behavioral;

