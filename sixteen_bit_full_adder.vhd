library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity sixteen_bit_full_adder is
	port(
			m: in std_logic;
			a,b: in std_logic_vector(15 downto 0);
			cout: out std_logic;
			s: out std_logic_vector(15 downto 0));
end entity;

architecture struct of sixteen_bit_full_adder is
	component full_adder is
     port(a, b, c: in std_logic;
          sum, carry: out std_logic);
   end component;
	signal p: std_logic_vector(15 downto 0);
	signal car: std_logic_vector(15 downto 0);
begin 
	for_add: for i in 0 to 15 generate
	inst1: XOR_2 port map(a=>m,b=>b(i),y=>p(i));
	end generate;
	
	inst2: full_adder port map(a=>a(0),b=>p(0),c=>m,sum=>s(0),carry=>car(0));
	inst3: full_adder port map(a=>a(1),b=>p(1),c=>car(0),sum=>s(1),carry=>car(1));
	inst4: full_adder port map(a=>a(2),b=>p(2),c=>car(1),sum=>s(2),carry=>car(2));
	inst5: full_adder port map(a=>a(3),b=>p(3),c=>car(2),sum=>s(3),carry=>car(3));
	inst6: full_adder port map(a=>a(4),b=>p(4),c=>car(3),sum=>s(4),carry=>car(4));
	inst7: full_adder port map(a=>a(5),b=>p(5),c=>car(4),sum=>s(5),carry=>car(5));
	inst8: full_adder port map(a=>a(6),b=>p(6),c=>car(5),sum=>s(6),carry=>car(6));
	inst9: full_adder port map(a=>a(7),b=>p(7),c=>car(6),sum=>s(7),carry=>car(7));
	inst10: full_adder port map(a=>a(8),b=>p(8),c=>car(7),sum=>s(8),carry=>car(8));
	inst11: full_adder port map(a=>a(9),b=>p(9),c=>car(8),sum=>s(9),carry=>car(9));
	inst12: full_adder port map(a=>a(10),b=>p(10),c=>car(9),sum=>s(10),carry=>car(10));
	inst13: full_adder port map(a=>a(11),b=>p(11),c=>car(10),sum=>s(11),carry=>car(11));
	inst14: full_adder port map(a=>a(12),b=>p(12),c=>car(11),sum=>s(12),carry=>car(12));
	inst15: full_adder port map(a=>a(13),b=>p(13),c=>car(12),sum=>s(13),carry=>car(13));
	inst16: full_adder port map(a=>a(14),b=>p(14),c=>car(13),sum=>s(14),carry=>car(14));
	inst17: full_adder port map(a=>a(15),b=>p(15),c=>car(14),sum=>s(15),carry=>cout);
	
	
	
end architecture;