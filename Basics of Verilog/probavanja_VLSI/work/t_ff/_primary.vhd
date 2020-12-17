library verilog;
use verilog.vl_types.all;
entity t_ff is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        t               : in     vl_logic;
        q               : out    vl_logic
    );
end t_ff;
