`timescale 1 ns / 1 ps

module linescanner2stream_convertor_M00_AXIS #
(
     // Users to add parameters here
     parameter [15:0] HOLD_VALUE_TIME = 'h07ff,
     // User parameters ends
     // Do not modify the parameters beyond this line

     // Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
     parameter integer C_M_AXIS_TDATA_WIDTH	= 32,
     // Start count is the numeber of clock cycles the master will wait before initiating/issuing any transaction.
     parameter integer C_M_START_COUNT	= 32,
     // Number of words in burst
     parameter integer C_M_NUMBER_OF_WORDS = 8
)
(
    // Users to add ports here
    input wire [C_M_AXIS_TDATA_WIDTH-1 : 0] DATA_SOURCE,
    input wire DATA_READY,
    // User ports ends
   
    // Global ports
    input wire  M_AXIS_ACLK,
    // asynchronous reset
    input wire  M_AXIS_ARESETN,
    // Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
    output wire  M_AXIS_TVALID,
    // TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
    output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
    // TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
    output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
    // TLAST indicates the boundary of a packet.
    output wire  M_AXIS_TLAST,
    // TREADY indicates that the slave can accept a transfer in the current cycle.
    input wire  M_AXIS_TREADY
);
    
    parameter [1:0] IDLE = 1;
    parameter [1:0] INIT = 2;
    parameter [1:0] READY = 3;
    
    supply1 vcc;
    reg clear_fifo;
    reg pop_clock;
    reg [7:0] clk_counter;
    reg [1:0] state;
    reg [3:0] data_counter;
    reg [15:0] tvalid_counter;
    reg [7:0] reset_counter;
    reg [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] tstrb_value;
    reg tvalid_value;
    reg tlast_value;
    wire fifo_ready;
    wire fifo_reset;
    
    initial clear_fifo = 0;
    initial pop_clock = 0;
    initial clk_counter = 0;
    initial data_counter = 0;
    initial state = IDLE;
    initial tvalid_value = 0;
    initial tvalid_counter = 0;
    initial reset_counter = 0;
    
    assign M_AXIS_TVALID = tvalid_value;
    assign M_AXIS_TLAST = tlast_value;
    assign fifo_reset = clear_fifo | ~ M_AXIS_ARESETN;
    assign M_AXIS_TSTRB = tstrb_value;
    
    fifo #(.FIFO_SIZE(C_M_NUMBER_OF_WORDS), .DATA_WIDTH(C_M_AXIS_TDATA_WIDTH)) axi_stream_fifo(.enable(M_AXIS_ARESETN), .clear(fifo_reset), .in_data(DATA_SOURCE), .fifo_ready(fifo_ready),
                                                                                               .push_clock(DATA_READY), .pop_clock(pop_clock), .out_data(M_AXIS_TDATA));
    always@ (posedge M_AXIS_ACLK)
    begin
        if (!M_AXIS_ARESETN)
        begin
            reset_counter <= reset_counter + 1;
            if(reset_counter == C_M_START_COUNT)
                state <= IDLE;
            data_counter <= 0;
            clear_fifo <= 1;
            tvalid_value <= 0;
            tvalid_counter <= 0;
            tlast_value <= 0;
            tstrb_value <= 0;
        end
        else
        begin
            case (state)          
            IDLE :
            begin
               clk_counter <= 0;
               state <= INIT;
               clear_fifo <= 0;
               reset_counter <= 0;
            end
            
            INIT :
            begin
               clk_counter <= clk_counter + 1;
               if(clk_counter == C_M_START_COUNT)
                   state <= READY;
            end
            
            READY :
            begin
                if(M_AXIS_TREADY)
                begin
                    if(data_counter >= 1)
                    begin
                        tvalid_value <= 1;
                        pop_clock <= 1;
                        data_counter = data_counter - 1;
                        tvalid_counter <= 0;
                        if(data_counter == 0)
                           tlast_value <= 1;
                    end                        
                    if(tvalid_value == 1)
                    begin
                        tvalid_counter <= tvalid_counter + 1;
                        pop_clock <= 0;
                        tstrb_value <= 15;
                        if(tvalid_counter == HOLD_VALUE_TIME)
                        begin
                            tvalid_value <= 0;
                            tlast_value <= 0;
                            tstrb_value <= 0;
                        end
                    end
                end
                else
                begin
                   tvalid_value <= 0;
                   tvalid_counter <= 0;
                end
            end
            
            default :
            begin
                state <= IDLE;
            end
            
            endcase
        end
    end
    
    always@ (posedge DATA_READY)
    begin
        if(fifo_ready && state == READY)
            data_counter <= data_counter + 1;
    end


endmodule