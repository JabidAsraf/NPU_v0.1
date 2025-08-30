`include "../include/npu_params.v"

module reg_bank (
    input  wire                            clk,
    input  wire                            reset_b,

    input  wire                            wr_en,          
    input  wire                            rd_en,
    input  wire [`NPU_REG_ADDR_WIDTH-1:0]  addr,
    input  wire [`NPU_REG_WIDTH-1:0]       write_data,
    output wire [`NPU_REG_WIDTH-1:0]       read_data,

    output wire                            start_op,
    output wire [`NPU_LAYER_NUM_WIDTH-1:0] layer_num,
    output wire [`NPU_INPUT_NUM_WIDTH-1:0] input_num,     
    output wire                            final_layer_act,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l0_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l1_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l2_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l3_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l4_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l5_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l6_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l7_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l8_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l9_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l10_node_num,  
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l11_node_num, 
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l12_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l13_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l14_node_num,
    output wire [`NPU_NODE_NUM_WIDTH-1:0]  l15_node_num
);

wire [`NPU_REG_WIDTH-1:0] npu_conf_reg_d;
wire [`NPU_REG_WIDTH-1:0] npu_input_num_reg_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_0_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_1_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_2_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_3_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_4_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_5_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_6_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_7_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_8_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_9_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_10_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_11_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_12_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_13_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_14_d;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_15_d;

wire [`NPU_REG_WIDTH-1:0] npu_conf_reg_q;
wire [`NPU_REG_WIDTH-1:0] npu_input_num_reg_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_0_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_1_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_2_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_3_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_4_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_5_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_6_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_7_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_8_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_9_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_10_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_11_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_12_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_13_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_14_q;
wire [`NPU_REG_WIDTH-1:0] npu_hid_layer_conf_reg_15_q;

wire wr_en_npu_conf_reg;
wire wr_en_npu_input_num_reg;
wire wr_en_npu_hid_layer_conf_reg_0;
wire wr_en_npu_hid_layer_conf_reg_1;
wire wr_en_npu_hid_layer_conf_reg_2;
wire wr_en_npu_hid_layer_conf_reg_3;
wire wr_en_npu_hid_layer_conf_reg_4;
wire wr_en_npu_hid_layer_conf_reg_5;
wire wr_en_npu_hid_layer_conf_reg_6;
wire wr_en_npu_hid_layer_conf_reg_7;
wire wr_en_npu_hid_layer_conf_reg_8;
wire wr_en_npu_hid_layer_conf_reg_9;
wire wr_en_npu_hid_layer_conf_reg_10;
wire wr_en_npu_hid_layer_conf_reg_11;
wire wr_en_npu_hid_layer_conf_reg_12;
wire wr_en_npu_hid_layer_conf_reg_13;
wire wr_en_npu_hid_layer_conf_reg_14;
wire wr_en_npu_hid_layer_conf_reg_15;

wire rd_en_npu_conf_reg;
wire rd_en_npu_input_num_reg;
wire rd_en_npu_hid_layer_conf_reg_0;
wire rd_en_npu_hid_layer_conf_reg_1;
wire rd_en_npu_hid_layer_conf_reg_2;
wire rd_en_npu_hid_layer_conf_reg_3;
wire rd_en_npu_hid_layer_conf_reg_4;
wire rd_en_npu_hid_layer_conf_reg_5;
wire rd_en_npu_hid_layer_conf_reg_6;
wire rd_en_npu_hid_layer_conf_reg_7;
wire rd_en_npu_hid_layer_conf_reg_8;
wire rd_en_npu_hid_layer_conf_reg_9;
wire rd_en_npu_hid_layer_conf_reg_10;
wire rd_en_npu_hid_layer_conf_reg_11;
wire rd_en_npu_hid_layer_conf_reg_12;
wire rd_en_npu_hid_layer_conf_reg_13;
wire rd_en_npu_hid_layer_conf_reg_14;
wire rd_en_npu_hid_layer_conf_reg_15;

// Instances - start --------------------------------------------
//
dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_config_reg (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_conf_reg_d ),
    .q       ( npu_conf_reg_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_input_num_reg (
    .clk     ( clk                 ),
    .reset_b ( reset_b             ),
    .en      ( 1'b1                ),
    .d       ( npu_input_num_reg_d ),
    .q       ( npu_input_num_reg_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_0 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_0_d ),
    .q       ( npu_hid_layer_conf_reg_0_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_1 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_1_d ),
    .q       ( npu_hid_layer_conf_reg_1_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_2 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_2_d ),
    .q       ( npu_hid_layer_conf_reg_2_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_3 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_3_d ),
    .q       ( npu_hid_layer_conf_reg_3_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_4 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_4_d ),
    .q       ( npu_hid_layer_conf_reg_4_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_5 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_5_d ),
    .q       ( npu_hid_layer_conf_reg_5_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_6 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_6_d ),
    .q       ( npu_hid_layer_conf_reg_6_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_7 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_7_d ),
    .q       ( npu_hid_layer_conf_reg_7_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_8 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_8_d ),
    .q       ( npu_hid_layer_conf_reg_8_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_9 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_9_d ),
    .q       ( npu_hid_layer_conf_reg_9_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_10 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_10_d ),
    .q       ( npu_hid_layer_conf_reg_10_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_11 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_11_d ),
    .q       ( npu_hid_layer_conf_reg_11_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_12 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_12_d ),
    .q       ( npu_hid_layer_conf_reg_12_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_13 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_13_d ),
    .q       ( npu_hid_layer_conf_reg_13_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_14 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_14_d ),
    .q       ( npu_hid_layer_conf_reg_14_q )
);

dff # (
    .FLOP_WIDTH  (`NPU_REG_WIDTH),
    .RESET_VALUE (16'b0)
) i_npu_hid_layer_config_reg_15 (
    .clk     ( clk            ),
    .reset_b ( reset_b        ),
    .en      ( 1'b1           ),
    .d       ( npu_hid_layer_conf_reg_15_d ),
    .q       ( npu_hid_layer_conf_reg_15_q )
);
//
// Instances - end ----------------------------------------------

// Register write read logic - start ----------------------------
//
assign wr_en_npu_conf_reg              = wr_en & (addr == `NPU_CON_REG_ADDR);
assign wr_en_npu_input_num_reg         = wr_en & (addr == `NPU_IN_NUM_REG_ADDR);
assign wr_en_npu_hid_layer_conf_reg_0  = wr_en & (addr == `NPU_HID_LAYER_CON_REG0_ADDR);
assign wr_en_npu_hid_layer_conf_reg_1  = wr_en & (addr == `NPU_HID_LAYER_CON_REG1_ADDR);
assign wr_en_npu_hid_layer_conf_reg_2  = wr_en & (addr == `NPU_HID_LAYER_CON_REG2_ADDR);
assign wr_en_npu_hid_layer_conf_reg_3  = wr_en & (addr == `NPU_HID_LAYER_CON_REG3_ADDR);
assign wr_en_npu_hid_layer_conf_reg_4  = wr_en & (addr == `NPU_HID_LAYER_CON_REG4_ADDR);
assign wr_en_npu_hid_layer_conf_reg_5  = wr_en & (addr == `NPU_HID_LAYER_CON_REG5_ADDR);
assign wr_en_npu_hid_layer_conf_reg_6  = wr_en & (addr == `NPU_HID_LAYER_CON_REG6_ADDR);
assign wr_en_npu_hid_layer_conf_reg_7  = wr_en & (addr == `NPU_HID_LAYER_CON_REG7_ADDR);
assign wr_en_npu_hid_layer_conf_reg_8  = wr_en & (addr == `NPU_HID_LAYER_CON_REG8_ADDR);
assign wr_en_npu_hid_layer_conf_reg_9  = wr_en & (addr == `NPU_HID_LAYER_CON_REG9_ADDR);
assign wr_en_npu_hid_layer_conf_reg_10 = wr_en & (addr == `NPU_HID_LAYER_CON_REG10_ADDR);
assign wr_en_npu_hid_layer_conf_reg_11 = wr_en & (addr == `NPU_HID_LAYER_CON_REG11_ADDR);
assign wr_en_npu_hid_layer_conf_reg_12 = wr_en & (addr == `NPU_HID_LAYER_CON_REG12_ADDR);
assign wr_en_npu_hid_layer_conf_reg_13 = wr_en & (addr == `NPU_HID_LAYER_CON_REG13_ADDR);
assign wr_en_npu_hid_layer_conf_reg_14 = wr_en & (addr == `NPU_HID_LAYER_CON_REG14_ADDR);
assign wr_en_npu_hid_layer_conf_reg_15 = wr_en & (addr == `NPU_HID_LAYER_CON_REG15_ADDR);

assign rd_en_npu_conf_reg              = rd_en & (addr == `NPU_CON_REG_ADDR);
assign rd_en_npu_input_num_reg         = rd_en & (addr == `NPU_IN_NUM_REG_ADDR);
assign rd_en_npu_hid_layer_conf_reg_0  = rd_en & (addr == `NPU_HID_LAYER_CON_REG0_ADDR);
assign rd_en_npu_hid_layer_conf_reg_1  = rd_en & (addr == `NPU_HID_LAYER_CON_REG1_ADDR);
assign rd_en_npu_hid_layer_conf_reg_2  = rd_en & (addr == `NPU_HID_LAYER_CON_REG2_ADDR);
assign rd_en_npu_hid_layer_conf_reg_3  = rd_en & (addr == `NPU_HID_LAYER_CON_REG3_ADDR);
assign rd_en_npu_hid_layer_conf_reg_4  = rd_en & (addr == `NPU_HID_LAYER_CON_REG4_ADDR);
assign rd_en_npu_hid_layer_conf_reg_5  = rd_en & (addr == `NPU_HID_LAYER_CON_REG5_ADDR);
assign rd_en_npu_hid_layer_conf_reg_6  = rd_en & (addr == `NPU_HID_LAYER_CON_REG6_ADDR);
assign rd_en_npu_hid_layer_conf_reg_7  = rd_en & (addr == `NPU_HID_LAYER_CON_REG7_ADDR);
assign rd_en_npu_hid_layer_conf_reg_8  = rd_en & (addr == `NPU_HID_LAYER_CON_REG8_ADDR);
assign rd_en_npu_hid_layer_conf_reg_9  = rd_en & (addr == `NPU_HID_LAYER_CON_REG9_ADDR);
assign rd_en_npu_hid_layer_conf_reg_10 = rd_en & (addr == `NPU_HID_LAYER_CON_REG10_ADDR);
assign rd_en_npu_hid_layer_conf_reg_11 = rd_en & (addr == `NPU_HID_LAYER_CON_REG11_ADDR);
assign rd_en_npu_hid_layer_conf_reg_12 = rd_en & (addr == `NPU_HID_LAYER_CON_REG12_ADDR);
assign rd_en_npu_hid_layer_conf_reg_13 = rd_en & (addr == `NPU_HID_LAYER_CON_REG13_ADDR);
assign rd_en_npu_hid_layer_conf_reg_14 = rd_en & (addr == `NPU_HID_LAYER_CON_REG14_ADDR);
assign rd_en_npu_hid_layer_conf_reg_15 = rd_en & (addr == `NPU_HID_LAYER_CON_REG15_ADDR);

assign npu_conf_reg_d                  = wr_en_npu_conf_reg              ? {9'b0, write_data[6:2], 1'b0, write_data[0]} : npu_conf_reg_q;
assign npu_input_num_reg_d             = wr_en_npu_input_num_reg         ? write_data                                   : npu_input_num_reg_q;
assign npu_hid_layer_conf_reg_0_d      = wr_en_npu_hid_layer_conf_reg_0  ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_0_q;
assign npu_hid_layer_conf_reg_1_d      = wr_en_npu_hid_layer_conf_reg_1  ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_1_q;
assign npu_hid_layer_conf_reg_2_d      = wr_en_npu_hid_layer_conf_reg_2  ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_2_q;
assign npu_hid_layer_conf_reg_3_d      = wr_en_npu_hid_layer_conf_reg_3  ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_3_q;
assign npu_hid_layer_conf_reg_4_d      = wr_en_npu_hid_layer_conf_reg_4  ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_4_q;
assign npu_hid_layer_conf_reg_5_d      = wr_en_npu_hid_layer_conf_reg_5  ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_5_q;
assign npu_hid_layer_conf_reg_6_d      = wr_en_npu_hid_layer_conf_reg_6  ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_6_q;
assign npu_hid_layer_conf_reg_7_d      = wr_en_npu_hid_layer_conf_reg_7  ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_7_q;
assign npu_hid_layer_conf_reg_8_d      = wr_en_npu_hid_layer_conf_reg_8  ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_8_q;
assign npu_hid_layer_conf_reg_9_d      = wr_en_npu_hid_layer_conf_reg_9  ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_9_q;
assign npu_hid_layer_conf_reg_10_d     = wr_en_npu_hid_layer_conf_reg_10 ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_10_q;
assign npu_hid_layer_conf_reg_11_d     = wr_en_npu_hid_layer_conf_reg_11 ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_11_q;
assign npu_hid_layer_conf_reg_12_d     = wr_en_npu_hid_layer_conf_reg_12 ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_12_q;
assign npu_hid_layer_conf_reg_13_d     = wr_en_npu_hid_layer_conf_reg_13 ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_13_q;
assign npu_hid_layer_conf_reg_14_d     = wr_en_npu_hid_layer_conf_reg_14 ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_14_q;
assign npu_hid_layer_conf_reg_15_d     = wr_en_npu_hid_layer_conf_reg_15 ? {6'b0, write_data[9:0]}                      : npu_hid_layer_conf_reg_15_q;

assign read_data                       = rd_en_npu_conf_reg              ? npu_conf_reg_q                               : (
                                         rd_en_npu_input_num_reg         ? npu_input_num_reg_q                          : (
                                         rd_en_npu_hid_layer_conf_reg_0  ? npu_hid_layer_conf_reg_0_q                   : (
                                         rd_en_npu_hid_layer_conf_reg_1  ? npu_hid_layer_conf_reg_1_q                   : (
                                         rd_en_npu_hid_layer_conf_reg_2  ? npu_hid_layer_conf_reg_2_q                   : (
                                         rd_en_npu_hid_layer_conf_reg_3  ? npu_hid_layer_conf_reg_3_q                   : (
                                         rd_en_npu_hid_layer_conf_reg_4  ? npu_hid_layer_conf_reg_4_q                   : (
                                         rd_en_npu_hid_layer_conf_reg_5  ? npu_hid_layer_conf_reg_5_q                   : (
                                         rd_en_npu_hid_layer_conf_reg_6  ? npu_hid_layer_conf_reg_6_q                   : (
                                         rd_en_npu_hid_layer_conf_reg_7  ? npu_hid_layer_conf_reg_7_q                   : (
                                         rd_en_npu_hid_layer_conf_reg_8  ? npu_hid_layer_conf_reg_8_q                   : (
                                         rd_en_npu_hid_layer_conf_reg_9  ? npu_hid_layer_conf_reg_9_q                   : (
                                         rd_en_npu_hid_layer_conf_reg_10 ? npu_hid_layer_conf_reg_10_q                  : (
                                         rd_en_npu_hid_layer_conf_reg_11 ? npu_hid_layer_conf_reg_11_q                  : (
                                         rd_en_npu_hid_layer_conf_reg_12 ? npu_hid_layer_conf_reg_12_q                  : (
                                         rd_en_npu_hid_layer_conf_reg_13 ? npu_hid_layer_conf_reg_13_q                  : (
                                         rd_en_npu_hid_layer_conf_reg_14 ? npu_hid_layer_conf_reg_14_q                  : (
                                         rd_en_npu_hid_layer_conf_reg_15 ? npu_hid_layer_conf_reg_15_q                  : 16'b0)))))))))))))))));
//
// Register write read logic - end ------------------------------

endmodule
