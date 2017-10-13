--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:18:19 12/12/2015
-- Design Name:   
-- Module Name:   
-- Project Name:  Rover
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TopLevel
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Test_Topl_Level IS
END Test_Topl_Level;
 
ARCHITECTURE behavior OF Test_Topl_Level IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TopLevel
    PORT(
         CLK : IN  std_logic;
         LEFT_QUAD : IN  std_logic_vector(1 downto 0);
         RIGHT_QUAD : IN  std_logic_vector(1 downto 0);
         LEFT_MOTOR : OUT  std_logic_vector(1 downto 0);
         RIGHT_MOTOR : OUT  std_logic_vector(1 downto 0);
         LED : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal LEFT_QUAD : std_logic_vector(1 downto 0) := (others => '0');
   signal RIGHT_QUAD : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal LEFT_MOTOR : std_logic_vector(1 downto 0);
   signal RIGHT_MOTOR : std_logic_vector(1 downto 0);
   signal LED : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	
--	-- Quad Test Data
--	type quad_data_record is record 
--		right_quad_data : std_logic_vector(1 downto 0);
--		left_quad_data	 : std_logic_vector(1 downto 0);
--	end record;
--	
--	type quad_data_type is array (natural range <>) of quad_data_record;
--	
--	constant test_quad_data : quad_data_type := 
--		(
--			("01" , "01"),
--			("10" , "10"),
--			("01" , "01"),
--			("11" , "11"),
--			("00" , "00")
--		);
-- 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TopLevel PORT MAP (
          CLK => CLK,
          LEFT_QUAD => LEFT_QUAD,
          RIGHT_QUAD => RIGHT_QUAD,
          LEFT_MOTOR => LEFT_MOTOR,
          RIGHT_MOTOR => RIGHT_MOTOR,
          LED => LED
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
--	procedure GenPattern (right_quad_data, left_quad_data : in std_logic_vector) is
--	begin
--		wait until falling_edge(clk);
--		for i in right_quad_data'range loop
--			LEFT_QUAD  <= left_quad_data;
--			RIGHT_QUAD <= right_quad_data;
--			wait for 100 ns;
--		end loop;
--	end procedure;
	
   begin
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;
--		for p in 1 to 10000 loop
--			for k in test_quad_data'range loop
--				GenPattern (test_quad_data(k).right_quad_data, test_quad_data(k).left_quad_data);
--				wait for 50 ns;
--			end loop;
--		end loop;
      -- insert stimulus here 

      wait;
   end process;

END;
