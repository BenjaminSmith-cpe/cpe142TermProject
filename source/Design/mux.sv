module mux
    #(parameter SIZE = 16, parameter IS3WAY = 1)(
    input wire [IS3WAY:0]       sel,

    input wire [(SIZE - 1):0]   in1,
    input wire [(SIZE - 1):0]   in2,
    input wire [(SIZE - 1):0]   in3,

    output logic [(SIZE - 1):0] out
);

    always_comb begin
        if(IS3WAY) begin        //3 to one mux
            case (sel)      
                2'b00:
                    out = in1;
                2'b10:
                    out = in2;
                2'b01:
                    out = in3;
                2'b11: begin
                    out = 32'bX;
                end
            endcase
        end
        else begin
            case (sel)          // 2 to one mux
                1'b0:
                    out = in1;
                1'b1:
                    out = in2;
            endcase
        end
    end
endmodule
