`include "../include/npu_params.v"

module npu_top (

    // global signals
    input  wire npu_clk,
    input  wire npu_reset_b,
    
    // SPI slave signals
    input  wire npu_spi_sclk,
    input  wire npu_spi_ss,
    input  wire npu_spi_mosi,
    output wire npu_spi_miso,
    
    // Interrupts
    output wire npu_done_int,
    output wire npu_err_int
);


wire                            internal_reg_bank_start_op;
wire [`NPU_LAYER_NUM_WIDTH-1:0] internal_reg_bank_layer_num;
wire [`NPU_INPUT_NUM_WIDTH-1:0] internal_reg_bank_input_num;
wire                            internal_reg_bank_final_layer_act;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l0_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l1_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l2_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l3_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l4_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l5_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l6_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l7_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l8_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l9_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l10_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l11_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l12_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l13_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l14_node_num;
wire [`NPU_NODE_NUM_WIDTH-1:0]  internal_reg_bank_l15_node_num;


reg_interface i_reg_interface(
    .clk                      ( npu_clk                           ),
    .reset_b                  ( npu_reset_b                       ),
    
    .spi_ss                   ( npu_spi_ss                        ),
    .spi_sclk                 ( npu_spi_sclk                      ),
    .spi_mosi                 ( npu_spi_mosi                      ),
    .spi_miso                 ( npu_spi_miso                      ),

    .reg_bank_start_op        ( internal_reg_bank_start_op        ),
    .reg_bank_layer_num       ( internal_reg_bank_layer_num       ),
    .reg_bank_input_num       ( internal_reg_bank_input_num       ),
    .reg_bank_final_layer_act ( internal_reg_bank_final_layer_act ),
    .reg_bank_l0_node_num     ( internal_reg_bank_l0_node_num     ),
    .reg_bank_l1_node_num     ( internal_reg_bank_l1_node_num     ),
    .reg_bank_l2_node_num     ( internal_reg_bank_l2_node_num     ),    
    .reg_bank_l3_node_num     ( internal_reg_bank_l3_node_num     ),
    .reg_bank_l4_node_num     ( internal_reg_bank_l4_node_num     ),
    .reg_bank_l5_node_num     ( internal_reg_bank_l5_node_num     ),
    .reg_bank_l6_node_num     ( internal_reg_bank_l6_node_num     ),
    .reg_bank_l7_node_num     ( internal_reg_bank_l7_node_num     ),
    .reg_bank_l8_node_num     ( internal_reg_bank_l8_node_num     ),
    .reg_bank_l9_node_num     ( internal_reg_bank_l9_node_num     ),
    .reg_bank_l10_node_num    ( internal_reg_bank_l10_node_num    ),
    .reg_bank_l11_node_num    ( internal_reg_bank_l11_node_num    ),
    .reg_bank_l12_node_num    ( internal_reg_bank_l12_node_num    ),
    .reg_bank_l13_node_num    ( internal_reg_bank_l13_node_num    ),
    .reg_bank_l14_node_num    ( internal_reg_bank_l14_node_num    ),
    .reg_bank_l15_node_num    ( internal_reg_bank_l15_node_num    )
);

assign npu_done_int = 1'b0;
assign npu_err_int  = 1'b0;

/*
// NPU control logic block
npu_control_logic i_npu_main_control_logic (

);

// Memory management logic
mem_management_logic i_npu_memory_managemnet_logic (

);

// Wrapper for memory IP provided by FPGA vendor
mem_wrapper i_npu_memory_wrapper (

);

// Main computation core of NPU
npu_compute_core i_npu_compute_core (

);
*/

endmodule
