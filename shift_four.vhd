library ieee;
use ieee.std_logic_1164.all;

entity shift_four is
	port(
		a: in std_logic_vector(15 downto 0);
		En: in std_logic;
		b: out std_logic_vector(15 downto 0)
	);
end entity;

architecture design of shift_four is
	component mux_2x1_16bit is
		port (I1, I0 : in std_logic_vector(15 downto 0); 
				S : in std_logic; 
				Y : out std_logic_vector(15 downto 0):="0000000000000000");
	end component;
	
	signal shifted_b: std_logic_vector(15 downto 0);
	begin
		shifted_b(3 downto 0) <= "0000";
		shifted_b(15 downto 4) <= a(11 downto 0);
		
		mux: mux_2x1_16bit port map(I1=>shifted_b, I0=>a, S=>En, Y=>b);
end architecture;