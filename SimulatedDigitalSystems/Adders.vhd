-- Adders

library ieee;
use ieee.std_logic.all;

entity Half_Adder is
	Port ( a : in STD_LOGIC;
		   b : in STD_LOGIC;
		   s : out STD_LOGIC;
		   co : out STD_LOGIC);
end Half_Adder;

architecture Behavioral of Half_Adder is
begin
	s <= a xor b;
	co <= a and b;
end Behavioral;

entity Full_Adder is
	Port ( a : in STD_LOGIC;
		   b : in STD_LOGIC;
		   ci : in STD_LOGIC;
		   s : out STD_LOGIC;
		   co : out STD_LOGIC);
end Full_Adder;
architecture Behavioral of Full_Adder is
begin
	s <= a xor b xor ci;
	co <= (a and b) or (a and ci)
	or (b and ci);
end Behavioral;

entity Adder8Bit is
	Port ( a: in std_logic_vector( 7 downto 0 );
		   b: in std_logic_vector( 7 downto 0 );
		   co: out std_logic;
		   s: out std_logic);
end Adder8Bit;

architecture Behavioral of Adder8Bit is
	component Half_Adder
		Port( a: in std_logic;
			  b: in std_logic;
			  s: out std_logic;
			  co: out std_logic);
	end component;
	
	component Full_Adder
		Port( a: in std_logic;
			  b: in std_logic;
			  ci: in std_logic;
			  s: out std_logic;
			  co: out std_logic);
	end component;
	
	-- define signals for the carriers for the carries between adder components
	signal c01, c12, c23, c34, c45, c56, 67: std_logic;
	
	begin
		Add0: Half_Adder
		port map( a  => a(0),
				  b  => b(0),
				  s  => s(0),
				  co => c01);
		   
		Add1: Full_Adder
		port map( a  => a(1),
				  b  => b(1),
				  s  => s(1),
				  co => c12);
				  
		Add2: Full_Adder
		port map( a  => a(2),
				  b  => b(2),
				  s  => s(2),
				  co => c23);
				  
		Add3: Full_Adder
		port map( a  => a(3),
				  b  => b(3),
				  s  => s(3),
				  co => c34);
				  
		Add4: Full_Adder
		port map( a  => a(4),
				  b  => b(4),
				  s  => s(4),
				  co => c45);
				  
		Add5: Full_Adder
		port map( a  => a(5),
				  b  => b(5),
				  s  => s(5),
				  co => c56);
				  
		Add6: Full_Adder
		port map( a  => a(6),
				  b  => b(6),
				  s  => s(6),
				  ci => c67,
				  co => co);
end Behavioral;

entity AddThree8BitNumbers is
	Port( a: in std_logic_vector( 7 downto 0 );
		  b: in std_logic_vector( 7 downto 0 );
		  c: in std_logic_vector( 7 downto 0 );
		  s: out std_logic_vector( 7 downto 0 ));
		  s2: out std_logic;
end entity;

architecture Behavioral of AddThree8BitNumbers is
	component Adder8Bit
		Port ( a: in std_logic_vector( 7 downto 0 );
		       b: in std_logic_vector( 7 downto 0 );
		       co: out std_logic;
		       s: out std_logic);
	end component;
	
	component Half_Adder
		Port( a: in std_logic;
			  b: in std_logic;
			  s: out std_logic;
			  co: out std_logic);
	end component;
	
	-- define intermediate sums and carry outs
	signal cab, cbc, co: std_logic;
	signal s0, s1: std_logic_vector( 7 downto 0 );
	
	Add0: Adder8Bit
		port map( a => a,
				  b => b,
				  co => cab,
				  s => s0);
	
	Add1: Adder8Bit
		port map( a  => s0,
				  b  => c,
				  co => cbc,
				  s  => s1);
	
	Add2: Half_Adder
		port map( a  => cab,
				  b  => cbc,
				  s  => s2,
				  co => co);
end Behavioral;