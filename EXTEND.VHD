TYPE extend_type IS (unsigned_im,shmt);
SIGNAL extend_case : extend_type;
SIGNAL extend_in : std_logic_vector(15 DOWNTO 0);
SIGNAL extend_out : std_logic_vector(31 DOWNTO 0);


    extend: PROCESS(extend_in,extend_case)
    BEGIN
        IF extend_case=unsigned_im THEN
            extend_out<="0000000000000000" & extend_in;
        ELSE
            extend_out<="00000000000000000000000000" & extend_in(10 DOWNTO 6);
        END IF;
    END PROCESS extend;
