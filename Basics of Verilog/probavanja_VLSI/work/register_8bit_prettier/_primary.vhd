library verilog;
use verilog.vl_types.all;
entity register_8bit_prettier is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ld              : in     vl_logic;
        inc             : in     vl_logic;
        dec             : in     vl_logic;
        \in\            : in     vl_logic_vector(7 downto 0);
        \out\           : out    vl_logic_vector(7 downto 0)
    );
end register_8bit_prettier;
