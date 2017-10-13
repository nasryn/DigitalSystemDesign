---------------------------------------------------------------------------------- 
-- Module Name:    TopLevel - Behavioral 
-- Project Name:   Rover
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Company: Binghamton University
-- Engineer: Nasryn El-Hinnawi
-- 
-- Design Name: 
-- Module Name:    TopLevel - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopLevel is
    Port ( CLK 					: in  STD_LOGIC;
			  LEFT_QUAD 			: in  STD_LOGIC_VECTOR (1 downto 0);
           RIGHT_QUAD 			: in  STD_LOGIC_VECTOR (1 downto 0);
			  
			  LEFT_MOTOR 			: out  STD_LOGIC_VECTOR (1 downto 0);
           RIGHT_MOTOR			: out  STD_LOGIC_VECTOR (1 downto 0);
			  LED						: out  STD_LOGIC_VECTOR(7 downto 0)
     );
end TopLevel;

architecture Behavioral of TopLevel is


COMPONENT Robot_Interface
PORT(
	clk : IN std_logic;
	Right_quad : IN std_logic_vector(1 downto 0);
	Left_quad : IN std_logic_vector(1 downto 0); 
	LED		 : OUT std_logic_vector(7 downto 0);
	Right_motor : OUT std_logic_vector(1 downto 0);
	Left_motor : OUT std_logic_vector(1 downto 0)

	);
END COMPONENT;

signal Counter    : unsigned(11 downto 0) := (others => '0');
signal instr_reg  : std_logic_vector(15 downto 0);
signal addr_reg   : std_logic_vector(2 downto 0);
signal ssr_reg    : std_logic;
signal enable_reg : std_logic;



begin


	

Robot_Interface0: Robot_Interface PORT MAP(
	clk 			  => clk,
	Right_quad 	  => RIGHT_QUAD,
	Left_quad     => LEFT_QUAD,
	Right_motor   => RIGHT_MOTOR,
	Left_motor    => LEFT_MOTOR,
	LED  			  => LED
);


end Behavioral;
