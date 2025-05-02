library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity full_adder is
	port(
			a,b,c: in std_logic;
			sum,carry: out std_logic);
end entity;

architecture struct of full_adder is
	signal s1, s2, s3: std_logic;
begin 
	
	inst1: XOR_2 port map(a=>a,b=>b,y=>s1);
	inst2: XOR_2 port map(a=>s1,b=>c,y=>sum);
	
	inst3: NAND_2 port map(a=>s1,b=>c,y=>s2);
	inst4: NAND_2 port map(a=>a,b=>b,y=>s3);
	inst5: NAND_2 port map(a=>s3,b=>s2,y=>carry);
	
	
end architecture;
