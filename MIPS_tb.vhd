ENTITY MIPS_tb IS 
END MIPS_tb;

ENTITY imemory IS
	PORT
	(
		addr_in	:IN std_logic_vector(31 DOWNTO 0);
		d_out	:OUT std_logic_vector(31 DOWNTO 0);		
	);	
END imemory;

ENTITY dmemory IS 
	PORT
	(
		addr_in	:IN std_logic_vector(31 DOWNTO 0);
		d_in	:IN std_logic_vector(31 DOWNTO 0);
		w_en	:IN std_logic_vector(31 DOWNTO 0);
		d_out	:OUT std_logic_vector(31 DOWNTO 0);		
	);
END dmemory;

ARCHITECTURE Prototype OF imemory IS
CONSTANT content IS ("000000000010001000000111111",
					 "000000000010001000000111110")
BEGIN
	d_out	 <= content(conv_integer(addr_in));
END Protype;

ARCHITECTURE Prototype OF dmemory IS
SUBTYPE std_logic_vector(7 DOWNTO 0);
TYPE mem IS ARRAY (0 TO 31) OF Byte;
END Prototype;

ARCHITECTURE mips_tb_behav OF MIPS_tb IS 
COMPONENT dmemory
	PORT
	(
		addr_in	:IN std_logic_vector(31 DOWNTO 0);
		d_in	:IN std_logic_vector(31 DOWNTO 0);
		w_en	:IN std_logic_vector(31 DOWNTO 0);
		d_out	:OUT std_logic_vector(31 DOWNTO 0);
	);
END COMPONENT;

COMPONENT imemory
	PORT
	(
		addr_in	:IN std_logic_vector(31 DOWNTO 0);
		d_out	:OUT std_logic_vector(31 DOWNTO 0);		
	);
END COMPONENT;

COMPONENT core 
	PORT(
			IMdin		:std_logic_vector(31 DOWNTO 0);
			clk 		:std_logic;
			IM_addr_out :std_logic_vector;
			DM_addr_out	:std_logic_vector;
			DM_din		:std_logic_vector;
			DM_dout		:std_logic_vector;
			DM_write	:std_logic
		);
END COMPONENT;
END mips_tb_behav;

