library verilog;
use verilog.vl_types.all;
entity memory is
    port(
        m_tag           : in     vl_logic_vector(2 downto 0);
        enable          : in     vl_logic;
        w_enable        : in     vl_logic;
        data_in         : in     vl_logic_vector(15 downto 0);
        data_out        : out    vl_logic_vector(15 downto 0)
    );
end memory;
