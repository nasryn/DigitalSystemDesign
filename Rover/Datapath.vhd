library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


-- Datapath entity
entity Datapath is
	Port ( clk 		  			  : IN  STD_LOGIC;
			 INCREMENT          : IN  STD_LOGIC;
			 SSR					  : IN  STD_LOGIC;
			 ENABLE				  : IN  STD_LOGIC;
			 
			 RIGHT_CURVE        : IN  STD_LOGIC_VECTOR(3 downto 0);
			 LEFT_CURVE         : IN  STD_LOGIC_VECTOR(3 downto 0);
			 RIGHT_DIR			  : IN  STD_LOGIC_VECTOR(1 downto 0);
			 LEFT_DIR			  : IN  STD_LOGIC_VECTOR(1 downto 0);
			 LEFT_QUAD		     : IN  STD_LOGIC_VECTOR(1 downto 0);
			 RIGHT_QUAD         : IN  STD_LOGIC_VECTOR(1 downto 0);
			 DISTANCE			  : IN  STD_LOGIC_VECTOR(12 downto 0);
			 CHANGE_SPEED		  : IN  STD_LOGIC_VECTOR(1 downto 0);
			 DUTY_CYCLE_SET     : IN  STD_LOGIC;
	 
			 FINISH_ACCEL		  : OUT  STD_LOGIC;
			 FINISH             : OUT  STD_LOGIC;
			 FINISH_PROG        : OUT	STD_LOGIC;
			 RIGHT_MOTOR	     : OUT  STD_LOGIC_VECTOR(1 downto 0);
			 LEFT_MOTOR    	  : OUT  STD_LOGIC_VECTOR(1 downto 0);
			 INSTRUCT_CODE		  : OUT  STD_LOGIC_VECTOR(15 downto 0)

			);
end Datapath;


architecture Behavioral of DataPath is

	COMPONENT Instruction_Mem
	PORT(
		clk : IN std_logic;
		enable : IN std_logic;
		SSR : IN std_logic;
		addr : IN std_logic_vector(2 downto 0);          
		data_out : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	signal right_total_ticks, left_total_ticks : unsigned(12 downto 0) := (others => '0') ;
	signal old_right_quad, old_left_quad: STD_LOGIC_VECTOR(1 downto 0);
	
	signal avg_ticks 	: unsigned(12 downto 0) := (others => '0');
	signal Counter  	: unsigned(13 downto 0) := (others => '0');
	signal addr_reg 	: unsigned(2 downto 0)  := (others => '0');
	signal curr_speed	: unsigned(3 downto 0)  := (others => '0');
	signal duty_cycle	: unsigned(3 downto 0)  := (others => '0');
	signal finish_accel_reg : std_logic := '0';


	begin

		Instruction_Mem0: Instruction_Mem PORT MAP(
		clk => CLK,
		enable => ENABLE,
		SSR => SSR,
		addr => std_logic_vector(addr_reg),
		data_out => INSTRUCT_CODE 
		);
		
		-- Program Counter
		process(clk)
		begin
			if rising_edge(clk) then
				FINISH_PROG <= '0';
				if addr_reg >= to_unsigned(7, 3) then
					FINISH_PROG <= '1';
				elsif Increment = '1' then
					addr_reg <= addr_reg + 1;
				end if;
			end if;
			--ADDR <= std_logic_vector(addr_reg);
		end process;
					
		
		-- Sets (& incrememts) duty cycle
		process(clk)
		begin
			if rising_edge(clk) then
				if duty_cycle_set = '1' then
					-- Set Duty cyle to ten so we count down when we decellereate
					if change_speed = "10" then
						duty_cycle <= "1010";
					-- Set dutycycle to 0 when we want to count up to accelerate
					else
						duty_cycle <= "0000";
					end if;
				-- Increses duty cycle between pulses
				elsif change_speed = "01" then
					duty_cycle <= duty_cycle + 1;
				elsif change_speed = "10" then
					duty_cycle <= duty_cycle - 1;
				end if;
			end if;
		end process;
		
		finish_accel_reg <= '1' when (duty_cycle >= 10) and (change_speed = "01") else
								  '1' when (duty_cycle <= 0) and (change_speed = "10") else '0';
		FINISH_ACCEL <= finish_accel_reg;
		
		-- Check right motor
		process(clk)
		
		begin
			if rising_edge(clk) then 
					if old_right_quad /= RIGHT_QUAD then
						right_total_ticks <= right_total_ticks + 1;
						
						if right_total_ticks > unsigned(DISTANCE) then
							right_total_ticks <= "0000000000000";
						end if;
						
						old_right_quad <= RIGHT_QUAD;
					
					end if;
			end if;
		end process;
		
		
		-- Check left motor
		process(clk)
		begin
			if rising_edge(clk) then
					if old_left_quad /= LEFT_QUAD then
						left_total_ticks <= left_total_ticks + 1;
						
						if left_total_ticks > unsigned(DISTANCE) then
							left_total_ticks <= "0000000000000";
						end if;
						
						old_left_quad <= LEFT_QUAD;	
					end if;
			end if;
		end process;
	
		
		-- Moves motors depending on curve coefficients
		-- Speed is selected by duty_cycle
		-- 45 ticks = 1 inch
		-- 252 ticks = 45 degrees
		
		process(clk)
		begin
			if rising_edge(clk) then
				if curr_speed <duty_cycle then
					
					while unsigned(LEFT_CURVE)*left_total_ticks > unsigned(RIGHT_CURVE)*right_total_ticks loop
						LEFT_MOTOR <= "11";
					end loop;
					while unsigned(RIGHT_CURVE)*right_total_ticks > unsigned(LEFT_CURVE)*left_total_ticks loop
						RIGHT_MOTOR <= "11";
					end loop;
					
					RIGHT_MOTOR <= RIGHT_DIR;
					LEFT_MOTOR <= LEFT_DIR;
				
				elsif curr_speed >= 10 then
					curr_speed <= "0000";
				else
					RIGHT_MOTOR <= "00";
					LEFT_MOTOR  <= "00";
					curr_speed <= curr_speed + 1;
					
				end if;
			end if;
		end process;
					
		-- Multiply by 24 to convert to inches
		avg_ticks <= (unsigned(left_total_ticks) + unsigned(right_total_ticks))/(2);
		
		FINISH <= '1' when avg_ticks >= 24 * unsigned(DISTANCE) else '0';	
		
end Behavioral;










