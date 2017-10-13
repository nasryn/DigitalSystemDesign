library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mag_Comp_8Bit is
	Port ( a, b : in STD_LOGIC_VECTOR( 7 downto 0 );
		   out_gt, out_eq, out_lt : out STD_LOGIC);
end Mag_Comp_8Bit;

architecture Behavioral of Mag_Comp_8Bit is

begin

	out_gt <= '1' when a > b else '0';
	out_lt <= '1' when a < b else '0';
	out_eq <= '1' when a = b else '0';

end Behavioral;

entity Temp_Compare is
	Port ( TEMP : in NUMERIC_STD;
		   Lt_96, Lt_105_Gt_96, Et_or_Gt_105 : STD_LOGIC);
end Temp_Compare;

architecture Behavioral of Temp_Compare is

	component Mag_Comp_8Bit is 
		Port ( a, b : in STD_LOGIC_VECTOR( 7 downto 0 );
			   out_gt, out_eq, out_lt : out STD_LOGIC );
	end component;
	
	signal A, B, C, : STD_LOGIC;
	signal AeqB0, AeqB1, AltB0, AltB1, AltB1, AgtB0, AgtB1 : STD_LOGIC;
	
	begin
	
	Compare0: Mag_Comp_8Bit
	port map( a => TEMP;
	          b => to_unsigned(96, 8);
			  out_gt => AgtB0;
			  out_eq => AgtB0;
			  out_lt => AltB0);
	
	Compare1: Mag_Comp_8Bit
	port map( a => TEMP;
			  b => to_unsigned(105, 8);
			  out_gt => AgtB1;
			  out_eq => AeqB1;
			  out_lt => AltB1);
			  
	A <= '1' when ( AltB0 = '1' ) else '0';
	B <= '1' when ((AeqB0 or AgtB0) and AltB1) else '0';
	C <= '1' when (AeqB1 or AgtB1) else '0';
	
end Behavioral;
			  
	
