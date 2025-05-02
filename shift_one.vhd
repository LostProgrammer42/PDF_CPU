library ieee;
use ieee.std_logic_1164.all;

entity shift_one is
	port(
			a: in std_logic_vector(15 downto 0);
			en: in std_logic;
			b: out std_logic_vector(15 downto 0)
		);
end entity;

architecture struct of shift_one is
	component mux_2x1_16bit is
		port (I1, I0 : in std_logic_vector(15 downto 0); 
				S : in std_logic; 
				Y : out std_logic_vector(15 downto 0):="0000000000000000");
	end component;

	signal shifted_b: std_logic_vector(15 downto 0);
	begin 
		for_shift: for i in 0 to 14 generate
		shifted_b(i+1)<= a(i);
		end generate for_shift;
		shifted_b(0)<='0';
		mux: mux_2x1_16bit port map(I1=>shifted_b, I0=>a, S=>En, Y=>b);
	
end architecture;
