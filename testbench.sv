// ************************************************************************************************
//
// Copyright(C) 2023 ACCELR
// All rights reserved.
//
// THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF
// ACCELER LOGIC (PVT) LTD, SRI LANKA.
//
// This copy of the Source Code is intended for ACCELR's internal use only and is
// intended for view by persons duly authorized by the management of ACCELR. No
// part of this file may be reproduced or distributed in any form or by any
// means without the written approval of the Management of ACCELR.
//
// ACCELR, Sri Lanka            https://accelr.lk
// No 175/95, John Rodrigo Mw,  info@accelr.net
// Katubedda, Sri Lanka         +94 77 3166850
//
// ************************************************************************************************
//
// PROJECT      :   Memory FIFO
// PRODUCT      :   N/A
// FILE         :   Memory_FIFO_tb.v
// AUTHOR       :   Vilan Jayawardene
// DESCRIPTION  :   Memory FIFO
//
// ************************************************************************************************
//
// REVISIONS:
//
//  Date            Developer     Description
//  -----------     ---------     -----------
//  23-FEB-2023      Vilan        creation
//
//**************************************************************************************************
module Memory_FIFO_tb;

//---------------------------------------------------------------------------------------------------------------------
// Global constant headers
//---------------------------------------------------------------------------------------------------------------------
    

//---------------------------------------------------------------------------------------------------------------------
// parameter definitions
//---------------------------------------------------------------------------------------------------------------------
   

//---------------------------------------------------------------------------------------------------------------------
// localparam definitions
//---------------------------------------------------------------------------------------------------------------------    


//---------------------------------------------------------------------------------------------------------------------
// type definitions
//---------------------------------------------------------------------------------------------------------------------
  

//---------------------------------------------------------------------------------------------------------------------
// I/O signals
//---------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------
// Internal signals
//---------------------------------------------------------------------------------------------------------------------

logic                              clk;
logic                              reset;

logic                              start;
logic                              d_in_ready;
logic                              valid;
logic       [7:0]                  d_in;
//logic                              end_o;

logic       [63:0]                 d_out;
logic                              d_out_ready;
logic                              d_out_valid;

Memory_FIFO uut (
    .clk(clk),
    .reset(reset),
    .d_in(d_in),
    .start(start),
    .d_in_ready(d_in_ready),
    .valid(valid),
//    .end_o(end_o),
    .d_out(d_out),
    .d_out_ready(d_out_ready),
    .d_out_valid(d_out_valid)
);
//---------------------------------------------------------------------------------------------------------------------
// Implementation
//---------------------------------------------------------------------------------------------------------------------
initial begin
    #10; 
    reset          = 1;
    d_in           = 0;
    start          = 0;
    d_out_ready    = 0;
//    end_o          = 0;
    valid          = 0;
    clk            = 0;
    d_in           = 8'b11111111;
    start          = 0;
  
    #10;
    reset          = 0;
    


repeat (50) begin
 // Randomize input values for one clock cycle
    @(posedge clk);
    d_out_ready = ($urandom_range(0, 9) < 1);
    start       = $random;
    valid       = $random;
    d_in        = $random;


    // Hold input values constant for one more clock cycle
    @(negedge clk);
    start       = 0;
    valid       = 0;
    d_in        = 0;
    d_out_ready = 0;
end

    d_out_ready    = 0;
    start          = 0;
//    end_o      = 1;
    valid          = 0;

    #200 $finish;
end
  
always #10 clk = ~clk;

endmodule
