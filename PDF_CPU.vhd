library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PDF_CPU is port (
			rst,clk: in std_logic;
			DMEM_Write, DMEM_Read: in std_logic;
			IMEM_Read, DMEM_Read_CPU, DMEM_Write_CPU: out std_logic;
			Imem_Data_Read, Dmem_Data_Write, Dmem_Data_Read_CPU: in std_logic_vector(15 downto 0);
			Imem_Address_Read, Dmem_Data_Read, Dmem_Data_Write_CPU: out std_logic_vector(15 downto 0)
			); 
end PDF_CPU;

architecture pdf of PDF_CPU is
	component datapath is
		port (IMem_Data_Read: in std_logic_vector(15 downto 0);-- read wrt CPU
			DMem_Data_Read: in std_logic_vector(15 downto 0);
			DMem_Data_Write: out std_logic_vector(15 downto 0);
			IMem_Address_Read: out std_logic_vector(15 downto 0);
			rst,clk: in std_logic;
			PC_En, IR_En, RF_En, R1_En, R2_En, R3_En, R4_En, R_ALU_En, RWB_En, R6_En, R5_En, PC_Store_En: in std_logic;
			ALU_Sel, Nxt_PC_Sel: in std_logic_vector(1 downto 0);
			RS_Sel, R2_Sel, RWB_Sel: in std_logic;
			Instr: out std_logic_vector(15 downto 0)
			); 
	end component;
	
	component Controlpath is 
		port (
			rst,clk: in std_logic;
			PC_En, IR_En, RF_En, R1_En, R2_En, R3_En, R4_En, R_ALU_En, RWB_En, R6_En, R5_En, PC_Store_En: out std_logic;
			ALU_Sel, Nxt_PC_Sel: out std_logic_vector(1 downto 0);
			RS_Sel, R2_Sel, RWB_Sel: out std_logic;
			IMEM_Read, DMEM_Read, DMEM_Write: out std_logic;
			Instruction: in std_logic_vector(15 downto 0)
			);
	end component;
	
		
	component ring_buffer is
	  port (
		 clk : in std_logic;
		 rst : in std_logic;
	  
		 -- Write port
		 wr_en : in std_logic;
		 wr_data : in std_logic_vector(15 downto 0)  := (15 downto 0 => 'Z');
	  
		 -- Read port
		 rd_en : in std_logic;
		 rd_valid : out std_logic;
		 rd_data : out std_logic_vector(15 downto 0)  := (15 downto 0 => 'Z');
	  
		 -- Flags
		 empty : out std_logic;
		 empty_next : out std_logic;
		 full : out std_logic;
		 full_next : out std_logic;
	  
		 -- The number of elements in the FIFO
		 fill_count : out integer range 31 downto 0
	  );
	end component;
	signal PC_En, IR_En, RF_En, R1_En, R2_En, R3_En, R4_En, R_ALU_En, RWB_En, R6_En, R5_En, RS_Sel, R2_Sel, RWB_Sel, PC_Store_En: std_logic;
	signal ALU_Sel, Nxt_PC_Sel: std_logic_vector(1 downto 0);
	signal Instr: std_logic_vector(15 downto 0);
	
	begin
	DP: datapath port map(IMem_Data_Read => IMem_Data_Read, Dmem_Data_Read => Dmem_Data_Read_CPU, Dmem_Data_Write => Dmem_Data_Write_CPU, 
								 IMem_Address_Read => IMem_Address_Read, rst => rst, clk => clk, PC_En => PC_En, IR_En => IR_En, RF_En => RF_En,
								 R1_En => R1_En, R2_En => R2_En, R3_En => R3_En, R4_En => R4_En, R5_En => R5_En, R6_En => R6_En, R_ALU_En => R_ALU_En, 
								 RWB_En => RWB_En, ALU_Sel => ALU_Sel, RS_Sel => RS_Sel, R2_Sel => R2_Sel, RWB_Sel => RWB_Sel, Nxt_PC_Sel => Nxt_PC_Sel, 
								 Instr => Instr, PC_Store_En => PC_Store_En);
								 
	CP: controlpath port map(IMem_Read => IMem_Read, DMEM_Read => DMEM_Read_CPU, DMEM_Write => DMEM_Write_CPU, 
								 rst => rst, clk => clk, PC_En => PC_En, IR_En => IR_En, RF_En => RF_En,
								 R1_En => R1_En, R2_En => R2_En, R3_En => R3_En, R4_En => R4_En, R5_En => R5_En, R6_En => R6_En, R_ALU_En => R_ALU_En, 
								 RWB_En => RWB_En, ALU_Sel => ALU_Sel, RS_Sel => RS_Sel, R2_Sel => R2_Sel, RWB_Sel => RWB_Sel, Nxt_PC_Sel => Nxt_PC_Sel, 
								 Instruction => Instr, PC_Store_En => PC_Store_En);
								 
	Data_Memory: ring_buffer port map(clk=>clk, rst=>'0', wr_en => DMEM_Write, wr_data => DMEM_Data_Write, rd_en => DMEM_Read, rd_data => DMEM_Data_Read);

end architecture;							 
