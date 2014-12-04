

typedef enum{
    A_SEL,      // sel == 00
    C_SEL,      // sel == 01
    B_SEL       // sel == 10
} sele_t;


module mux_tb();
    import alu_pkg::*;
    import types_pkg::*;

    
    integer             testiteration = 0;
    integer             failure_counta = 0;
    integer             failure_countb = 0;
    integer             failure_countc = 0;
    
    logic               is3way;
    integer             size; 
    sele_t               sel;
    logic [1:0]        select;
    logic [15:0]     input_a;
    logic [15:0]     input_b;
    logic [15:0]     input_c;
    wire  [15:0]     output_a;
    wire  [15:0]     output_b;
    wire  [1:0]     output_c;



    // 16-bit mux with 3 inputs
    mux #(
        .SIZE(16), 
        .IS3WAY(1)
    )duta(
        .sel(select),
        .in1(input_a),
        .in2(input_b),
        .in3(input_c),

        .out(output_a)
    );

    // 16bit mux with 2 inputs
    mux #(
        .SIZE(16), 
        .IS3WAY(0)
    )dutb(
        .sel(select[0]),
        .in1(input_a),
        .in2(input_b),
        .in3(input_c),

        .out(output_b)
    );
    
    // 2 bit mux with 2 inputs
    mux #(
        .SIZE(2), 
        .IS3WAY(0)
    )dutc(
        .sel(select[0]),
        .in1(input_a[1:0]),
        .in2(input_b[1:0]),
        .in3(input_c[1:0]),

        .out(output_c)
    );
    assign select = sel;
    initial begin
        //| system wide reset
        //| =============================================================
        $xzcheckoff;
        $vcdpluson; //make that dve database
        $vcdplusmemon;
        size = 32'd16;
        is3way = 1'b1;
        sel = A_SEL;
        input_a = 16'h000f;
        input_b = 16'h00f1;
        input_c = 16'h0f02;
        #1
            // input_a should be on the output
            if(output_a != input_a) failure_counta++;
            if(output_b != input_a) failure_countb++;
            if(output_c != input_a[1:0]) failure_countc++;

        #5  size = 32'd16;
            is3way = 1'b1;
            sel = B_SEL;
        #1
            // input_b should be on the output
            if(output_a != input_b) failure_counta++;
            

        #5  size = 32'd16;
            is3way = 1'b1;
            sel = C_SEL;
        #1
            // input_c should be on the output
            if(output_a != input_c) failure_counta++;
            if(output_b != input_b) failure_countb++;
            if(output_c != input_b[1:0]) failure_countc++;
        #5  
        $display("Number of unexpected results for a: %d", failure_counta);
        $display("Number of unexpected results for b: %d", failure_countb);
        $display("Number of unexpected results for c: %d", failure_countc);
        $finish;
    end
endmodule
