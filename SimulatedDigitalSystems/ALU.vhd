library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ALU Extender Slicer
entity oneBitSlicer is
	PORT ( a, b, al, ar : in std_logic;
		            xyz : in std_logic_vector(2 downto 0);
		         ai, bi : out std_logic);
end entity;

architecture Behavioral of oneBitSlicer is 
begin
	ai <= a when ((xyz = "000") or (xyz = "001")) else
		 al when xyz = "010" else
		 ar when xyz = "011" else
		 (a and b) when xyz = "100" else
		 (a xor b) when xyz = "101" else
	     (a  or b) when xyz = "110" else
		 (  not a);
	
	bi <= b  when  xyz = "000"  else
	 (not b) when  xyz = "001"  else '0';

end Behavioral;

-- CIN entity
entity cinSlice is
	PORT ( xyz : in std_logic_vector(2 downto 0);
		   cin : out std_logic);
end entity;

architecture Behavioral of cinSlice is
begin
	cin <= '1' when xyz = "001" else '0';
end Behavioral;

-- ALU entity
entity ALU is
	PORT ( a, b :  in std_logic_vector(7 downto 0);
		   xyz  :  in std_logic_vector(2 downto 0);
		   sum  : out std_logic_vector(8 downto 0));
end entity;

architecture Behavioral of ALU is

component oneBitSlicer is
	PORT ( a, b, al, ar  :  in std_logic;
		   xyz           :  in std_logic_vector(2 downto 0);
		   ai, bi        : out std_logic);
end compenent;

component cinSlice is
	PORT ( xyz : in std_logic_vector(2 downto 0);
		   cin : out std_logic);
end component;

component Adder8Bit is
PORT( a : IN std_logic_vector(7 downto 0);
	  b : IN std_logic_vector(7 downto 0);
     ci : IN std_logic;
      s : OUT std_logic_vector(7 downto 0);
     co : OUT std_logic);
end component;

signal   IA, IB : std_logic_vector(7 downto 0);
signal  	cin : std_logic;

begin


	A0Bit: oneBitSlicer
	port map ( a  => a(0),
			   b  => b(0),
			   al => a(1),
			   ar =>  '0',
			   xyz => xyz,
			   ai => IA(0),
			   bi => IB(0));
			   

	A1Bit: oneBitSlicer
	port map ( a   => a(1),
			   b   => b(1),
			   al  => a(2),
			   ar  => a(0),
			   xyz => xyz,
			   ai  => IA(1),
			   bi  => IB(1));
	

	A2Bit: oneBitSlicer
	port map ( a  => a(2),
			   b  => b(2),
			   al => a(3),
			   ar => a(1),
			   xyz => xyz,
			   ai => IA(2),
			   bi => IB(2));
	

	A3Bit: oneBitSlicer
	port map ( a   => a(3),
			   b   => b(3),
			   al  => a(4),
			   ar  => a(2),
			   xyz => xyz,
			   ai  => IA(3),
			   bi  => IB(3));
	
	
	A4Bit: oneBitSlicer
	port map ( a   => a(4),
			   b   => b(4),
			   al  => a(5),
			   ar  => a(3),
			   xyz => xyz,
			   ai  => IA(4),
			   bi  => IB(4));

	A5Bit: oneBitSlicer
	port map ( a   => a(5),
			   b   => b(5),
			   al  => a(6),
			   ar  => a(4),
			   xyz => xyz,
			   ai  => IA(5),
			   bi  => IB(5));
			   
			   
	A6Bit: oneBitSlicer
	port map ( a   => a(6),
			   b   => b(6),
			   al  => a(7),
			   ar  => a(5),
			   xyz => xyz,
			   ai  => IA(6),
			   bi  => IB(6));

			   
	A7Bit: oneBitSlicer
	port map ( a   => a(7),
			   b   => b(7),
			   al  => a(8),
			   ar  => a(6),
			   xyz => xyz,
			   ai  => IA(7),
			   bi  => IB(7));
	
	
	Cin: cinSlice
	port map ( xyz => xyz,
			   cin => cin);

			   
	Sum: Adder8Bit
	port map ( a  => IA,
			   b  => IB,
			   ci => cin,
			   s  => s(7 downto 0),
			   co => s(8));
	
end Behavioral;
