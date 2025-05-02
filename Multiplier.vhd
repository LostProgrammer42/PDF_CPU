library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity multiplier is
	port(
			a,b: in std_logic_vector(15 downto 0);
			c: out std_logic_vector(15 downto 0));
end entity;

architecture struct of multiplier is
	component zero_padding is
		port(
				a: in std_logic_vector(3 downto 0);
				b: out std_logic_vector(15 downto 0)
			);
	end component;
	
	component shift_one is
	port(
			a: in std_logic_vector(15 downto 0);
			en: in std_logic;
			b: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component sixteen_bit_full_adder is
	port(
			m: in std_logic;
			a,b: in std_logic_vector(15 downto 0);
			cout: out std_logic;
			s: out std_logic_vector(15 downto 0));
	end component;


	signal s0,s1,s2,s3: std_logic_vector(3 downto 0);
	signal s0_full,s1_full,s2_full,s3_full,s1_final,s2_1,s2_final,s3_1,s3_2,s3_final,s4_1,s4_2,s4_3,s4_final,add1,add2: std_logic_vector(15 downto 0);
	signal temp1,temp2,temp3: std_logic;
begin 
	for_1: for i in 0 to 3 generate
	inst1: AND_2 port map(a=>a(i),b=>b(0),y=>s0(i));
	inst2: AND_2 port map(a=>a(i),b=>b(1),y=>s1(i));
	inst3: AND_2 port map(a=>a(i),b=>b(2),y=>s2(i));
	inst4: AND_2 port map(a=>a(i),b=>b(3),y=>s3(i));
	end generate for_1;
	
	inst5: zero_padding port map(a=>s0,b=>s0_full);
	inst6: zero_padding port map(a=>s1,b=>s1_full);
	inst7: zero_padding port map(a=>s2,b=>s2_full);
	inst8: zero_padding port map(a=>s3,b=>s3_full);
	
	inst9: shift_one port map(a=>s1_full,en=>'1',b=>s1_final);
	
	inst10: shift_one port map(a=>s2_full,en=>'1',b=>s2_1);
	inst11: shift_one port map(a=>s2_1,en=>'1',b=>s2_final);
	
	inst12: shift_one port map(a=>s3_full,en=>'1',b=>s3_1);
	inst13: shift_one port map(a=>s3_1,en=>'1',b=>s3_2);
	inst14: shift_one port map(a=>s3_2,en=>'1',b=>s3_final);

	inst15: sixteen_bit_full_adder port map(m=>'0',a=>s0_full,b=>s1_final,cout=>temp1,s=>add1);
	inst16: sixteen_bit_full_adder port map(m=>'0',a=>s2_final,b=>s3_final,cout=>temp2,s=>add2);
	inst17: sixteen_bit_full_adder port map(m=>'0',a=>add1,b=>add2,cout=>temp3,s=>c);
	
end architecture;
