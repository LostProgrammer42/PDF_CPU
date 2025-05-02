library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port (a,b : in std_logic_vector(15 downto 0); 
			ALU_Sel: in std_logic_vector(1 downto 0); --1 for Add, 0 for Sub, 2 for MUL, 3 for Shift
			c : out std_logic_vector(15 downto 0));
end entity;

architecture str of ALU is
	component kogge_stone_adder_subtractor is
		port(
			A : in std_logic_vector(15 downto 0);
			B : in std_logic_vector(15 downto 0);
			M: in std_logic := '0';
			S: out std_logic_vector(15 downto 0);
			Cout: out std_logic);
	end component;
	
	component mux_4x1_16bit is
		port (I3,I2,I1,I0 : in std_logic_vector(15 downto 0); 
				S : in std_logic_vector(1 downto 0); 
				Y : out std_logic_vector(15 downto 0));
	end component;
	
	component multiplier is
	port(
			a,b: in std_logic_vector(15 downto 0);
			c: out std_logic_vector(15 downto 0));
	end component;
	
	component shifter is
	port(
		a: in std_logic_vector(15 downto 0);
		shift_amount: in std_logic_vector(3 downto 0);
		b: out std_logic_vector(15 downto 0)
	);
	end component;

	
	signal Add_Out, Mul_Out, Shifter_Out: std_logic_vector(15 downto 0);
	signal M_sig: std_logic;
	begin
	M_sig <= not ALu_Sel(0);
	Multiplier_entity: multiplier port map(a=>a, b=>b, c=> Mul_Out); 
	Adder: kogge_stone_adder_subtractor port map (A=>a, B=>b, M=> M_sig,S=>Add_Out,Cout=>Open);
	Shift: Shifter port map (a=>a, shift_amount=> b(3 downto 0), b=>Shifter_Out);
	Mux_Out: mux_4x1_16bit port map(I3 => Shifter_Out, I2=> Mul_Out, I1 =>Add_Out, I0 => Add_Out, S=> ALU_Sel, Y=>c); 
	
end architecture;