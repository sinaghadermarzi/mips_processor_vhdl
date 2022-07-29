LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
LIBRARY work;
USE work.ALL;

ENTITY tb_alu IS END tb_alu;

ARCHITECTURE test OF tb_alu IS
COMPONENT alu
	GENERIC(n : integer := 4);
	PORT(
			a	:IN  std_logic_vector(n-1 DOWNTO 0);
			b	:IN  std_logic_vector(n-1 DOWNTO 0);
			func:IN  std_logic_vector(3 DOWNTO 0);
			z	:OUT std_logic_vector(n-1 DOWNTO 0);
			ov  :OUT std_logic
		);			
END COMPONENT;
SIGNAL		t_a		: std_logic_vector(3 DOWNTO 0);
SIGNAL		t_b		: std_logic_vector(3 DOWNTO 0);
SIGNAL		t_func	: std_logic_vector(3 DOWNTO 0);
SIGNAL		t_z		: std_logic_vector(3 DOWNTO 0);
SIGNAL		t_ov	: std_logic;
BEGIN
	l :alu GENERIC MAP(4) PORT MAP(t_a, t_b, t_func, t_z, t_ov);
	t_a		<= "0110";
	t_b		<= "1100";
	t_func	<= "0000",	"0001" AFTER 10 ns,	"0010" AFTER 20 ns,	"0011" AFTER 30 ns,"0100" AFTER 40 ns,"0101" AFTER 50 ns,"0110" AFTER 60 ns,"0111" AFTER 70 ns,"1000" AFTER 80 ns,"1001" AFTER 90 ns,"1010" AFTER 100 ns,"1011" AFTER 110 ns;	
END test;

