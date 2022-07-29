LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY alu_bitcell IS
PORT(
		a,b,cin,equalp			:IN std_logic;
		func 					:IN std_logic_vector(3 DOWNTO 0);
		z,cout,equaln			:OUT std_logic
	);
END alu_bitcell;

ARCHITECTURE alu_bc1 OF alu_bitcell IS
signal b1:std_logic;
BEGIN
	b1	<=	NOT b WHEN (func = "0011")  OR  (func = "0100") OR (func = "0101") ELSE
			b;
			
	z	<=  a	WHEN (func = "0000") ELSE
			b	WHEN (func = "0001") ELSE
			a XOR b1 XOR cin WHEN (func = "0011")  OR  (func = "0100") OR (func = "0101") OR (func = "0010") ELSE
			(a XOR b) OR cin WHEN (func = "0110") ELSE
			cin WHEN (func = "0111") OR func = ("1000") ELSE 
			a AND b WHEN (func = "1001") ELSE
			a OR b WHEN (func = "1010") ELSE
			a XOR b WHEN (func = "1011") ELSE
			'0' ;
			equaln 	<= equalp AND (NOT(a XOR b));
			cout	<=	a WHEN (func = "0111") OR (func = "1000") ELSE						
						(a AND b1) OR (b1 AND cin) OR (a AND cin) ;
END alu_bc1;

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY alu IS
GENERIC(n : integer := 4);
	PORT(
			a	:IN  std_logic_vector(n-1 DOWNTO 0);
			b	:IN  std_logic_vector(n-1 DOWNTO 0);
			func:IN  std_logic_vector(3 DOWNTO 0);
			z	:OUT std_logic_vector(n-1 DOWNTO 0);
			ov  :OUT std_logic
		);			
END alu;

ARCHITECTURE bit_slice OF alu IS
	COMPONENT alu_bitcell	
		PORT(
				a,b,cin,equalp			:IN std_logic;
				func 					:IN std_logic_vector(3 DOWNTO 0);
				z,cout,equaln			:OUT std_logic
			);
	END COMPONENT;
	SIGNAL cins, couts		  :std_logic_vector(n-1 DOWNTO 0);
	SIGNAL equals			  :std_logic_vector(n DOWNTO 0);
	SIGNAL res				  :std_logic_vector(n-1 DOWNTO 0);
	SIGNAL equal,greater,less :std_logic;
BEGIN
	equals(0) <= '1';
	equal<= equals(n-1);
	l :FOR i IN n-1 DOWNTO 0 GENERATE
		bcs: alu_bitcell PORT MAP(a(i),b(i),cins(i),equals(i),func,res(i),couts(i),equals(i+1));
	END GENERATE l;
	
	cins(0)	 <=	'1' WHEN (func = "0011") OR (func = "0100") OR (func = "0101")  ELSE
				'0'	WHEN (func = "0000") OR (func = "0001") OR (func = "0010") OR (func = "0110") OR (func= "0111") OR (func ="1001") OR (func ="1010") OR (func ="1011") ELSE 'Z';				
				
	cins(n-1)<=	'0' WHEN (func = "1000") ELSE 'Z';
	
	cins(n-1 DOWNTO 1)	<= couts(n-2 DOWNTO 0) WHEN (func = "0000") OR (func ="0001") OR (func ="0010") OR (func ="0011") OR (func ="0100") OR (func = "0101") OR (func ="0110") OR (func ="0111") OR (func ="1001") OR (func ="1010") OR (func ="1011") ELSE
							( OTHERS => 'Z');
	cins(n-2 DOWNTO 0)	<= couts(n-1 DOWNTO 1) WHEN (func = "1000") ELSE
							(OTHERS => 'Z');
	cins(0) 			<= '0' WHEN (func = "1011") OR (func ="1100") OR (func ="1101") OR (func ="1110") OR (func ="1111") ELSE
							'Z' ;
			
	z	 <=	(0	=> less ,		OTHERS => '0')	WHEN	(func = "0101") ELSE
			(0	=> greater ,	OTHERS => '0')	WHEN	(func = "0100") ELSE
			(0	=> equal ,		OTHERS => '0')	WHEN	(func = "0110") ELSE
			res WHEN (func = "0000") OR (func = "0001") OR (func = "0010") OR (func ="0011") OR  (func ="0111") OR (func ="1000") OR func = "1001" OR func = "1010" OR func = "1011" ELSE
			(OTHERS=>'0');
			
	greater <= '1' WHEN (equal = '0') AND ((cins(n-1) = '0' AND couts(n-1) = '0' AND res(n-1) = '0') OR ( cins(n-1)= '1' AND couts(n-1) = '0') OR (cins(n-1) = '1' AND couts(n-1) = '1' AND res(n-1) = '0')) 
				ELSE 	'0';
	less 	<= '1' WHEN (equal= '0') AND ((cins(n-1) = '0' AND couts(n-1) = '0' and res(n-1) = '1') OR (cins(n-1) = '0' AND couts(n-1) = '1'  ) OR (cins(n-1) = '1' AND couts(n-1) = '1' AND res(n-1) = '1'))
				ELSE 	'0';
	ov <= (cins(n-1) XOR couts(n-1));
END bit_slice;