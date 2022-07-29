LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY ucount IS
	GENERIC( n: integer);
	PORT(
		clk	:IN std_logic;	-- Clock signal
		nsrst	:IN std_logic;	-- Active LOW synchronous reset of counter
		mode	:IN std_logic_vector(1 DOWNTO 0);
		din	:IN std_logic_vector(n-1 DOWNTO 0);
		dout	:OUT std_logic_vector(n-1 DOWNTO 0)		
	);
END ucount;

ARCHITECTURE behavioral OF ucount IS
SIGNAL temp : std_logic_vector(n-1 DOWNTO 0);
BEGIN
	PROCESS(clk)
	BEGIN
		IF (clk = '0') THEN	-- In the negedge of clock synchronous funciton of counter is done
			IF (nsrst = '0') THEN 	--
				dout <= (OTHERS => '0');
			ELSE
				IF(mode = "00") THEN
					temp	<=  din;
				ELSIF(mode = "01") THEN
					temp	<= (temp + 1);
				ELSIF(mode = "10") THEN 
					temp	<= (temp - 1);
				END IF;
			END IF;
		END IF;
	END PROCESS;
	dout <= temp;
END behavioral;