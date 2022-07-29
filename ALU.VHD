library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY alu IS
    PORT(alu_in1,alu_in2 : IN std_logic_vector(31 DOWNTO 0);
         alu_op : IN std_logic_vector(5 DOWNTO 0);
         alu_out : OUT std_logic_vector(31 DOWNTO 0)
         );
END alu;



ARCHITECTURE sample OF alu IS
BEGIN

   aluu: PROCESS (alu_in1,alu_in2,alu_op)
        VARIABLE shiftemp,shiftemp2 : std_logic_vector(31 DOWNTO 0);
        VARIABLE shamt : integer;
    BEGIN
    
        IF alu_op="100001" THEN -- ADDU / ADDIU
        
            alu_out<=alu_in1+alu_in2;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;
            
        ELSIF alu_op="100100" THEN -- bitwise AND / ANDI
        
            FOR i IN 0 TO 31 LOOP
                alu_out(i)<= (alu_in1(i) AND alu_in2(i));
            END LOOP;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0; 
            
        ELSIF alu_op="100101" THEN -- bitwise OR / ORI
        
            FOR i IN 0 TO 31 LOOP
                alu_out(i)<=(alu_in1(i) OR alu_in2(i));
            END LOOP;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;
            
        ELSIF (alu_op="000000") OR (alu_op="000100") THEN -- SHIFT LEFT LOGICAL , SLL / SLLV
        
            shiftemp2:=(OTHERS=>'0');
            shamt:=conv_integer(alu_in2);
            IF shamt=0 THEN
                shiftemp:=alu_in1;
            ELSIF shamt>31 THEN
                shiftemp:=shiftemp2;
            ELSE
                shiftemp:=alu_in1;
                IF shamt=1 THEN
                    shiftemp:=shiftemp(30 DOWNTO 0) & shiftemp2(0 DOWNTO 0);
                ELSIF shamt=2 THEN   
                    shiftemp:=shiftemp(29 DOWNTO 0) & shiftemp2(1 DOWNTO 0);
                ELSIF shamt=3 THEN     
                    shiftemp:=shiftemp(28 DOWNTO 0) & shiftemp2(2 DOWNTO 0);
                ELSIF shamt=4 THEN     
                    shiftemp:=shiftemp(27 DOWNTO 0) & shiftemp2(3 DOWNTO 0);
                ELSIF shamt=5 THEN     
                    shiftemp:=shiftemp(26 DOWNTO 0) & shiftemp2(4 DOWNTO 0);
                ELSIF shamt=6 THEN     
                    shiftemp:=shiftemp(25 DOWNTO 0) & shiftemp2(5 DOWNTO 0);
                ELSIF shamt=7 THEN     
                    shiftemp:=shiftemp(24 DOWNTO 0) & shiftemp2(6 DOWNTO 0);
                ELSIF shamt=8 THEN     
                    shiftemp:=shiftemp(23 DOWNTO 0) & shiftemp2(7 DOWNTO 0);
                ELSIF shamt=9 THEN     
                    shiftemp:=shiftemp(22 DOWNTO 0) & shiftemp2(8 DOWNTO 0);
                ELSIF shamt=10 THEN    
                    shiftemp:=shiftemp(21 DOWNTO 0) & shiftemp2(9 DOWNTO 0);
                ELSIF shamt=11 THEN    
                    shiftemp:=shiftemp(20 DOWNTO 0) & shiftemp2(10 DOWNTO 0);
                ELSIF shamt=12 THEN   
                    shiftemp:=shiftemp(19  DOWNTO 0) & shiftemp2(11 DOWNTO 0);
                ELSIF shamt=13 THEN    
                    shiftemp:=shiftemp(18  DOWNTO 0) & shiftemp2(12 DOWNTO 0);
                ELSIF shamt=14 THEN   
                    shiftemp:=shiftemp(17  DOWNTO 0) & shiftemp2(13 DOWNTO 0);
                ELSIF shamt=15 THEN   
                    shiftemp:=shiftemp(16  DOWNTO 0) & shiftemp2(14 DOWNTO 0);
                ELSIF shamt=16 THEN    
                    shiftemp:=shiftemp(15  DOWNTO 0) & shiftemp2(15 DOWNTO 0);
                ELSIF shamt=17 THEN   
                    shiftemp:=shiftemp(14 DOWNTO 0) & shiftemp2(16 DOWNTO 0);
                ELSIF shamt=18 THEN    
                    shiftemp:=shiftemp(13 DOWNTO 0) & shiftemp2(17 DOWNTO 0);
                ELSIF shamt=19 THEN    
                    shiftemp:=shiftemp(12 DOWNTO 0) & shiftemp2(18 DOWNTO 0);
                ELSIF shamt=20 THEN    
                    shiftemp:=shiftemp(11 DOWNTO 0) & shiftemp2(19 DOWNTO 0);
                ELSIF shamt=21 THEN
                    shiftemp:=shiftemp(10 DOWNTO 0) & shiftemp2(20 DOWNTO 0);
                ELSIF shamt=22 THEN    
                    shiftemp:=shiftemp(9 DOWNTO 0) & shiftemp2(21 DOWNTO 0);
                ELSIF shamt=23 THEN    
                    shiftemp:=shiftemp(8 DOWNTO 0) & shiftemp2(22 DOWNTO 0);
                ELSIF shamt=24 THEN   
                    shiftemp:=shiftemp(7 DOWNTO 0) & shiftemp2(23 DOWNTO 0);
                ELSIF shamt=25 THEN    
                    shiftemp:=shiftemp(6 DOWNTO 0) & shiftemp2(24 DOWNTO 0);
                ELSIF shamt=26 THEN    
                    shiftemp:=shiftemp(5 DOWNTO 0) & shiftemp2(25 DOWNTO 0);
                ELSIF shamt=27 THEN    
                    shiftemp:=shiftemp(4 DOWNTO 0) & shiftemp2(26 DOWNTO 0);
                ELSIF shamt=28 THEN                             
                    shiftemp:=shiftemp(3 DOWNTO 0) & shiftemp2(27 DOWNTO 0);
                ELSIF shamt=29 THEN    
                    shiftemp:=shiftemp(2 DOWNTO 0) & shiftemp2(28 DOWNTO 0);
                ELSIF shamt=30 THEN    
                    shiftemp:=shiftemp(1 DOWNTO 0) & shiftemp2(29 DOWNTO 0);
                ELSE    
                    shiftemp:=shiftemp(0 DOWNTO 0) & shiftemp2(30 DOWNTO 0);
                END IF;
            END IF;
            alu_out<=shiftemp;
            
        ELSIF alu_op="101011" THEN -- SET ON LESS THAN , SLT
        
            IF alu_in1<alu_in2 THEN
                alu_out<="00000000000000000000000000000001";
            ELSE
                alu_out<="00000000000000000000000000000000";
            END IF;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;
            
        ELSIF (alu_op="000010") OR (alu_op="000110") THEN -- SHIFT RIGHT LOGICAL , SRL / SRLV
        
            shiftemp2:=(OTHERS=>'0');
            shamt:=conv_integer(alu_in2);
            IF shamt=0 THEN
                shiftemp:=alu_in1;
            ELSIF shamt>31 THEN
                shiftemp:=shiftemp2;
            ELSE
                shiftemp:=alu_in1;
                IF shamt=1 THEN
                    shiftemp:=shiftemp2(0 DOWNTO 0) & shiftemp(31 DOWNTO 1);
                ELSIF shamt=2 THEN
                    shiftemp:=shiftemp2(1 DOWNTO 0) & shiftemp(31 DOWNTO 2);
                ELSIF shamt=3 THEN
                    shiftemp:=shiftemp2(2 DOWNTO 0) & shiftemp(31 DOWNTO 3);
                ELSIF shamt=4 THEN
                    shiftemp:=shiftemp2(3 DOWNTO 0) & shiftemp(31 DOWNTO 4);
                ELSIF shamt=5 THEN
                    shiftemp:=shiftemp2(4 DOWNTO 0) & shiftemp(31 DOWNTO 5);
                ELSIF shamt=6 THEN
                    shiftemp:=shiftemp2(5 DOWNTO 0) & shiftemp(31 DOWNTO 6);
                ELSIF shamt=7 THEN
                    shiftemp:=shiftemp2(6 DOWNTO 0) & shiftemp(31 DOWNTO 7);
                ELSIF shamt=8 THEN
                    shiftemp:=shiftemp2(7 DOWNTO 0) & shiftemp(31 DOWNTO 8);
                ELSIF shamt=9 THEN
                    shiftemp:=shiftemp2(8 DOWNTO 0) & shiftemp(31 DOWNTO 9);
                ELSIF shamt=10 THEN
                    shiftemp:=shiftemp2(9 DOWNTO 0) & shiftemp(31 DOWNTO 10);
                ELSIF shamt=11 THEN
                    shiftemp:=shiftemp2(10 DOWNTO 0) & shiftemp(31 DOWNTO 11);
                ELSIF shamt=12 THEN
                    shiftemp:=shiftemp2(11 DOWNTO 0) & shiftemp(31 DOWNTO 12);
                ELSIF shamt=13 THEN
                    shiftemp:=shiftemp2(12 DOWNTO 0) & shiftemp(31 DOWNTO 13);
                ELSIF shamt=14 THEN
                    shiftemp:=shiftemp2(13 DOWNTO 0) & shiftemp(31 DOWNTO 14);
                ELSIF shamt=15 THEN
                    shiftemp:=shiftemp2(14 DOWNTO 0) & shiftemp(31 DOWNTO 15);
                ELSIF shamt=16 THEN
                    shiftemp:=shiftemp2(15 DOWNTO 0) & shiftemp(31 DOWNTO 16);
                ELSIF shamt=17 THEN
                    shiftemp:=shiftemp2(16 DOWNTO 0) & shiftemp(31 DOWNTO 17);
                ELSIF shamt=18 THEN
                    shiftemp:=shiftemp2(17 DOWNTO 0) & shiftemp(31 DOWNTO 18);
                ELSIF shamt=19 THEN
                    shiftemp:=shiftemp2(18 DOWNTO 0) & shiftemp(31 DOWNTO 19);
                ELSIF shamt=20 THEN
                    shiftemp:=shiftemp2(19 DOWNTO 0) & shiftemp(31 DOWNTO 20);
                ELSIF shamt=21 THEN
                    shiftemp:=shiftemp2(20 DOWNTO 0) & shiftemp(31 DOWNTO 21);
                ELSIF shamt=22 THEN
                    shiftemp:=shiftemp2(21 DOWNTO 0) & shiftemp(31 DOWNTO 22);
                ELSIF shamt=23 THEN
                    shiftemp:=shiftemp2(22 DOWNTO 0) & shiftemp(31 DOWNTO 23);
                ELSIF shamt=24 THEN
                    shiftemp:=shiftemp2(23 DOWNTO 0) & shiftemp(31 DOWNTO 24);
                ELSIF shamt=25 THEN
                    shiftemp:=shiftemp2(24 DOWNTO 0) & shiftemp(31 DOWNTO 25);
                ELSIF shamt=26 THEN
                    shiftemp:=shiftemp2(25 DOWNTO 0) & shiftemp(31 DOWNTO 26);
                ELSIF shamt=27 THEN
                    shiftemp:=shiftemp2(26 DOWNTO 0) & shiftemp(31 DOWNTO 27);
                ELSIF shamt=28 THEN
                    shiftemp:=shiftemp2(27 DOWNTO 0) & shiftemp(31 DOWNTO 28);
                ELSIF shamt=29 THEN
                    shiftemp:=shiftemp2(28 DOWNTO 0) & shiftemp(31 DOWNTO 29);
                ELSIF shamt=30 THEN
                    shiftemp:=shiftemp2(29 DOWNTO 0) & shiftemp(31 DOWNTO 30);
                ELSE
                    shiftemp:=shiftemp2(30 DOWNTO 0) & shiftemp(31 DOWNTO 31);
                END IF;
            END IF;
            alu_out<=shiftemp;
 
        ELSIF alu_op="100011" THEN -- SUBU
        
            alu_out<=alu_in1-alu_in2;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;            
            
        ELSIF alu_op="100111" THEN -- SET ON EQUAL
        
            IF alu_in1 = alu_in2 THEN
                alu_out<="00000000000000000000000000000001";
            ELSE
                alu_out<="00000000000000000000000000000000";
            END IF;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;
            
        ELSIF alu_op="110111" THEN -- SET ON NOT EQUAL 
        
            IF alu_in1 /= alu_in2 THEN
                alu_out<="00000000000000000000000000000001";
            ELSE
                alu_out<="00000000000000000000000000000000";
            END IF;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0; 
            
        ELSE -- bitwise XOR
        
            FOR i IN 0 TO 31 LOOP
                alu_out(i)<=(alu_in1(i) XOR alu_in2(i));
            END LOOP;                
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;
            
        END IF;
        
    END PROCESS aluu;    

END sample;