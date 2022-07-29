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

TYPE ram IS ARRAY(0 TO 31) OF std_logic_vector(31 DOWNTO 0);

TYPE	t_ALU_in1_sel IS  (s_rrd1);
TYPE 	t_ALU_in2_sel IS (s_rrd2);
TYPE 	t_write_reg_data_sel IS (from_alu);
TYPE 	t_rwe IS (rw_en,rw_dis); 
TYPE 	t_npc_sel IS (pc_advance);

	    SIGNAL rbank : ram;

SIGNAL instr : std_logic_vector(31 DOWNTO 0);
SIGNAL ALU_in1, ALU_in2,ALU_out	:std_logic_vector(31 DOWNTO 0);
SIGNAL ALU_in1_sel	:t_ALU_in1_sel;
SIGNAL ALU_in2_sel	:t_ALU_in2_sel;
SIGNAL write_reg_data_sel	: t_write_reg_data_sel;
SIGNAL rwe	:t_rwe;
SIGNAL read_reg1	:std_logic_vector(4 DOWNTO 0);
SIGNAL read_reg2	:std_logic_vector(4 DOWNTO 0);
SIGNAL write_reg	:std_logic_vector(4 DOWNTO 0);
SIGNAL write_reg_data :std_logic_vector(31 DOWNTO 0);
SIGNAL reg_read_data1 :std_logic_vector(31 DOWNTO 0);
SIGNAL reg_read_data2 :std_logic_vector(31 DOWNTO 0);
SIGNAL rs	:std_logic_vector(4 DOWNTO 0);
SIGNAL rt	:std_logic_vector(4 DOWNTO 0);
SIGNAL rd	:std_logic_vector(4 DOWNTO 0);

SIGNAL pc	:std_logic_vector(31 DOWNTO 0);
SIGNAL npc	:std_logic_vector(31 DOWNTO 0);
SIGNAL npc_sel :t_npc_sel;
BEGIN


--fetch
IM_addr_out <= pc;
--decode
DCD : PROCESS(instr,rs,rt,rd)
BEGIN
	IF (instr(31 DOWNTO 26)= "000000") THEN--R-Type instructions
		ALU_in1_sel <= s_rrd1;
		ALU_in2_sel <= s_rrd2;
		write_reg_data_sel <= from_alu;
		rwe <= rw_en;
		npc_sel <= pc_advance;
		read_reg1	<= rs;
		read_reg2	<= rt;
		write_reg	<= rd;
--	ELSIF (instr(31 DOWNTO 26)=)--signed immediate arith
--	ELSIF (instr(31 DOWNTO 26)=)--unsigned immediate arith
--	ELSIF (instr(31 DOWNTO 26)=)--Load
--	ELSIF (instr(31 DOWNTO 26)=)--store
--	ELSIF (instr(31 DOWNTO 26)=)--branch
	END IF; 
	
END PROCESS;

    reg_bank: PROCESS(read_reg1,read_reg2,write_reg,rwe,write_reg_data)
	--    VARIABLE rbank : ram;
    BEGIN
			 rbank(0)  <= (OTHERS => '0');
        reg_read_data1<=rbank(conv_integer(read_reg1));
        reg_read_data2<=rbank(conv_integer(read_reg2));
        IF ((rwe = rw_en ) AND (conv_integer(write_reg) /= 0))THEN
            rbank(conv_integer(write_reg)) <= write_reg_data;
        END IF;
    END PROCESS reg_bank;
--fixed connection
	rs	<= instr(25 DOWNTO 21);
	rt	<= instr(20 DOWNTO 16);
	rd	<= instr(15 DOWNTO 11);
--Xecute

ALU_in1 <= reg_read_data1;
ALU_in2 <= reg_read_data2;--when aluin1_sel = 
write_reg_data <= ALU_out;--WHEN RW_sel = from alu
npc <= pc + 4;
--fixed connections 
DM_addr_out <= ALU_out;
ALU_out <= ALU_in1 + ALU_in2;


proceed : PROCESS(clk)
BEGIN
	pc <= npc;	
END PROCESS;

END arc1;

