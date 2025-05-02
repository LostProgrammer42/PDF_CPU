library ieee;
use ieee.std_logic_1164.all;

entity shift_two is
	port(
		a: in std_logic_vector(15 downto 0);
		En: in std_logic;
		b: out std_logic_vector(15 downto 0)
	);
end entity;

architecture design of shift_two is
	component mux_2x1_16bit is
		port (I1, I0 : in std_logic_vector(15 downto 0); 
				S : in std_logic; 
				Y : out std_logic_vector(15 downto 0):="0000000000000000");
	end component;
	
	signal shifted_b: std_logic_vector(15 downto 0);
	begin
		shifted_b(1 downto 0) <= "00";
		shifted_b(15 downto 2) <= a(13 downto 0);
		
		mux: mux_2x1_16bit port map(I1=>shifted_b, I0=>a, S=>En, Y=>b);
end architecture;