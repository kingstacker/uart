//************************************************
//  Filename      : uart_top.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   :                              
//************************************************
module  uart_top (
/*i*/   input    wire    clk          ,
        input    wire    rst_n        ,
        input    wire    rx           ,
/*o*/   output   wire    tx           
);
wire rx_done;
wire [7:0] data_o;
//uart_rx inst;
uart_rx  uart_rx_u1( 
    .clk                (clk),
    .rst_n              (rst_n),
    .bps_set            (3'd0),
    .rx                 (rx),
    .data_o             (data_o),
    .rx_done            (rx_done)
);
//uart_tx inst;
uart_tx  uart_tx_u1( 
    .clk                (clk),
    .rst_n              (rst_n),
    .send_en            (rx_done),
    .bps_set            (3'd0),
    .data_i             (data_o),
    .tx                 (tx),
    .tx_done            ()
);

endmodule