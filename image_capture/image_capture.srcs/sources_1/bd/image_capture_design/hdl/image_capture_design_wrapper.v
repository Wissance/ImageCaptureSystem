//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (win64) Build 1577090 Thu Jun  2 16:32:40 MDT 2016
//Date        : Sat Dec 31 18:21:30 2016
//Host        : otheman-laptop running 64-bit major release  (build 9200)
//Command     : generate_target image_capture_design_wrapper.bd
//Design      : image_capture_design_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module image_capture_design_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    LINESCANNER0_END_ADC,
    LINESCANNER0_LOAD_PULSE,
    LINESCANNER0_LVAL,
    LINESCANNER0_MAIN_CLK,
    LINESCANNER0_N_RESET,
    LINESCANNER0_PIXEL_CLOCK,
    LINESCANNER0_RST_CDS,
    LINESCANNER0_RST_CVC,
    LINESCANNER0_SAMPLE,
    LINESCANNER0_TAP_A,
    LINESCANNER1_END_ADC,
    LINESCANNER1_LOAD_PULSE,
    LINESCANNER1_LVAL,
    LINESCANNER1_MAIN_CLOCK,
    LINESCANNER1_N_RESET,
    LINESCANNER1_PIXEL_CLOCK,
    LINESCANNER1_RST_CDS,
    LINESCANNER1_RST_CVC,
    LINESCANNER1_SAMPLE,
    LINESCANNER1_TAP_A,
    spi_rtl_io0_io,
    spi_rtl_io1_io,
    spi_rtl_ss_io);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input LINESCANNER0_END_ADC;
  output LINESCANNER0_LOAD_PULSE;
  input LINESCANNER0_LVAL;
  output LINESCANNER0_MAIN_CLK;
  output [0:0]LINESCANNER0_N_RESET;
  input LINESCANNER0_PIXEL_CLOCK;
  output LINESCANNER0_RST_CDS;
  output LINESCANNER0_RST_CVC;
  output LINESCANNER0_SAMPLE;
  input [7:0]LINESCANNER0_TAP_A;
  input LINESCANNER1_END_ADC;
  output LINESCANNER1_LOAD_PULSE;
  input LINESCANNER1_LVAL;
  output LINESCANNER1_MAIN_CLOCK;
  output [0:0]LINESCANNER1_N_RESET;
  input LINESCANNER1_PIXEL_CLOCK;
  output LINESCANNER1_RST_CDS;
  output LINESCANNER1_RST_CVC;
  output LINESCANNER1_SAMPLE;
  input [7:0]LINESCANNER1_TAP_A;
  inout spi_rtl_io0_io;
  inout spi_rtl_io1_io;
  inout [1:0]spi_rtl_ss_io;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire LINESCANNER0_END_ADC;
  wire LINESCANNER0_LOAD_PULSE;
  wire LINESCANNER0_LVAL;
  wire LINESCANNER0_MAIN_CLK;
  wire [0:0]LINESCANNER0_N_RESET;
  wire LINESCANNER0_PIXEL_CLOCK;
  wire LINESCANNER0_RST_CDS;
  wire LINESCANNER0_RST_CVC;
  wire LINESCANNER0_SAMPLE;
  wire [7:0]LINESCANNER0_TAP_A;
  wire LINESCANNER1_END_ADC;
  wire LINESCANNER1_LOAD_PULSE;
  wire LINESCANNER1_LVAL;
  wire LINESCANNER1_MAIN_CLOCK;
  wire [0:0]LINESCANNER1_N_RESET;
  wire LINESCANNER1_PIXEL_CLOCK;
  wire LINESCANNER1_RST_CDS;
  wire LINESCANNER1_RST_CVC;
  wire LINESCANNER1_SAMPLE;
  wire [7:0]LINESCANNER1_TAP_A;
  wire spi_rtl_io0_i;
  wire spi_rtl_io0_io;
  wire spi_rtl_io0_o;
  wire spi_rtl_io0_t;
  wire spi_rtl_io1_i;
  wire spi_rtl_io1_io;
  wire spi_rtl_io1_o;
  wire spi_rtl_io1_t;
  wire [0:0]spi_rtl_ss_i_0;
  wire [1:1]spi_rtl_ss_i_1;
  wire [0:0]spi_rtl_ss_io_0;
  wire [1:1]spi_rtl_ss_io_1;
  wire [0:0]spi_rtl_ss_o_0;
  wire [1:1]spi_rtl_ss_o_1;
  wire spi_rtl_ss_t;

  image_capture_design image_capture_design_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .LINESCANNER0_END_ADC(LINESCANNER0_END_ADC),
        .LINESCANNER0_LOAD_PULSE(LINESCANNER0_LOAD_PULSE),
        .LINESCANNER0_LVAL(LINESCANNER0_LVAL),
        .LINESCANNER0_MAIN_CLK(LINESCANNER0_MAIN_CLK),
        .LINESCANNER0_N_RESET(LINESCANNER0_N_RESET),
        .LINESCANNER0_PIXEL_CLOCK(LINESCANNER0_PIXEL_CLOCK),
        .LINESCANNER0_RST_CDS(LINESCANNER0_RST_CDS),
        .LINESCANNER0_RST_CVC(LINESCANNER0_RST_CVC),
        .LINESCANNER0_SAMPLE(LINESCANNER0_SAMPLE),
        .LINESCANNER0_TAP_A(LINESCANNER0_TAP_A),
        .LINESCANNER1_END_ADC(LINESCANNER1_END_ADC),
        .LINESCANNER1_LOAD_PULSE(LINESCANNER1_LOAD_PULSE),
        .LINESCANNER1_LVAL(LINESCANNER1_LVAL),
        .LINESCANNER1_MAIN_CLOCK(LINESCANNER1_MAIN_CLOCK),
        .LINESCANNER1_N_RESET(LINESCANNER1_N_RESET),
        .LINESCANNER1_PIXEL_CLOCK(LINESCANNER1_PIXEL_CLOCK),
        .LINESCANNER1_RST_CDS(LINESCANNER1_RST_CDS),
        .LINESCANNER1_RST_CVC(LINESCANNER1_RST_CVC),
        .LINESCANNER1_SAMPLE(LINESCANNER1_SAMPLE),
        .LINESCANNER1_TAP_A(LINESCANNER1_TAP_A),
        .spi_rtl_io0_i(spi_rtl_io0_i),
        .spi_rtl_io0_o(spi_rtl_io0_o),
        .spi_rtl_io0_t(spi_rtl_io0_t),
        .spi_rtl_io1_i(spi_rtl_io1_i),
        .spi_rtl_io1_o(spi_rtl_io1_o),
        .spi_rtl_io1_t(spi_rtl_io1_t),
        .spi_rtl_ss_i({spi_rtl_ss_i_1,spi_rtl_ss_i_0}),
        .spi_rtl_ss_o({spi_rtl_ss_o_1,spi_rtl_ss_o_0}),
        .spi_rtl_ss_t(spi_rtl_ss_t));
  IOBUF spi_rtl_io0_iobuf
       (.I(spi_rtl_io0_o),
        .IO(spi_rtl_io0_io),
        .O(spi_rtl_io0_i),
        .T(spi_rtl_io0_t));
  IOBUF spi_rtl_io1_iobuf
       (.I(spi_rtl_io1_o),
        .IO(spi_rtl_io1_io),
        .O(spi_rtl_io1_i),
        .T(spi_rtl_io1_t));
  IOBUF spi_rtl_ss_iobuf_0
       (.I(spi_rtl_ss_o_0),
        .IO(spi_rtl_ss_io[0]),
        .O(spi_rtl_ss_i_0),
        .T(spi_rtl_ss_t));
  IOBUF spi_rtl_ss_iobuf_1
       (.I(spi_rtl_ss_o_1),
        .IO(spi_rtl_ss_io[1]),
        .O(spi_rtl_ss_i_1),
        .T(spi_rtl_ss_t));
endmodule
