ENTITY mips_core IS
    PORT(
         );
END mips_core;



--_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_--



ARCHITECTURE sample OF mips_core IS


    
    TYPE ram IS ARRAY(0 TO 31) OF std_logic_vector(31 DOWNTO 0);
    SIGNAL rbank : ram;
    SIGNAL readreg1,readreg2,writereg : std_logic_vector(4 DOWNTO 0);
    SIGNAL regdst,wreg,alusrc,pcsrc,memtoreg : std_logic;
    SIGNAL aluin2,alures,alutempres : std_logic_vector (31 DOWNTO 0);
    SIGNAL opcode,aluop : std_logic_vector (5 DOWNTO 0);
    
BEGIN



    
    --************************************************
    --************************************************ ALU PROCESS
    --************************************************


   aluu: PROCESS (readdata1,aluin2,aluop)
        VARIABLE shiftemp,shiftemp2 : std_logic_vector(31 DOWNTO 0);
        VARIABLE shamt : integer;
    BEGIN
    
        IF aluop="100001" THEN
            alures<=readdata1+aluin2;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');            
        ELSIF aluop="100100" THEN
            FOR i IN 0 TO 31 LOOP
                alures(i)<= (readdata1(i) AND aluin2(i));
            END LOOP;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
        ELSIF aluop="100101" THEN
            FOR i IN 0 TO 31 LOOP
                alures(i)<=(readdata1(i) OR aluin2(i));
            END LOOP;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
        ELSIF aluop="000000" THEN
            shiftemp2:=(OTHERS=>'0');
            shamt:=conv_integer(aluin2);
            IF shamt=0 THEN
                shiftemp:=readdata1;
            ELSIF shamt>31 THEN
                shiftemp:=shiftemp2;
            ELSE
                shiftemp:=readdata1;
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
            alures<=shiftemp;
        ELSIF aluop="000100" THEN
            shiftemp2:=(OTHERS=>'0');
            shamt:=conv_integer(readdata1);
            IF shamt=0 THEN
                shiftemp:=aluin2;
            ELSIF shamt>31 THEN
                shiftemp:=shiftemp2;
            ELSE
                shiftemp:=aluin2;
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
            alures<=shiftemp;
        ELSIF aluop="101011" THEN
            IF readdata1<aluin2 THEN
                alures<="00000000000000000000000000000001";
            ELSE
                alures<="00000000000000000000000000000000";
            END IF;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
        ELSIF aluop="000010" THEN
            shiftemp2:=(OTHERS=>'0');
            shamt:=conv_integer(aluin2);
            IF shamt=0 THEN
                shiftemp:=readdata1;
            ELSIF shamt>31 THEN
                shiftemp:=shiftemp2;
            ELSE
                shiftemp:=readdata1;
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
            alures<=shiftemp;
        ELSIF aluop="000110" THEN
            shiftemp2:=(OTHERS=>'0');
            shamt:=conv_integer(readdata1);
            IF shamt=0 THEN
                shiftemp:=aluin2;
            ELSIF shamt>31 THEN
                shiftemp:=shiftemp2;
            ELSE
                shiftemp:=aluin2;
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
            alures<=shiftemp;
        ELSIF aluop="100011" THEN
            alures<=readdata1-aluin2;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
        ELSE
            FOR i IN 0 TO 31 LOOP
                alures(i)<=(readdata1(i) XOR aluin2(i));
            END LOOP;                
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
        END IF;
        
    END PROCESS aluu;






    --************************************************
    --***************************************************** REGISTER BANK PROCESS
    --************************************************
    
    reg_bank: PROCESS(readreg1,readreg2,writereg,wreg,writedata)
    BEGIN
        readdata1<=rbank(conv_integer(readreg1));
        readdata2<=rbank(conv_integer(readreg2));
        IF wreg='1' THEN
            rbank(conv_integer(writereg))<=writedata;
        END IF;
    END PROCESS reg_bank;
    
    
    
    
    
    
    
    --************************************************
    --***************************************************** CONTROL PROCESS
    --************************************************
    
END sample;