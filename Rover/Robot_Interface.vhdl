library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Robot_Interface is
    Port ( clk 				: in  STD_LOGIC;
			  Right_quad      : in  STD_LOGIC_VECTOR(1 downto 0);
			  Left_quad       : in  STD_LOGIC_VECTOR(1 downto 0);
			  
			  Right_motor		: out STD_Logic_vector(1 downto 0);
			  Left_motor      : out std_logic_vector(1 downto 0);
			  LED					: OUT std_logic_vector(7 downto 0)

         );
end Robot_Interface;

architecture Behavioral of Robot_Interface is

-- ########## Your Component and Signal Declarations ###########

	signal finish_reg : std_logic;
	signal right_dir_reg, left_dir_reg : std_logic_vector(1 downto 0);
	signal right_curve_reg, left_curve_reg : std_logic_vector(3 downto 0);
	signal distance_reg : std_logic_vector(12 downto 0);
	signal curve_dir_reg : std_logic_vector(1 downto 0);
	signal finish_prog: std_logic;
	signal increment_reg : std_logic;
	signal change_speed_reg : std_logic_vector(1 downto 0);
	signal enable_reg, ssr_reg : std_logic;
	signal instruct_code_reg : std_logic_vector (15 downto 0);
	signal duty_set_reg : std_logic;
	signal finish_accel_reg : std_logic;

	COMPONENT Controller
	PORT(
		clk 				: IN std_logic;
		Instruct_Code  : IN std_logic_vector(15 downto 0);
		FINISH 			: IN std_logic; 
		FINISH_PROG    : IN std_logic;
		FINISH_ACCEL   : IN std_logic;
		
		SSR				: OUT STD_LOGIC;
		ENABLE			: OUT STD_LOGIC;
		INCREMENT		: OUT STD_LOGIC;
		CHANGE_SPEED   : OUT STD_LOGIC_VECTOR(1 downto 0);
		DUTY_CYCLE_SET : OUT STD_LOGIC;
		
		RIGHT_DIR 		: OUT std_logic_vector(1 downto 0);
		LEFT_DIR 		: OUT std_logic_vector(1 downto 0);
		RIGHT_CURVE 	: OUT std_logic_vector(3 downto 0);
		LEFT_CURVE 		: OUT std_logic_vector(3 downto 0);
		DISTANCE 		: OUT std_logic_vector(12 downto 0);
		LED				: OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Datapath
	PORT(
		clk 					: IN std_logic;
		INCREMENT         : IN std_logic;
		SSR					: IN std_logic;
		ENABLE				: IN std_logic;
		RIGHT_CURVE 		: IN std_logic_vector(3 downto 0);
		LEFT_CURVE 			: IN std_logic_vector(3 downto 0);
		RIGHT_DIR 			: IN std_logic_vector(1 downto 0);
		LEFT_DIR 			: IN std_logic_vector(1 downto 0);
		LEFT_QUAD		 	: IN std_logic_vector(1 downto 0);
		RIGHT_QUAD 			: IN std_logic_vector(1 downto 0);
		DISTANCE 			: IN std_logic_vector(12 downto 0); 
		
		CHANGE_SPEED  		: IN STD_LOGIC_VECTOR(1 downto 0);
		DUTY_CYCLE_SET    : IN STD_LOGIC;
		
		FINISH_ACCEL      : OUT std_logic;
		FINISH 				: OUT std_logic;
		FINISH_PROG       : OUT std_logic;
		INSTRUCT_CODE		: OUT std_logic_vector(15 downto 0);
		RIGHT_MOTOR 		: OUT std_logic_vector(1 downto 0);
		LEFT_MOTOR 			: OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;



-- #############################################################

begin

-- ########## Your Component Instantiations with ###############
-- ############### with Signal Connections #####$###############

	Controller0: Controller PORT MAP(
		clk => CLK,
		Instruct_Code => instruct_code_reg,
		FINISH 		  => finish_reg,
		SSR			  => ssr_reg,
		ENABLE		  => enable_reg,
		INCREMENT     => increment_reg,
		FINISH_ACCEL  => finish_accel_reg,
		
		CHANGE_SPEED  => change_speed_reg,
		DUTY_CYCLE_SET=> duty_set_reg,
		
		RIGHT_DIR     => right_dir_reg,
		LEFT_DIR      => left_dir_reg,
		RIGHT_CURVE   => right_curve_reg,
		LEFT_CURVE    => left_curve_reg,
		DISTANCE      => distance_reg,
		LED			  => LED,
		FINISH_PROG   => finish_prog

	);
	
	
	Datapath0: Datapath PORT MAP(
		clk 			  => CLK,
		SSR			  => ssr_reg,
		ENABLE		  => enable_reg,
		INCREMENT     => increment_reg,
		INSTRUCT_CODE => instruct_code_reg,
		RIGHT_CURVE   => right_curve_reg,
		LEFT_CURVE 	  => left_curve_reg,
		RIGHT_DIR 	  => right_dir_reg,
		LEFT_DIR 	  => left_dir_reg,
		LEFT_QUAD 	  => Left_quad,
		RIGHT_QUAD    => Right_quad,
		
		CHANGE_SPEED  => change_speed_reg,
		DUTY_CYCLE_SET=> duty_set_reg,
		
		FINISH_ACCEL  => finish_accel_reg,
		DISTANCE 	  => distance_reg,
		FINISH 	     => finish_reg,
		RIGHT_MOTOR   => Right_motor,
		LEFT_MOTOR 	  => Left_motor,
		FINISH_PROG	  => finish_prog
	);

-- #############################################################

end Behavioral;