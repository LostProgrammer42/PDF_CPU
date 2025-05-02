library ieee;
use ieee.std_logic_1164.all;
library work;

entity shifter is
	port(
		a: in std_logic_vector(15 downto 0);
		shift_amount: in std_logic_vector(3 downto 0);
		b: out std_logic_vector(15 downto 0)
	);
end entity;

architecture design of shifter is
	
	component shift_one is
		port(
				a: in std_logic_vector(15 downto 0);
				en: in std_logic;
				b: out std_logic_vector(15 downto 0)
			);
	end component;

	component shift_two is
		port(
				a: in std_logic_vector(15 downto 0);
				en: in std_logic;
				b: out std_logic_vector(15 downto 0)
			);
	end component;

	component shift_four is
		port(
				a: in std_logic_vector(15 downto 0);
				en: in std_logic;
				b: out std_logic_vector(15 downto 0)
			);
	end component;

	component shift_eight is
		port(
				a: in std_logic_vector(15 downto 0);
				en: in std_logic;
				b: out std_logic_vector(15 downto 0)
			);
	end component;
	signal temp_1, temp_2, temp_3: std_logic_vector(15 downto 0);
	begin
	one: shift_one port map (a=>a,en=>shift_amount(0),b=>temp_1);
	two: shift_two port map (a=>temp_1,en=>shift_amount(1),b=>temp_2);
	four: shift_four port map (a=>temp_2,en=>shift_amount(2),b=>temp_3);
	eight: shift_eight port map (a=>temp_3,en=>shift_amount(3),b=>b);	
	
end architecture;