library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
entity PacketChecker is
    generic (
        header : std_logic_vector(7 downto 0) := x"00"
    );
    Port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        dataIn      : in  std_logic_vector(7 downto 0);
        dataInRdy   : in  std_logic;
        dataOut     : out std_logic_vector(7 downto 0);
        dataOutRdy  : out std_logic;
        wrAddress   : out std_logic_vector(15 downto 0);
        wrData      : out std_logic_vector(31 downto 0);
        wrEn        : out std_logic;
        rdAddress   : out std_logic_vector(15 downto 0);
        rdData      : in  std_logic_vector(31 downto 0);
        rdRdy       : in  std_logic;
        rdEn        : out std_logic;
        error       : out std_logic
		);
end PacketChecker;

architecture Behavioral of PacketChecker is
signal state : integer range 0 to 27 := 0;--we have 28 states
signal current_header : std_logic_vector(7 downto 0);
signal current_command     : std_logic_vector(7 downto 0);
signal current_address     : std_logic_vector(15 downto 0);
signal current_data        : std_logic_vector(31 downto 0);
signal CheckSum     : std_logic_vector(15 downto 0);
signal CheckSumm    : std_logic_vector(15 downto 0);
signal tmp    : std_logic_vector(63 downto 0) := (others => '0');--a 64-bit temporary register to store data from RAM
begin
    process(clk)
    begin
        if rst = '1' then
				dataOut <= (others => '0');
				wrAddress <= (others => '0');
				wrData <= (others => '0');
				rdAddress <= (others => '0');
            state <= 0;
            current_header <= (others => '0');
            current_command <= (others => '0');
            current_address <= (others => '0');
            current_data <= (others => '0');
				CheckSum <= (others => '0');
				CheckSumm <= (others => '0');
				tmp <= (others => '0');
            dataOutRdy <= '0';
            wrEn <= '0';
            rdEn <= '0';
            error <= '0';
        elsif rising_edge(clk) then
            case state is
                when 0 => --header block
                    if dataInRdy = '1' then
								wrEn <= '0';
								rdEn <= '0';
								CheckSum <= (others => '0');
								CheckSumm <= (others => '0');
								dataOutRdy <= '0';
                        current_header <= dataIn;
                        if current_header = header then
                            state <= 1;
                        else
                            state <= 0;
                        end if;
                    end if;
					 when 1 =>
						  if dataInRdy = '1' then
								current_command <= dataIn;
								if dataIn = x"00" then -- Write command
									 state <= 2;
								elsif dataIn = x"FF" then -- Read command
									 state <= 11;
								else
									 state <= 0;
								end if;
						  end if;
---------------------------------Write Command Section----------------------------------------------
					 --writing address for data to be put on RAM 
                when 2 => --AddrH
                    if dataInRdy = '1' then
                        current_address(15 downto 8) <= dataIn;
                        state <= 3;
                    end if;
                when 3 => --AddrL
                    if dataInRdy = '1' then
                        current_address(7 downto 0) <= dataIn;
                        current_data <= (others => '0');
                        state <= 4;
                    end if;
					  --writing data on RAM
					  when 4 =>--Data 4
						  if dataInRdy = '1' then
						   current_data(31 downto 24) <= dataIn;
							state <= 5;
						  end if;
					  when 5 =>--Data 3
						  if dataInRdy = '1' then
						   current_data(23 downto 16) <= dataIn;
							state <= 6;
						  end if;
					  when 6 =>--Data 2
						  if dataInRdy = '1' then
						   current_data(15 downto 8) <= dataIn;
							state <= 7;
						  end if;
					  when 7 =>--Data 1
						  if dataInRdy = '1' then
						   current_data(7 downto 0) <= dataIn;
						   state <= 8;
						  end if;
						when 8 =>--check for error(CheckSumH)
							if dataInRdy = '1' then
								CheckSum <= std_logic_vector(unsigned("00000000" & current_header) + unsigned("00000000" & current_command) + unsigned("00000000" & current_Data(31 downto 24)) + unsigned("00000000" & current_Data(23 downto 16)) + unsigned("00000000" & current_Data(15 downto 8)) + unsigned("00000000" & current_Data(7 downto 0)) + unsigned("00000000" & current_address(15 downto 8)) + unsigned("00000000" & current_address(7 downto 0)));
								CheckSumm(15 downto 8) <= dataIn;
								state <= 9;
							 end if;
						when 9 =>--Check for error(CheckSumL)
							if dataInRdy = '1' then
								CheckSumm(7 downto 0) <= dataIn;
								state <= 10;
							end if;
						when 10 =>
								if CheckSum = CheckSum then
									wrAddress <= current_address;
									wrData <= current_Data;
									wrEn <= '1';--now data is ready!
									state <= 0;--back to square one!
									error <= '0'; --no error!
								else
									error <= '1';--error detected
									state <= 0;
								end if;
							
--------------------------------------------Read command section------------------------------------------
					  when 11 =>--AddrH
							if dataInRdy = '1' then
                        current_address(15 downto 8) <= dataIn;
                        state <= 12;
                    end if;
							    
                 when 12 =>--AddrL
                    if dataInRdy = '1' then
                        current_address(7 downto 0) <= dataIn;
                        state <= 13;
                    end if;
						when 13 =>--check for errors(CheckSumH)
							if dataInRdy = '1' then
								CheckSum <= std_logic_vector(unsigned("00000000" & current_header) + unsigned("00000000" & current_command) + unsigned("00000000" & current_address(15 downto 8)) + unsigned("00000000" & current_address(7 downto 0)));
								CheckSumm(15 downto 8) <= dataIn;
								state <= 14;
							 end if;
						when 14 =>--check for errors(CheckSumL)
							if dataInRdy = '1' then
								CheckSumm(7 downto 0) <= dataIn;
								state <= 15;
							end if;
						when 15 =>
								if CheckSum = CheckSumm then
									rdAddress <= current_address;
									rdEn <= '1';--now data is ready in RAM!
									state <= 16;--go to Read Response!
									error <= '0'; --no error!
								else
									error <= '1';--error detected
									state <= 0;--back to square one
								end if;
						
---------------------------------Read Response Section-----------------------------------------------
					   when 16 =>--receive data from RAM(1st round)
							if rdRdy = '1' then 
								tmp(63 downto 32) <= rdData;
								state <= 17;
							end if;
						when 17 =>--receive data from RAM(2nd round)
							if rdRdy = '1' then 
								tmp(31 downto 0) <= rdData;
								state <= 18;
							end if;
						when 18 =>
								CheckSum <= std_logic_vector(unsigned("00000000" & tmp(63 downto 56)) + unsigned("00000000" & tmp(55 downto 48)) + unsigned("00000000" & tmp(47 downto 40)) + unsigned("00000000" & tmp(39 downto 32)) + unsigned("00000000" & tmp(31 downto 24)) + unsigned("00000000" & tmp(23 downto 16)));
								CheckSumm <= tmp(15 downto 0);
								state <= 19;
							
						when 19 =>--check if we have packet loss
								if CheckSum = CheckSumm then
									error <= '0';--data is not corrupted
									state <= 20;
								else
									error <= '1';--error detected
									state <= 0;--back to square 1
								end if;
							
						--send data out from tmp register
						when 20 =>--header byte
							dataOut <= tmp(63 downto 56);
							dataOutRdy <= '1';
							state <= 21;
						when 21 =>--command byte
							dataOut <= tmp(55 downto 48);
							state <= 22;
						when 22 =>--Data 4
								dataOut <= tmp(47 downto 40);
								state <= 23;
						when 23 =>--Data 3
							   dataOut <= tmp(39 downto 32);
								state <= 24;
						when 24 =>--Data 2
								dataOut <= tmp(31 downto 24);
								state <= 25;
						when 25 =>--Data 1
								dataOut <= tmp(23 downto 16);
								state <= 26;
						when 26 =>--CheckSumH
								dataOut <= tmp(15 downto 8);
								state <= 27;
						when 27 =>--CheckSumL
							   dataOut <= tmp(7 downto 0);
								state <= 0;--getting ready to receive new data
                  when others =>
                    null;

            end case;
        end if; 
    end process;
end Behavioral;