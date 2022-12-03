library verilog;
use verilog.vl_types.all;
entity testbench is
    generic(
        I               : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        S               : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        M               : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        write           : vl_logic := Hi0;
        read            : vl_logic := Hi1
    );
    port(
        PX_tag          : out    vl_logic_vector(2 downto 0);
        PX_status       : out    vl_logic_vector(1 downto 0);
        PX_data         : out    vl_logic_vector(15 downto 0);
        MEM_000         : out    vl_logic_vector(15 downto 0);
        MEM_001         : out    vl_logic_vector(15 downto 0);
        MEM_010         : out    vl_logic_vector(15 downto 0);
        MEM_011         : out    vl_logic_vector(15 downto 0);
        MEM_100         : out    vl_logic_vector(15 downto 0);
        MEM_101         : out    vl_logic_vector(15 downto 0);
        MEM_110         : out    vl_logic_vector(15 downto 0);
        MEM_111         : out    vl_logic_vector(15 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of I : constant is 1;
    attribute mti_svvh_generic_type of S : constant is 1;
    attribute mti_svvh_generic_type of M : constant is 1;
    attribute mti_svvh_generic_type of write : constant is 1;
    attribute mti_svvh_generic_type of read : constant is 1;
end testbench;
