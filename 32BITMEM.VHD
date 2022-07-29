
-- 32 BIT MEMORY

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



------------------------------- ENTITIY -------------------------------------------

ENTITY mem32 IS
    PORT(din : IN std_logic_vector(31 DOWNTO 0);
         addr: IN std_logic_vector(31 DOWNTO 0);
         nrw : IN std_logic;
         dout: OUT std_logic_vector(31 DOWNTO 0)
         );
END mem32;


------------------------------- ARCHITECTURE ------------------------------------------


ARCHITECTURE mem OF mem32 IS
    TYPE reg_bank IS ARRAY (0 TO 4294967296) OF std_logic_vector(31 DOWNTO 0);
    SIGNAL buff : reg_bank;
BEGIN
    PROCESS (addr,din,nrw)
    BEGIN
        IF nrw='0' THEN
            dout<=buff(conv_integer(addr));
        ELSE
            buff(conv_integer(addr))<=din;
        END IF;
    END PROCESS;
END mem;