library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity zero_padding is
	port(
			a: in std_logic_vector(3 downto 0);
			b: out std_logic_vector(15 downto 0)
		);
end entity;

architecture struct of zero_padding is
	
begin 
	for_1: for i in 0 to 3 generate
	b(i)<= a(i);
	end generate for_1;
	for_2: for i in 4 to 15 generate
	b(i)<= '0';
	end generate for_2;		
end architecture;