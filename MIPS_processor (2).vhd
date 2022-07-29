LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY core IS
	PORT(
			IMdin		: IN std_logic_vector(31 DOWNTO 0);
			clk 		: IN std_logic;
			IM_addr_out : OUT std_logic_vector(31 DOWNTO 0);
			DM_addr_out	:OUT  std_logic_vector(31 DOWNTO 0);
			DM_din		: IN std_logic_vector (31 DOWNTO 0);
			DM_dout		: OUT std_logic_vector(31 DOWNTO 0);
			DM_write	:OUT std_logic
		);
END core;



ARCHITECTURE arc1 OF core IS 


----Types

TYPE ram IS ARRAY(0 TO 31) OF std_logic_vector(31 DOWNTO 0);

TYPE 	t_ALU_in2_sel IS (s_rrd2,s_ex_imm);
TYPE 	t_write_reg_data_sel IS (from_alu ,from_mem);
TYPE 	t_rwe IS (rw_en,rw_dis); 
TYPE 	t_JBP IS (proceed,branch,jump);
TYPE	t_ext_case IS (ex_i,ex_j,ex_shamt);
---------

----signals

SIGNAL rbank : ram;--- register file

------fetch signals
SIGNAL pc : std_logic_vector(31 DOWNTO 0);
SIGNAL tpc : std_logic_vector(31 DOWNTO 0);
------decode signals
SIGNAL read_reg1 : std_logic_vector(4 DOWNTO 0);
SIGNAL read_reg2 : std_logic_vector(4 DOWNTO 0);
SIGNAL rs :std_logic_vector(4 DOWNTO 0);
SIGNAL rt : std_logic_vector(4 DOWNTO 0);
SIGNAL rd : std_logic_vector(4 DOWNTO 0);
SIGNAL func : std_logic_vector(5 DOWNTO 0);
SIGNAL op_code : std_logic_vector(5 DOWNTO 0);
------execute signals
SIGNAL ALU_in1 : std_logic_vector(31 DOWNTO 0);
SIGNAL ALU_in2 : std_logic_vector(31 DOWNTO 0);
SIGNAL ALU_out : std_logic_vector(31 DOWNTO 0);
SIGNAL write_reg_data : std_logic_vector(31 DOWNTO 0);
SIGNAL shamt : std_logic_vector(4 DOWNTO 0);
SIGNAL imm : std_logic_vector(15 DOWNTO 0);
SIGNAL j_addr : std_logic_vector(25 DOWNTO 0);
SIGNAL ex_imm : std_logic_vector(31 DOWNTO 0);
SIGNAL rpc : std_logic_vector(31 DOWNTO 0);
SIGNAL JB_flag : std_logic;
------fetch latched signals
SIGNAL f_instr : std_logic_vector(31 DOWNTO 0); 
SIGNAL f_npc : std_logic_vector(31 DOWNTO 0);
------decode latched signals
SIGNAL d_instr : std_logic_vector(31 DOWNTO 0);
SIGNAL d_npc : std_logic_vector(31 DOWNTO 0);
SIGNAL d_rwe : t_rwe;
SIGNAL d_ALU_op : std_logic_vector(5 DOWNTO 0);
SIGNAL d_JBP : t_JBP;
SIGNAL d_ext_case : t_ext_case; 
SIGNAL d_write_reg_data_sel : t_write_reg_data_sel;
SIGNAL d_reg_read_data1 : std_logic_vector(31 DOWNTO 0);
SIGNAL d_reg_read_data2 : std_logic_vector(31 DOWNTO 0);
SIGNAL d_write_reg : std_logic_vector(4 DOWNTO 0);
SIGNAL d_ALU_in2_sel: t_ALU_in2_sel;
SIGNAL d_DM_write : std_logic;

------execute latched signals

SIGNAL x_instr : std_logic_vector(31 DOWNTO 0);
SIGNAL x_npc : std_logic_vector(31 DOWNTO 0);
SIGNAL x_rwe : t_rwe;
SIGNAL x_ALU_op : std_logic_vector(5 DOWNTO 0);
SIGNAL x_JBP : t_JBP;
SIGNAL x_ext_case : t_ext_case; 
SIGNAL x_write_reg_data_sel : t_write_reg_data_sel;
SIGNAL x_reg_read_data1 : std_logic_vector(31 DOWNTO 0);
SIGNAL x_reg_read_data2 : std_logic_vector(31 DOWNTO 0);
SIGNAL x_write_reg : std_logic_vector(4 DOWNTO 0);
SIGNAL x_ALU_in2_sel : t_ALU_in2_sel;
SIGNAL x_DM_write: std_logic;

------------------------------








BEGIN

-------------------------------------------Pipeline
pipeline_move : PROCESS(clk)
BEGIN

	IF clk = '1' THEN 
		
		pc <= tpc; --------- change pc
		
		-------------------- fetch to decode
		
		d_instr <= f_instr;
		d_npc <= f_npc; 
		
		-------------------- decode to execute
		x_instr <= d_instr; 
		x_npc <= d_npc;
		x_rwe <= d_rwe ;
		x_ALU_op <= d_ALU_op;
		x_JBP <= d_JBP;
		x_ext_case <=  d_ext_case; 
		x_write_reg_data_sel <=  d_write_reg_data_sel;
		x_reg_read_data1 <= d_reg_read_data1;
		x_reg_read_data2 <= d_reg_read_data2;
		x_write_reg <= d_write_reg;
		
	END IF;
	
END PROCESS pipeline_move;

---------------------------------------------------


----------------------------------------------fetch

f_npc <= pc + 1;

IM_addr_out <= pc;

tpc  <= rpc WHEN JB_flag = '1' ELSE
		f_npc;

f_instr <= IMdin;

---------------------------------------------------



---------------------------------------------decode

DCD : PROCESS(d_instr,rs,rt,rd,func,op_code)
BEGIN
	IF (op_code = "000000") THEN--R-Type instructions
		IF (func = "000000") OR (func = "000010") OR (func = "000011") THEN--shift by shamt
			d_ALU_in2_sel <= s_rrd2;
			d_ext_case <= ex_shamt;
			d_write_reg_data_sel <= from_alu;
			d_rwe <= rw_en;
			d_JBP <= proceed;
			d_write_reg <= rd;
		ELSIF (func = "000100") OR (func = "000110") THEN--shift by reg (shift variable)
			d_ALU_in2_sel <= s_rrd2;
			d_ext_case <= ex_shamt;
			d_write_reg_data_sel <= from_alu;
			d_rwe <= rw_en;
			d_JBP <= proceed;
			d_write_reg <= rd;		
		ELSIF (func = "001000" ) THEN -- jump register
			d_ALU_in2_sel <= s_rrd2;
			d_write_reg_data_sel <= from_alu;
			d_rwe <= rw_dis;
			d_JBP <= jump;
			d_write_reg	<= rd;
			d_ext_case <= ex_shamt;	
		ELSE --Register-Register Arith
			d_ALU_in2_sel <= s_rrd2;
			d_write_reg_data_sel <= from_alu;
			d_rwe <= rw_en;
			d_JBP <= proceed;
			d_write_reg	<= rd;
			d_ext_case <= ex_shamt;
		END IF;
		d_ALU_op <= func;
		d_DM_write <= '0';
	ELSIF (op_code = "001000") OR (op_code = "001001") OR (op_code = "001100") OR (op_code = "001101") OR (op_code = "001010") OR (op_code = "001011") OR (op_code ="001110")  THEN--Regiter-immediate arith
		d_ALU_in2_sel <= s_ex_imm;
		d_ext_case <= ex_i;
		d_write_reg_data_sel <= from_alu;
		d_rwe <= rw_en;
		d_JBP <= proceed;
		d_write_reg <= rt;
		d_DM_write <= '0';
		d_ALU_op <= "100" & op_code(2 DOWNTO 0);
	ELSIF (op_code = "001011") THEN --  SET ON LESS THAN IMM
        d_ALU_in2_sel <= s_ex_imm;
        d_ext_case <= ex_i;
        d_write_reg_data_sel <= from_alu;
        d_rwe <= rw_en;
        d_JBP <= proceed;
        d_write_reg <= rt;
        d_DM_write <= '0';
        d_ALU_op <= "101011";
	ELSIF (op_code = "100011" ) THEN--load word
		d_ALU_in2_sel <= s_ex_imm;
		d_write_reg_data_sel <= from_mem ;
		d_rwe <= rw_en;
		d_JBP <= proceed;
		d_write_reg <= rt;
		d_ext_case <= ex_i;
		d_DM_write <= '0';
		d_ALU_op <= "100001";
	ELSIF (op_code = "101011") THEN--store word
		d_ALU_in2_sel <= s_ex_imm;
		d_write_reg_data_sel <= from_mem ;	
		d_rwe <= rw_dis;
		d_JBP <= proceed;
		d_write_reg <= rt;
		d_DM_write <= '1';
		d_ext_case <= ex_i;
		d_ALU_op <= "100001";
	ELSIF (op_code = "000100") THEN-- branch on equal 
		d_ALU_in2_sel <= s_rrd2;
		d_write_reg_data_sel <= from_mem ;
		d_rwe <= rw_dis;
		d_JBP <= branch;
		d_write_reg <= rd;
		d_ext_case <= ex_i;
		d_DM_write <= '0';
		d_ALU_op <= "100111";
	ELSIF (op_code = "000101")  THEN -- branch on not equal
		d_ALU_in2_sel <= s_rrd2;
		d_write_reg_data_sel <= from_mem ;
		d_rwe <= rw_dis;
		d_JBP <= branch;
		d_write_reg <= rd;
		d_ext_case <= ex_i;
		d_DM_write <= '0';
		d_ALU_op <= "110111";		
	ELSIF (op_code = "000010" ) THEN--jump
		d_ALU_in2_sel <= s_ex_imm;
		d_write_reg_data_sel <= from_mem ;
		d_rwe <= rw_dis;
		d_JBP <= jump;
		d_write_reg <= "11111";
		d_ext_case <= ex_j;
		d_DM_write <= '0';
		d_ALU_op <= "011011";
	ELSIF (op_code = "000011") THEN--jump and link
		d_ALU_in2_sel <= s_ex_imm;
		d_write_reg_data_sel <= from_alu;
		d_rwe <= rw_en;
		d_JBP <= jump;
		d_write_reg <= "11111";
		d_ext_case <= ex_j;
		d_DM_write <= '0';
		d_ALU_op <= "011011";
	ELSE--
		d_ALU_in2_sel <= s_ex_imm;
		d_write_reg_data_sel <= from_mem;
		d_rwe <= rw_dis;
		d_JBP <= proceed;
		d_write_reg <= "11111";
		d_ext_case <= ex_j;
		d_DM_write <= '0';
		d_ALU_op <= "011011";
	END IF;
		read_reg1	<= rs;
		read_reg2	<= rt;
		
END PROCESS DCD;


------------------Register File
    reg_bank: PROCESS(read_reg1,read_reg2,x_write_reg, x_rwe,write_reg_data)
	--    VARIABLE rbank : ram;
    BEGIN
        d_reg_read_data1<=rbank(conv_integer(read_reg1));
        d_reg_read_data2<=rbank(conv_integer(read_reg2));
        IF ((x_rwe = rw_en) AND (conv_integer(x_write_reg) /= 0))THEN
            rbank(conv_integer(x_write_reg)) <= write_reg_data;
        END IF;
    END PROCESS reg_bank;
	rbank(0)  <= (OTHERS => '0');
------------------------------

--fixed connection
	rs	<= d_instr(25 DOWNTO 21);
	rt	<= d_instr(20 DOWNTO 16);
	rd	<= d_instr(15 DOWNTO 11);
	func <= d_instr(5 DOWNTO 0);
	op_code <= d_instr(31 DOWNTO 26);
---------------------------------------------------




	
--------------------------------------------execute


------ MUX s cotrolled by conrol signals

	imm  <= x_instr(15 DOWNTO 0);
	j_addr <= x_instr(25 DOWNTO 0);

	shamt <= x_instr(10 DOWNTO 6);

	ALU_in1 <=	x_reg_read_data1;-----first ALU input MUX 
	
	ALU_in2 <=	x_reg_read_data2 WHEN (x_ALU_in2_sel = s_rrd2) ELSE -- second ALU input MUX 
				ex_imm;
			
	write_reg_data <=	ALU_out WHEN x_write_reg_data_sel = from_alu ELSE -- write back data MUX
						DM_din;
					
	rpc <= 	ex_imm + x_npc WHEN  x_JBP = branch ELSE -- JUMP or BRANCH adress MUX 
			ALU_out;
			
	JB_flag <= '1' WHEN (x_JBP = jump) OR (x_JBP = branch AND ALU_out(0) = '1' ) ELSE -- JUMP/BRANCH  flag
				'0';

		
		
----- extender

	ex_imm	<=	"0000000000000000" & imm WHEN(x_ext_case = ex_i) ELSE
				"000000000000000000000000000" & shamt WHEN x_ext_case = ex_shamt ELSE 
				"000000" & j_addr WHEN x_ext_case = ex_j ELSE
				X"00000000";
				
--------------	


----- fixed connections 

	DM_addr_out <= ALU_out;
	DM_dout <= x_reg_read_data1;
	DM_write <= x_DM_write;
	
-----------------------


----- ALU


	alu: PROCESS (ALU_in1,ALU_in2, x_ALU_op)
        VARIABLE shiftemp,shiftemp2 : std_logic_vector(31 DOWNTO 0);
        VARIABLE shamt : integer;
    BEGIN
    
        IF x_ALU_op="100001" THEN -- ADDU / ADDIU
        
            ALU_out<=ALU_in1+ALU_in2;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;
            
        ELSIF x_ALU_op="100100" THEN -- bitwise AND / ANDI
        
            FOR i IN 0 TO 31 LOOP
                ALU_out(i)<= (ALU_in1(i) AND ALU_in2(i));
            END LOOP;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;
            
        ELSIF x_ALU_op="100101" THEN -- bitwise OR / ORI
        
            FOR i IN 0 TO 31 LOOP
                ALU_out(i)<=(ALU_in1(i) OR ALU_in2(i));
            END LOOP;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;
            
        ELSIF (x_ALU_op="000000") OR (x_ALU_op="000100") THEN -- SHIFT LEFT LOGICAL , SLL / SLLV
        
            shiftemp2:=(OTHERS=>'0');
            shamt:=conv_integer(ALU_in2);
            IF shamt=0 THEN
                shiftemp:=ALU_in1;
            ELSIF shamt>31 THEN
                shiftemp:=shiftemp2;
            ELSE
                shiftemp:=ALU_in1;
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
            ALU_out<=shiftemp;
            
        ELSIF x_ALU_op="101011" THEN -- SET ON LESS THAN , SLT
        
            IF ALU_in1<ALU_in2 THEN
                ALU_out<="00000000000000000000000000000001";
            ELSE
                ALU_out<="00000000000000000000000000000000";
            END IF;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;
            
        ELSIF (x_ALU_op="000010") OR (x_ALU_op="000110") THEN -- SHIFT RIGHT LOGICAL , SRL / SRLV
        
            shiftemp2:=(OTHERS=>'0');
            shamt:=conv_integer(ALU_in2);
            IF shamt=0 THEN
                shiftemp:=ALU_in1;
            ELSIF shamt>31 THEN
                shiftemp:=shiftemp2;
            ELSE
                shiftemp:=ALU_in1;
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
            ALU_out<=shiftemp;
 
        ELSIF x_ALU_op="100011" THEN -- SUBU
        
            ALU_out<=ALU_in1-ALU_in2;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0; 
            
        ELSIF x_ALU_op="100111" THEN -- SET ON EQUAL
        
            IF ALU_in1 = ALU_in2 THEN
                ALU_out<="00000000000000000000000000000001";
            ELSE
                ALU_out<="00000000000000000000000000000000";
            END IF;
            
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;
            
            
        ELSIF x_ALU_op="110111" THEN -- SET ON NOT EQUAL 
        
            IF ALU_in1 /= ALU_in2 THEN
                ALU_out<="00000000000000000000000000000001";
            ELSE
                ALU_out<="00000000000000000000000000000000";
            END IF;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0; 
            
        ELSIF x_ALU_op="011001" THEN -- USE FOR JUMP  OUTPUT : ALU_in1 
        
            ALU_out<=ALU_in1;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;  
            
        ELSIF x_ALU_op="011011" THEN -- USE FOR JUMP  OUTPUT : ALU_in2 
        
            ALU_out<=ALU_in2;
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;  
            
        ELSE -- bitwise XOR
        
            FOR i IN 0 TO 31 LOOP
                ALU_out(i)<=(ALU_in1(i) XOR ALU_in2(i));
            END LOOP;                
            shiftemp2:=(OTHERS=>'0');
            shiftemp:=(OTHERS=>'0');
            shamt:=0;
            
        END IF;
        
    END PROCESS alu;
END arc1;

---------