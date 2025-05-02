library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity Controlpath is 
		port (
			rst,clk: in std_logic;
			PC_En, IR_En, RF_En, R1_En, R2_En, R3_En, R4_En, R_ALU_En, RWB_En, R6_En, R5_En, PC_Store_En: out std_logic;
			ALU_Sel, Nxt_PC_Sel: out std_logic_vector(1 downto 0);
			RS_Sel, R2_Sel, RWB_Sel: out std_logic;
			IMEM_Read, DMEM_Read, DMEM_Write: out std_logic;
			Instruction: in std_logic_vector(15 downto 0)
			); 
end Controlpath;

architecture cpuArch of Controlpath is
	type instr_type is (lw, sw, add, sub, mul, addi, shift_left_logical, jri, ji, nop, hlt, reset);
	
	type reg is (r0,r1,r2,r3,r4,r5,r6,r7, none);
	
	type regarray is array (0 to 3) of reg;
	type instr_array is array (0 to 3) of instr_type;
	signal instruction_arr: instr_array;
	signal ins: instr_type;
	signal reset_done: std_logic := '0';
	signal halt: std_logic := '0';
	signal hazard :std_logic := '0';
	signal stall_counter: integer := 0;
	begin
		process (clk)
		variable instr: instr_type;
		variable reg_writing, reg_reading_1, reg_reading_2: reg;
		variable instructions_in_pipeline : instr_array := (reset,reset,reset,reset);
		variable writing_to_reg: regarray := (none,none,none,none);

		function decode(instr: std_logic_vector(15 downto 0)) return instr_type is 
		begin
			case instr(15 downto 12) is
				when x"0" => return lw;
				when x"1" => return sw;
				when x"2" => return add;
				when x"3" => return sub;
				when x"4" => return mul;
				when x"5" => return addi;
				when x"6" => return shift_left_logical;
				when x"7" => return jri;
				when x"8" => return ji;
				when x"9" => return nop;
				when x"A" => return hlt;
				when others => return reset;
			end case;
		end function decode;
		
		function decode_reg(instr: std_logic_vector(15 downto 0)) return reg is 
		begin
			case instr(11 downto 9) is
				when "000" => return r0;
				when "001" => return r1;
				when "010" => return r2;
				when "011" => return r3;
				when "100" => return r4;
				when "101" => return r5;
				when "110" => return r6;
				when "111" => return r7;
				when others => return none;
			end case;
		end function decode_reg;
		
		function decode_reg_1_from_code(instr: std_logic_vector(15 downto 0)) return reg is 
		begin
			case instr(8 downto 6) is
				when "000" => return r0;
				when "001" => return r1;
				when "010" => return r2;
				when "011" => return r3;
				when "100" => return r4;
				when "101" => return r5;
				when "110" => return r6;
				when "111" => return r7;
				when others => return none;
			end case;
		end function decode_reg_1_from_code;
		
		function decode_reg_2_from_code(instr: std_logic_vector(15 downto 0)) return reg is 
		begin
			case instr(5 downto 3) is
				when "000" => return r0;
				when "001" => return r1;
				when "010" => return r2;
				when "011" => return r3;
				when "100" => return r4;
				when "101" => return r5;
				when "110" => return r6;
				when "111" => return r7;
				when others => return none;
			end case;
		end function decode_reg_2_from_code;
		
		
	-- Procedure to convert instr_type to string
	procedure instr_to_string(
		 variable ins: instr_type;
		 variable str: out string
	) is
	begin
		 case ins is
			  when lw                  => str := "lw                  ";
			  when sw                  => str := "sw                  ";
			  when add                 => str := "add                 ";
			  when sub                 => str := "sub                 ";
			  when mul                 => str := "mul                 ";
			  when addi                => str := "addi                ";
			  when shift_left_logical  => str := "shift_left_logical  ";
			  when jri                 => str := "jri                 ";
			  when ji                  => str := "ji                  ";
			  when nop                 => str := "nop                 ";
			  when hlt                 => str := "hlt                 ";
			  when reset               => str := "reset               ";
		 end case;
	end procedure;

	-- Procedure to print the instruction array
	procedure print_instruction_array(
		 variable instruction_arr: instr_array
	) is
		 variable str1,str2,str3,str4: string(1 to 20); -- Adjust size as needed
	begin
			  instr_to_string(instruction_arr(0), str1);
			  instr_to_string(instruction_arr(1), str2);
			  instr_to_string(instruction_arr(2), str3);
			  instr_to_string(instruction_arr(3), str4);
			  report str1 & " " & str2 & " " & str3 & " " & str4;
	end procedure;

	procedure reg_to_string(
		 variable regis: reg;
		 variable str: out string
	) is
	begin
		 case regis is
			  when r0                  => str := "r0";
			  when r1                  => str := "r1";
			  when r2                  => str := "r2";
			  when r3                  => str := "r3";
			  when r4                  => str := "r4";
			  when r5                  => str := "r5";
			  when r6                  => str := "r6";
			  when r7                  => str := "r7";
			  when none                => str := "no";
		 end case;
	end procedure;

	
	procedure print_reg_array(
		 variable reg_arr: regarray
	) is
		 variable str1,str2,str3,str4: string(1 to 2); -- Adjust size as needed
	begin
			  reg_to_string(reg_arr(0), str1);
			  reg_to_string(reg_arr(1), str2);
			  reg_to_string(reg_arr(2), str3);
			  reg_to_string(reg_arr(3), str4);
			  report str1 & " " & str2 & " " & str3 & " " & str4;
	end procedure;
	
	variable regstr1,regstr2: string(1 to 2); 
	begin
		instruction_arr <= instructions_in_pipeline;
		ins <= instr;
		if rising_edge(clk) then
			if rst = '1' then
				PC_En <= '0';
				IR_En <= '0';
				RF_En <= '0'; 
				R1_En <= '0';  
				R2_En <= '0';  
				R3_En <= '0';  
				R4_En <= '0';  
				R_ALU_En <= '0';  
				RWB_En <= '0';  
				R6_En <= '0';  
				R5_En <= '0'; 
				PC_Store_En <= '0';
				reset_done <= '0';
				RS_Sel <= '0';  
				R2_Sel <= '0';  
				RWB_Sel <= '0';  
				Nxt_PC_Sel <= "00";
				IMEM_Read <= '0';	
				DMEM_Read <= '0';
				DMEM_Write <= '0';
				halt <= '0';
				ALU_Sel <= "00";
			elsif reset_done = '0' then
				reset_done <= '1';
				IR_En <= '1';
				PC_Store_En <= '1';
				R1_En <= '1';
				R2_En <= '1';
				R3_En <= '1';
			elsif halt = '0' then 
				instr := decode(instruction);
				
				
				
				instructions_in_pipeline(3) := instructions_in_pipeline(2);
				instructions_in_pipeline(2) := instructions_in_pipeline(1);
				instructions_in_pipeline(1) := instructions_in_pipeline(0);
				instructions_in_pipeline(0) := instr;
				
				reg_writing := decode_reg(instruction);
				
				case instr is
					when lw => 
						writing_to_reg(3) := writing_to_reg(2);
						writing_to_reg(2) := writing_to_reg(1);
						writing_to_reg(1) := writing_to_reg(0);
						writing_to_reg(0) := reg_writing;
					when sw => 
						reg_reading_1 := reg_writing;
						reg_reading_2 := none;
					when add => 
						writing_to_reg(3) := writing_to_reg(2);
						writing_to_reg(2) := writing_to_reg(1);
						writing_to_reg(1) := writing_to_reg(0);
						writing_to_reg(0) := reg_writing;
						
						reg_reading_1 := decode_reg_1_from_code(instruction);
						reg_reading_2 := decode_reg_2_from_code(instruction);
					when sub => 
						writing_to_reg(3) := writing_to_reg(2);
						writing_to_reg(2) := writing_to_reg(1);
						writing_to_reg(1) := writing_to_reg(0);
						writing_to_reg(0) := reg_writing;
						
						reg_reading_1 := decode_reg_1_from_code(instruction);
						reg_reading_2 := decode_reg_2_from_code(instruction);
					when mul => 
						writing_to_reg(3) := writing_to_reg(2);
						writing_to_reg(2) := writing_to_reg(1);
						writing_to_reg(1) := writing_to_reg(0);
						writing_to_reg(0) := reg_writing;
						
						reg_reading_1 := decode_reg_1_from_code(instruction);
						reg_reading_2 := decode_reg_2_from_code(instruction);
					when addi=> 
						writing_to_reg(3) := writing_to_reg(2);
						writing_to_reg(2) := writing_to_reg(1);
						writing_to_reg(1) := writing_to_reg(0);
						writing_to_reg(0) := reg_writing;
						
						reg_reading_1 := decode_reg_1_from_code(instruction);
						reg_reading_2 := none;
					when shift_left_logical => 
						writing_to_reg(3) := writing_to_reg(2);
						writing_to_reg(2) := writing_to_reg(1);
						writing_to_reg(1) := writing_to_reg(0);
						writing_to_reg(0) := reg_writing;
						
						reg_reading_1 := decode_reg_1_from_code(instruction);
						reg_reading_2 := decode_reg_2_from_code(instruction);
					when jri =>
						reg_reading_1 := reg_writing;
						reg_reading_2 := none;
					when others =>
						reg_reading_1 := none;
						reg_reading_2 := none;
					end case;
				if hazard = '1' then
					PC_En <= '0';
					IR_En <= '0';
					instr := nop;
					stall_counter <= stall_counter + 1;
					if stall_counter = 2 then
						stall_counter <= 0;
						hazard <= '0';
					end if;
				else
					if reg_reading_1 /= none then
						if reg_reading_1 = writing_to_reg(1) or reg_reading_1 = writing_to_reg(2) or reg_reading_1 = writing_to_reg(3) then
							report "Hazard detected 1!";
							hazard <= '1';
							print_reg_array(writing_to_reg);
							reg_to_string(reg_reading_1,regstr1);
							report regstr1;
						end if;
					end if;
					
					if reg_reading_2 /= none then
						if reg_reading_2 = writing_to_reg(1) or reg_reading_2 = writing_to_reg(2) or reg_reading_2 = writing_to_reg(3) then
							report "Hazard detected 2!";
							print_reg_array(writing_to_reg);
							reg_to_string(reg_reading_2,regstr2);
							report regstr2;
						end if;
					end if;
				end if;
				IMEM_Read <= '1';
				DMEM_Read <= '0';
				DMEM_Write <= '0';
				RF_En <= '0';
				Nxt_PC_Sel <= "00";
				PC_En <= '1'; -- IF Stage
				
				-- RF Stage
				IR_En <= '1';
				PC_Store_En <= '1';
				R1_En <= '1';
				R2_En <= '1';
				R3_En <= '1';
				print_instruction_array(instructions_in_pipeline);
				case instructions_in_pipeline(0) is	
					when lw => 
						RS_Sel <= '0';
						RF_En <= '0';
						R2_Sel <= '0';
					when sw =>
						RS_Sel <= '1'; --RD
						RF_En <= '0';
						R2_Sel <= '0';
					when add =>
						RS_Sel <= '0';
						RF_En <= '0';
						R2_Sel <= '1'; --RT, 0 for Immediate
					when sub =>
						RS_Sel <= '0';
						RF_En <= '0';
						R2_Sel <= '1'; --RT, 0 for Immediate
					when mul =>
						RS_Sel <= '0';
						RF_En <= '0';
						R2_Sel <= '1'; --RT, 0 for Immediate
					when addi =>
						RS_Sel <= '0';
						RF_En <= '0';
						R2_Sel <= '0'; --Immediate, 1 for RT
					when shift_left_logical =>
						RS_Sel <= '0';
						RF_En <= '0';
						R2_Sel <= '1'; --RT, 0 for Immediate
					when jri =>
						Nxt_PC_Sel <= "01";
						RS_Sel <= '1'; --RD
						RF_En <= '0';
						R2_Sel <= '1'; --RT, 0 for Immediate
					when ji =>
						Nxt_PC_Sel <= "10";
						RS_Sel <= '1'; --RD
						RF_En <= '0';
						R2_Sel <= '1'; --RT, 0 for Immediate
					when hlt =>
						halt <= '1';
						PC_En <= '0';
						IR_En <= '0';
					when nop =>
						RS_Sel <= '0'; --RD
						RF_En <= '0';
						R2_Sel <= '0'; --RT, 0 for Immediate
					when others =>
						RS_Sel <= '0'; --RD
						RF_En <= '0';
						R2_Sel <= '0'; --RT, 0 for Immediate
				end case;
				
				-- ALU Stage
				R4_En <= '1';
				R_ALU_En <= '1'; 
				R5_En <= '1';

				case instructions_in_pipeline(1) is
					when lw => 
						ALU_Sel <= "00";
						DMEM_Read <= '1';
					when sw =>
						ALU_Sel <= "00";
						DMEM_Read <= '0';
					when add =>
						ALU_Sel <= "01";
						DMEM_Read <= '0';	
					when sub =>
						ALU_Sel <= "00";
						DMEM_Read <= '0';
					when mul =>
						ALU_Sel <= "10";
						DMEM_Read <= '0';
					when addi =>
						ALU_Sel <= "01";
						DMEM_Read <= '0';
					when shift_left_logical =>
						ALU_Sel <= "11";
						DMEM_Read <= '0';
					when jri =>
						ALU_Sel <= "00";
						DMEM_Read <= '0';
					when ji =>
						ALU_Sel <= "00";
						DMEM_Read <= '0';
					when nop =>
						DMEM_Read <= '0';
					when others =>
						ALU_Sel <= "00";
						DMEM_Read <= '0';
				end case;
			
				--MEM Stage
				RWB_En <= '1'; 
				R6_En <= '1';

				case instructions_in_pipeline(2) is
					when lw => 
						RWB_Sel <= '1';
						DMEM_Write <= '0';
					when sw =>
						RWB_Sel <= '1';
						DMEM_Write <= '1';
					when add =>
						RWB_Sel <= '0';
						DMEM_Write <= '0';
					when sub =>
						RWB_Sel <= '0'; 
						DMEM_Write <= '0';
					when mul =>
						RWB_Sel <= '0';
						DMEM_Write <= '0';
					when addi =>
						RWB_Sel <= '0';
						DMEM_Write <= '0';
					when shift_left_logical =>
						RWB_Sel <= '0';
						DMEM_Write <= '0';
					when jri =>
						RWB_Sel <= '0';
						DMEM_Write <= '0';
					when ji =>
						RWB_Sel <= '0';
						DMEM_Write <= '0';
					when nop =>
						RWB_Sel <= '0';
						DMEM_Write <= '0';
					when others =>
						RWB_Sel <= '0';
						DMEM_Write <= '0';
				end case;
				
				
				--WB Stage

				case instructions_in_pipeline(3) is
					when lw => 
						RF_En <= '1';
					when sw =>
						RF_En <= '0';
					when add =>
						RF_En <= '1';
					when sub =>
						RF_En <= '1';
					when mul =>
						RF_En <= '1';
					when addi =>
						RF_En <= '1';
					when shift_left_logical =>
						RF_En <= '1';
					when jri =>
						RF_En <= '0';
					when ji =>
						RF_En <= '0';
					when nop =>
						RF_En <= '0';
					when others =>
						RF_En <= '0';
				end case;
				
				if hazard = '1' then
					PC_En <= '0';
					IR_En <= '0';
				end if;
			end if;
		end if;
	end process;
end cpuArch;