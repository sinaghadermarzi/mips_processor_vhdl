LIBRARY work;
USE work.ALL;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ucount_tb IS
END ucount_tb;

ARCHITECTURE behavioral OF ucount_tb IS

COMPONENT ucount
	GENERIC( n: integer);
	PORT(
		clk	:IN std_logic;	-- Clock signal
		nsrst	:IN std_logic;	-- Active LOW synchronous reset of counter
		mode	:IN std_logic_vector(1 DOWNTO 0);
		din	:IN std_logic_vector(n-1 DOWNTO 0);
		dout	:OUT std_logic_vector(n-1 DOWNTO 0)		
	);
END COMPONENT;

SIGNAL		clk_t	: std_logic;	-- Clock signal
SIGNAL		nsrst_t	: std_logic;	-- Active LOW synchronous reset of counter
SIGNAL		mode_t	: std_logic_vector(1 DOWNTO 0);
SIGNAL		din_t	: std_logic_vector(7 DOWNTO 0);
SIGNAL		dout_t	: std_logic_vector(7 DOWNTO 0);

BEGIN
clk_t <= (NOT clk_t) AFTER 20 ns ;
c1 : ucount GENERIC MAP (8) PORT MAP(clk_t,nsrst_t,mode_t,din_t,dout_t);
wav: PROCESS
BEGIN
	clk_t	<= '0';
	mode_t 	<= "00";
	din_t	<= "00000000";
	WAIT ON clk_t;
	mode_t <= "01";
	FOR i IN 0 TO 12 LOOP
		WAIT ON clk_t;
	END LOOP;
	mode_t <= "10";
	FOR i IN 0 TO 12 LOOP
		WAIT ON clk_t;
	END LOOP;
	mode_t	<= "00";
	din_t	<= "00000000";
	WAIT;	
END PROCESS;	
END behavioral;