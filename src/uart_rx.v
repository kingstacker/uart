//************************************************
//  Filename      : uart_rx.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   : uart rx module;                             
//************************************************
module  uart_rx (
/*i*/   input    wire             clk                  ,
        input    wire             rst_n                ,
        input    wire    [2:0]    bps_set              ,
        input    wire             rx                   ,
/*o*/   output   wire    [7:0]    data_o               ,
        output   wire             rx_done              
);
reg  rx_reg0;
reg  rx_reg1;
reg  rx_temp0;
reg  rx_temp1;
reg  bps_clk;
reg  bps_en;
wire rx_neg;
reg [8:0] bps;
reg [8:0] bps_cnt;
reg [7:0] cnt;
reg rx_done_reg;
reg [7:0] data_o_reg;
reg [7:0] data_o_reg1;
always @(posedge clk or negedge rst_n) begin //syn rx;
    if (~rst_n) begin
        rx_reg0 <= 0;
        rx_reg1 <= 0;
    end //if
    else begin
        rx_reg0 <= rx;
        rx_reg1 <= rx_reg0;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin //neg;
    if (~rst_n) begin
        rx_temp0 <= 0;
        rx_temp1 <= 0;
    end //if
    else begin
        rx_temp0 <= rx_reg1;
        rx_temp1 <= rx_temp0;    
    end //else
end //always
assign rx_neg = (~rx_temp0)&&rx_temp1;
//bps select;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        bps <= 9'd324; //324
    end //if
    else begin
        case (bps_set)
                3'd0:    bps <= 9'd324;  //9600bps/s;   
                3'd1:    bps <= 9'd162;  //19200bps/s;
                3'd2:    bps <= 9'd80 ;  //38400bps/s;
                3'd3:    bps <= 9'd53 ;  //57600bps/s;
                3'd4:    bps <= 9'd26 ;  //115200bps/s;
                default: bps <= 9'd324;
            endcase //case    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin //bps_cnt;
    if (~rst_n) begin
        bps_cnt <= 0;
    end //if
    else begin
        if (bps_en == 1'b1) begin
        	bps_cnt <= (bps_cnt == bps) ? 9'd0 : bps_cnt + 1'b1;
        end
        else begin
            bps_cnt <= 0;    	
        end    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin //bps_clk;
    if (~rst_n) begin
        bps_clk <= 0;
    end //if
    else begin
        if (bps_cnt == 9'd1) begin
        	bps_clk <= 1'b1;
        end 
        else begin
            bps_clk <= 1'b0;   	
        end   
    end //else
end //always
always @(posedge clk or negedge rst_n) begin //cnt;
    if (~rst_n) begin
        cnt <= 0;
    end //if
    else begin
        if (bps_en == 1'b1) begin
        	cnt <= (bps_clk == 1'b1) ? cnt + 1'b1 : cnt;
        end
        else begin
            cnt <= 0;    	
        end    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        bps_en <= 0;
    end //if
    else begin
        if (rx_neg == 1'b1) begin
        	bps_en <= 1'b1;
        end    
        else begin
        	bps_en <= (cnt == 8'd159 || (cnt == 8'd7 && (rx_reg1))) ? 1'b0 : bps_en;
        end
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        rx_done_reg <= 1'b0;
        data_o_reg  <= 0;
    end //if
    else begin
        case (cnt)
            0  : begin rx_done_reg   <= 1'b0; end 
            23 : begin data_o_reg[0] <= rx_reg1; end 
      	    39 : begin data_o_reg[1] <= rx_reg1; end 
      	    55 : begin data_o_reg[2] <= rx_reg1; end 
      	    71 : begin data_o_reg[3] <= rx_reg1; end 
      	    87 : begin data_o_reg[4] <= rx_reg1; end 
      	    103: begin data_o_reg[5] <= rx_reg1; end 
      	    119: begin data_o_reg[6] <= rx_reg1; end 
      	    135: begin data_o_reg[7] <= rx_reg1; end 
      	    159: begin rx_done_reg   <= 1'b1; end 
      	    default: ;
        endcase //case    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_o_reg1 <= 0;
    end //if
    else begin
        data_o_reg1 <= (cnt == 8'd159) ? data_o_reg : data_o_reg1;    
    end //else
end //always
assign rx_done = rx_done_reg;
assign data_o  = data_o_reg1;

endmodule




