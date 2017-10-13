library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library std;
use std.textio.all;


entity Instruction_Mem is
	Generic (data_width    : positive := 16; 
				num_addr_bits : positive := 3);
	Port ( clk      : in  STD_LOGIC;
			 enable   : in  STD_LOGIC;
			 SSR      : in  STD_LOGIC;
			 addr     : in  STD_LOGIC_VECTOR (num_addr_bits-1 downto 0);
		    
			 data_out : out STD_LOGIC_VECTOR (data_width-1 downto 0));
end Instruction_Mem;

architecture Behavioral of Instruction_Mem is
	type instr_ROM_type is array(0 to 2**num_addr_bits-1) 
								  of bit_vector(data_width-1 downto 0);
								  
	impure function init_ROM(file_name: in string)
													return instr_ROM_type is 
													
	FILE rom_file : text is in file_name;                       
	variable instruction : line;                                 
	variable instr_ROM   : instr_ROM_type;   

	begin 
		for I in instr_ROM_type'range loop                                  
			readline(rom_file, instruction);                          
			read(instruction, instr_ROM(I));                                  
		end loop;  
		return instr_ROM;	
	end function;       
	
	constant instr_ROM : instr_ROM_type := init_ROM("instructions.txt");
	
	
	--  Choose to load with values or zero's
	begin
	process(clk)
		begin
			if rising_edge(clk) then
				if SSR = '1' then
					data_out <= (others => '0');
				elsif enable = '1' then
					data_out <= to_stdlogicvector(instr_ROM(to_integer(unsigned(addr))));
				end if;
			end if;			
	end process;
	
end Behavioral;	
