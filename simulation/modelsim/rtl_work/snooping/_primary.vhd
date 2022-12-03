library verilog;
use verilog.vl_types.all;
entity snooping is
    generic(
        I               : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        S               : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        M               : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        write           : vl_logic := Hi0;
        read            : vl_logic := Hi1;
        write_hit       : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        write_miss      : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        read_hit        : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        read_miss       : vl_logic_vector(0 to 1) := (Hi1, Hi1);
        bus_write_miss  : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        bus_read_miss   : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        bus_ivalidate   : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        NA              : vl_logic_vector(0 to 1) := (Hi1, Hi1);
        T0              : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        T1              : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        T2              : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        T3              : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        T4              : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        clock           : in     vl_logic;
        proc_num        : in     vl_logic_vector(1 downto 0);
        m_tag           : in     vl_logic_vector(2 downto 0);
        tag_position    : in     vl_logic_vector(1 downto 0);
        op              : in     vl_logic;
        data            : in     vl_logic_vector(15 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of I : constant is 1;
    attribute mti_svvh_generic_type of S : constant is 1;
    attribute mti_svvh_generic_type of M : constant is 1;
    attribute mti_svvh_generic_type of write : constant is 1;
    attribute mti_svvh_generic_type of read : constant is 1;
    attribute mti_svvh_generic_type of write_hit : constant is 1;
    attribute mti_svvh_generic_type of write_miss : constant is 1;
    attribute mti_svvh_generic_type of read_hit : constant is 1;
    attribute mti_svvh_generic_type of read_miss : constant is 1;
    attribute mti_svvh_generic_type of bus_write_miss : constant is 1;
    attribute mti_svvh_generic_type of bus_read_miss : constant is 1;
    attribute mti_svvh_generic_type of bus_ivalidate : constant is 1;
    attribute mti_svvh_generic_type of NA : constant is 1;
    attribute mti_svvh_generic_type of T0 : constant is 1;
    attribute mti_svvh_generic_type of T1 : constant is 1;
    attribute mti_svvh_generic_type of T2 : constant is 1;
    attribute mti_svvh_generic_type of T3 : constant is 1;
    attribute mti_svvh_generic_type of T4 : constant is 1;
end snooping;
