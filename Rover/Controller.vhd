library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Controller is
	Port ( clk            : IN  STD_LOGIC;
			 INSTRUCT_CODE	 : IN  STD_LOGIC_VECTOR(15 downto 0);
			 FINISH			 : IN  STD_LOGIC; 
			 FINISH_PROG	 : IN  STD_LOGIC;
			 FINISH_ACCEL   : IN  STD_LOGIC;
			 
			 INCREMENT		 : OUT STD_LOGIC;
			 SSR				 : OUT STD_LOGIC;
			 ENABLE			 : OUT STD_LOGIC;
			 
			 CHANGE_SPEED	 : OUT STD_LOGIC_VECTOR(1 downto 0);
			 DUTY_CYCLE_SET : OUT  STD_LOGIC;
			 
			 RIGHT_DIR		 : OUT STD_LOGIC_VECTOR(1 downto 0);
			 LEFT_DIR		 : OUT STD_LOGIC_VECTOR(1 downto 0);
			 RIGHT_CURVE    : OUT STD_LOGIC_VECTOR(3 downto 0);
			 LEFT_CURVE     : OUT STD_LOGIC_VECTOR(3 downto 0);
			 DISTANCE       : OUT STD_LOGIC_VECTOR(12 downto 0);
			 LED			  	 : OUT std_logic_vector(7 downto 0)

			);
end Controller;

architecture Behavioral of Controller is

-- Robot States
type robot_state_type is (Init, Fetch, Decode, Move, Rotate, Adjust_speed, Accelerate, Speed_Inc, Decel, Speed_Dec, Addr_Inc, Stop);
signal robot_state, robot_next_state : robot_state_type;


signal opcode    : std_logic_vector(1 downto 0);

-- Direction and Distance Signals
signal direction  : std_logic;
signal distance_reg : std_logic_vector(12 downto 0);



begin


	process(clk, robot_state)
	begin
		if rising_edge(clk) then
			robot_state  <= robot_next_state;
		end if;
	end process;


	-- FSM of Shift Counter 
	process(robot_state, Instruct_Code)
			  
		begin
			robot_next_state <= Init;
			
			case robot_state is
				when Init => 
					LED <= "10000000";
					
					SSR <= '0';
					Enable <= '0';
					Increment <= '0';
					
					robot_next_state <= Fetch;
				
				
				when Fetch =>
					LED <= "11000000";
					ENABLE  <= '0';
					
					if Finish_Prog = '1' then
						ENABLE  <= '0';
						SSR	  <= '1';
						robot_next_state <= Stop;
					
					elsif Finish_Prog = '0' then
						ENABLE  <= '1';
						SSR     <= '0';
						robot_next_state <= Decode;
	
					else
						robot_next_state <= robot_next_state;
					
					end if;
					
				
				when Decode =>
					LED <= "11100000";
					
					-- Parse opcode
					opcode    <= Instruct_Code(15 downto 14);

					-- Parse signals
					direction <= Instruct_Code(13);
					distance_reg  <= Instruct_Code(12 downto 0);
					
					Increment <= '1';
					--wait for 10 ns;
					
					if opcode = "00" then
						robot_next_state <= Stop;
					elsif opcode = "11" then
						robot_next_state <= Move;
					elsif opcode = "10" then
						robot_next_state <= Rotate;
					elsif opcode = "01" then
						robot_next_state <= Adjust_speed;
					else
						robot_next_state <= robot_next_state;
					end if;
				
				when Addr_Inc =>
					Increment <= '1';
					-- Address = Address + 1;
					robot_next_state <= Fetch;
					
				when Stop =>
					LED <= "11110000";
					
    				if FINISH_PROG = '0' then
						robot_next_state <= Fetch after 25000ms;
					end if;
					
					
					
				when Move =>
					LED <= "11111000";

					-- Motors will move at variable speed/acceleration and either forward or reverse
					if FINISH = '1' then
						RIGHT_DIR <= "11";
						LEFT_DIR <= "11";
						robot_next_state <= STOP;
					else
						RIGHT_DIR <= "10";
						LEFT_DIR <= "10";
						RIGHT_CURVE <= "0001";
						LEFT_CURVE  <= "0001";
						DISTANCE <= distance_reg;
						robot_next_state <= Move;
					end if;
						
				when Rotate =>
					LED <= "11111100";

					-- Motors will rotate opposite directions but in place
					if FINISH = '1' then
						RIGHT_DIR <= "11";
						LEFT_DIR <= "11";
						robot_next_state <= STOP;
					end if; 
					
					if direction = '1' then
						RIGHT_DIR <= "10";
						LEFT_DIR  <= "01";
					else 
						RIGHT_DIR <= "01";
						LEFT_DIR  <= "10";
					end if;
					
					RIGHT_CURVE <= "0001";
					LEFT_CURVE  <= "0001";
					DISTANCE <= distance_reg;
					
					robot_next_state <= robot_next_state;
					
				when Adjust_speed =>
				
					-- Accelerate Forward when direction '1'
					if direction = '1' then
						robot_next_state <= Accelerate;
					-- Accelerate Backwards when direction '0'
					else
						robot_next_state <= Decel;
					end if;
				
				when Accelerate =>
					LED <= "11111110";
					change_speed <= "00";
						
					DISTANCE <= distance_reg;

					if FINISH = '0' then
						robot_next_state <= Accelerate;
					elsif (FINISH = '1') and (Finish_Accel = '0') then
						robot_next_state <= Speed_Inc;
					elsif (FINISH = '1') and (FINISH_ACCEL = '1') then
						robot_next_state <= STOP;
					else
						robot_next_state <= robot_next_state;
					end if;
					
				when Speed_Inc =>
						change_speed <= "01";
						robot_next_state <= Accelerate;
					
				when Decel =>
					if FINISH = '0' then
						robot_next_state <= Decel;
					elsif (FINISH = '1') and (Finish_Accel = '0') then
						robot_next_state <= Speed_Dec;
					elsif FINISH = '1' and FINISH_ACCEL = '1' then
						robot_next_state <= STOP;
					else
						robot_next_state <= robot_next_state;
					end if;
					
				when Speed_Dec =>
						change_speed <= "10";
						robot_next_state <= Decel;
						
				when others =>
					LED <= "10010010";
					robot_next_state <= Init;--robot_next_state;
			end case;		
		end process;
		
end Behavioral;