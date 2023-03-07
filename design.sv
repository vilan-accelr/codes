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
// FILE         :   Memory_FIFO.v
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
`timescale 1ns / 1ps

module Memory_FIFO(
    input           logic              clk,
    input           logic              reset,

    input           logic[7:0]         d_in,
    input           logic              start,
    input           logic              valid,
    input           logic              d_out_ready,

    output          logic[63:0]        d_out,
    output          logic              d_out_valid,
    output          logic              d_in_ready
);

//---------------------------------------------------------------------------------------------------------------------
// Internal signals
//---------------------------------------------------------------------------------------------------------------------
    logic                 [63:0]          mem_reg ;
    logic                 [7:0]           count_adder;
    typedef enum          logic[2:0]      {IDLE,PUT_DATA,WAIT_1}state_t;
    state_t                               state;

    parameter            PUT_LENGTH       =8;
//---------------------------------------------------------------------------------------------------------------------
// Implementation
//---------------------------------------------------------------------------------------------------------------------
    always @(posedge clk) begin
        if (reset )begin
            d_out_valid   <= 1'b0;
            d_out         <= 1'b0;
            count_adder   <= 1'b0;
            d_in_ready    <= 1'b1;
            state         <=IDLE;
        end
         
        else begin
            case (state)
                IDLE: begin 
                count_adder <= 1'b0;
               
                    if (start & valid) begin
                        d_out_valid <= 1'b0;
                        mem_reg     <= d_in;
                        state       <= PUT_DATA;   
                    end
                end
                PUT_DATA: begin 
                    if (valid & d_in_ready) begin
                        count_adder <= count_adder + 1;
                        mem_reg     <= (mem_reg<<8)|d_in;
                    end 
                        
                    if (count_adder == PUT_LENGTH-1)begin
                        d_in_ready  <= 1'b0;
                        d_out       <= mem_reg;
                        d_out_valid <= 1'b1;
                        state       <= WAIT_1;
                    end 
                end
                WAIT_1: begin
                  if( d_out_ready) begin
                   @(negedge clk);
                     d_out_valid <=1'b0;
                     d_in_ready     <= 1'b1;    
                     
                     state          <= IDLE;
                  end
               end
            default: state <= IDLE;
            endcase
        end
    end
endmodule
// hhuuuuuuuuuuuS