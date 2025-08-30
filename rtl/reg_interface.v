`include "../include/npu_params.v"

`define NSL_COM_LOGIC_1 internal_spi_16_bit_transmitted_flag_mod && internal_spi_write_en 

module reg_interface (
    input  wire                            clk,
    input  wire                            reset_b,
      
    input  wire                            spi_ss,
    input  wire                            spi_sclk,
    input  wire                            spi_mosi,
    output wire                            spi_miso,

    output wire                            reg_bank_start_op,
    output wire [`NPU_LAYER_NUM_WIDTH-1:0] reg_bank_layer_num,
    output wire [`NPU_INPUT_NUM_WIDTH-1:0] reg_bank_input_num,
    output wire                            reg_bank_final_layer_act,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l0_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l1_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l2_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l3_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l4_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l5_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l6_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l7_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l8_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l9_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l10_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l11_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l12_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l13_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l14_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  reg_bank_l15_node_num
);

wire [`NPU_REG_ADDR_WIDTH-1:0] internal_addr;
wire                           internal_spi_read_en;
wire [`NPU_REG_WIDTH-1:0]      internal_spi_read_data;
wire [`NPU_REG_WIDTH-1:0]      internal_spi_write_data;
wire                           internal_spi_write_en;
wire                           internal_spi_write_en_mod;
wire                           internal_spi_16_bit_transmitted_flag;
wire                           internal_spi_16_bit_transmitted_flag_mod;

wire                           flag_last_bram_loc;
wire                           read_en_flag_act;

wire [`NPU_REG_ADDR_WIDTH-1:0] addr_buff_reg_d;
wire [`NPU_REG_ADDR_WIDTH-1:0] addr_buff_reg_q;

assign flag_last_bram_loc = 1'b1;

// Instances - start --------------------------------------------
//
// SPI slave block
spi_slave i_npu_spi_slave (
    .clk                    ( clk                                  ),
    .reset_b                ( reset_b                              ),
    .spi_ss                 ( spi_ss                               ),
    .spi_sclk               ( spi_sclk                             ),
    .spi_mosi               ( spi_mosi                             ),
    .spi_load               ( internal_spi_read_en                 ),
    .spi_load_data          ( internal_spi_read_data               ),
    .spi_miso               ( spi_miso                             ),
    .spi_data_out           ( internal_spi_write_data              ),
    .spi_fifo_wr_en         ( internal_spi_write_en                ),
    .spi_16_bit_transmitted ( internal_spi_16_bit_transmitted_flag )
);

// Register bank block
reg_bank i_npu_config_reg_bank (
    .clk             ( clk                       ),
    .reset_b         ( reset_b                   ),
    .wr_en           ( internal_spi_write_en_mod ),
    .rd_en           ( internal_spi_read_en      ),
    .addr            ( internal_addr             ),
    .write_data      ( internal_spi_write_data   ),
    .read_data       ( internal_spi_read_data    ),
    .start_op        ( reg_bank_start_op         ),
    .layer_num       ( reg_bank_layer_num        ),
    .input_num       ( reg_bank_input_num        ),
    .final_layer_act ( reg_bank_final_layer_act  ),
    .l0_node_num     ( reg_bank_l0_node_num      ),
    .l1_node_num     ( reg_bank_l1_node_num      ),
    .l2_node_num     ( reg_bank_l2_node_num      ),
    .l3_node_num     ( reg_bank_l3_node_num      ),
    .l4_node_num     ( reg_bank_l4_node_num      ),
    .l5_node_num     ( reg_bank_l5_node_num      ),
    .l6_node_num     ( reg_bank_l6_node_num      ),
    .l7_node_num     ( reg_bank_l7_node_num      ),
    .l8_node_num     ( reg_bank_l8_node_num      ),
    .l9_node_num     ( reg_bank_l9_node_num      ),
    .l10_node_num    ( reg_bank_l10_node_num     ),
    .l11_node_num    ( reg_bank_l11_node_num     ),
    .l12_node_num    ( reg_bank_l12_node_num     ),
    .l13_node_num    ( reg_bank_l13_node_num     ),
    .l14_node_num    ( reg_bank_l14_node_num     ),
    .l15_node_num    ( reg_bank_l15_node_num     )
);

// Address buffer register
dff # (
    .FLOP_WIDTH  (`NPU_REG_ADDR_WIDTH),
    .RESET_VALUE (8'b0)
) i_npu_addr_buff_reg (
    .clk     ( clk             ),
    .reset_b ( reset_b         ),
    .en      ( 1'b1            ),
    .d       ( addr_buff_reg_d ),
    .q       ( addr_buff_reg_q )
);

// 16_bit_transmitted flag delay flop
dff # (
    .FLOP_WIDTH  (1'b1),
    .RESET_VALUE (1'b0)
) i_npu_bit_16_trans_sig_delay (
    .clk     ( clk                                      ),
    .reset_b ( reset_b                                  ),
    .en      ( 1'b1                                     ),
    .d       ( internal_spi_16_bit_transmitted_flag     ),
    .q       ( internal_spi_16_bit_transmitted_flag_mod )
);

//
// Instances - end ----------------------------------------------

// FSM - start --------------------------------------------------
//
localparam IDLE             = 0,
           ADDRESSING_STAGE = 1,
           DATA_STAGE       = 2,
           CONFIG_COMPLETE  = 3,
           CONFIG_ERROR     = 4;

localparam STATE_WIDTH = 3;

wire [STATE_WIDTH-1:0] present_state;
reg  [STATE_WIDTH-1:0] next_state;

// Register interface FSM - present state register
dff # (
    .FLOP_WIDTH  ( STATE_WIDTH ),
    .RESET_VALUE ('b0          )
) i_npu_config_reg (
    .clk     ( clk                            ),
    .reset_b ( reset_b                        ),
    .en      ( 1'b1                           ), 
    .d       ( next_state[STATE_WIDTH-1:0]    ),
    .q       ( present_state[STATE_WIDTH-1:0] )
);

// Register interface FSM - next state logic
always @(*) begin
    casez (present_state)
        IDLE: begin
            next_state = (`NSL_COM_LOGIC_1 && (internal_spi_write_data == `NPU_SPI_START_HEADER)) ? ADDRESSING_STAGE : IDLE;
        end

        ADDRESSING_STAGE: begin
            next_state = `NSL_COM_LOGIC_1 ? DATA_STAGE : ADDRESSING_STAGE;
        end

        DATA_STAGE: begin
            next_state = (`NSL_COM_LOGIC_1 && (addr_buff_reg_q == `NPU_MODEL_DATA_ADDR) && ~flag_last_bram_loc) ? DATA_STAGE : (`NSL_COM_LOGIC_1 ? IDLE : DATA_STAGE);
        end

        default: begin
            next_state = 'bx;
        end
    endcase
end

assign addr_buff_reg_d[`NPU_REG_ADDR_WIDTH-1:0] = (internal_spi_write_en && (present_state == ADDRESSING_STAGE)) ? internal_spi_write_data[`NPU_REG_ADDR_WIDTH-1:0] : addr_buff_reg_q[`NPU_REG_ADDR_WIDTH-1:0];
assign internal_addr[`NPU_REG_ADDR_WIDTH-1:0]   = internal_spi_read_en ? internal_spi_write_data[`NPU_REG_ADDR_WIDTH-1:0] : addr_buff_reg_q[`NPU_REG_ADDR_WIDTH-1:0];
assign internal_spi_write_en_mod                = (present_state == DATA_STAGE) && internal_spi_write_en;

assign internal_spi_read_en                     = internal_spi_16_bit_transmitted_flag && (present_state == ADDRESSING_STAGE) && (internal_spi_write_data[15:8] == 8'h00);
//
// FSM - end ----------------------------------------------------

endmodule
