`timescale 1ns / 1ps

module tb_fft128_dit;

    parameter WIDTH = 24;

    reg  [128*WIDTH-1:0] in_re;
    reg  [128*WIDTH-1:0] in_im;
    wire [128*WIDTH-1:0] out_re;
    wire [128*WIDTH-1:0] out_im;

    integer k;

    fft128_dit #(.WIDTH(WIDTH)) dut (
        .in_re(in_re),
        .in_im(in_im),
        .out_re(out_re),
        .out_im(out_im)
    );

    task set_sample;
        input integer idx;
        input signed [WIDTH-1:0] rval;
        input signed [WIDTH-1:0] ival;
        begin
            in_re[(idx*WIDTH)+:WIDTH] = rval;
            in_im[(idx*WIDTH)+:WIDTH] = ival;
        end
    endtask

    initial begin
        $dumpfile("fft128_dit.vcd");
        $dumpvars(0, tb_fft128_dit);

        in_re = {128*WIDTH{1'b0}};
        in_im = {128*WIDTH{1'b0}};

        // ----------------------------------------------------
        // 128 manual input samples
        // Here I am giving real input = 1..128, imag = 0
        // ----------------------------------------------------
        set_sample(0,   24'sd1,   24'sd0);
        set_sample(1,   24'sd2,   24'sd0);
        set_sample(2,   24'sd3,   24'sd0);
        set_sample(3,   24'sd4,   24'sd0);
        set_sample(4,   24'sd5,   24'sd0);
        set_sample(5,   24'sd6,   24'sd0);
        set_sample(6,   24'sd7,   24'sd0);
        set_sample(7,   24'sd8,   24'sd0);
        set_sample(8,   24'sd9,   24'sd0);
        set_sample(9,   24'sd10,  24'sd0);
        set_sample(10,  24'sd11,  24'sd0);
        set_sample(11,  24'sd12,  24'sd0);
        set_sample(12,  24'sd13,  24'sd0);
        set_sample(13,  24'sd14,  24'sd0);
        set_sample(14,  24'sd15,  24'sd0);
        set_sample(15,  24'sd16,  24'sd0);
        set_sample(16,  24'sd17,  24'sd0);
        set_sample(17,  24'sd18,  24'sd0);
        set_sample(18,  24'sd19,  24'sd0);
        set_sample(19,  24'sd20,  24'sd0);
        set_sample(20,  24'sd21,  24'sd0);
        set_sample(21,  24'sd22,  24'sd0);
        set_sample(22,  24'sd23,  24'sd0);
        set_sample(23,  24'sd24,  24'sd0);
        set_sample(24,  24'sd25,  24'sd0);
        set_sample(25,  24'sd26,  24'sd0);
        set_sample(26,  24'sd27,  24'sd0);
        set_sample(27,  24'sd28,  24'sd0);
        set_sample(28,  24'sd29,  24'sd0);
        set_sample(29,  24'sd30,  24'sd0);
        set_sample(30,  24'sd31,  24'sd0);
        set_sample(31,  24'sd32,  24'sd0);
        set_sample(32,  24'sd33,  24'sd0);
        set_sample(33,  24'sd34,  24'sd0);
        set_sample(34,  24'sd35,  24'sd0);
        set_sample(35,  24'sd36,  24'sd0);
        set_sample(36,  24'sd37,  24'sd0);
        set_sample(37,  24'sd38,  24'sd0);
        set_sample(38,  24'sd39,  24'sd0);
        set_sample(39,  24'sd40,  24'sd0);
        set_sample(40,  24'sd41,  24'sd0);
        set_sample(41,  24'sd42,  24'sd0);
        set_sample(42,  24'sd43,  24'sd0);
        set_sample(43,  24'sd44,  24'sd0);
        set_sample(44,  24'sd45,  24'sd0);
        set_sample(45,  24'sd46,  24'sd0);
        set_sample(46,  24'sd47,  24'sd0);
        set_sample(47,  24'sd48,  24'sd0);
        set_sample(48,  24'sd49,  24'sd0);
        set_sample(49,  24'sd50,  24'sd0);
        set_sample(50,  24'sd51,  24'sd0);
        set_sample(51,  24'sd52,  24'sd0);
        set_sample(52,  24'sd53,  24'sd0);
        set_sample(53,  24'sd54,  24'sd0);
        set_sample(54,  24'sd55,  24'sd0);
        set_sample(55,  24'sd56,  24'sd0);
        set_sample(56,  24'sd57,  24'sd0);
        set_sample(57,  24'sd58,  24'sd0);
        set_sample(58,  24'sd59,  24'sd0);
        set_sample(59,  24'sd60,  24'sd0);
        set_sample(60,  24'sd61,  24'sd0);
        set_sample(61,  24'sd62,  24'sd0);
        set_sample(62,  24'sd63,  24'sd0);
        set_sample(63,  24'sd64,  24'sd0);
        set_sample(64,  24'sd65,  24'sd0);
        set_sample(65,  24'sd66,  24'sd0);
        set_sample(66,  24'sd67,  24'sd0);
        set_sample(67,  24'sd68,  24'sd0);
        set_sample(68,  24'sd69,  24'sd0);
        set_sample(69,  24'sd70,  24'sd0);
        set_sample(70,  24'sd71,  24'sd0);
        set_sample(71,  24'sd72,  24'sd0);
        set_sample(72,  24'sd73,  24'sd0);
        set_sample(73,  24'sd74,  24'sd0);
        set_sample(74,  24'sd75,  24'sd0);
        set_sample(75,  24'sd76,  24'sd0);
        set_sample(76,  24'sd77,  24'sd0);
        set_sample(77,  24'sd78,  24'sd0);
        set_sample(78,  24'sd79,  24'sd0);
        set_sample(79,  24'sd80,  24'sd0);
        set_sample(80,  24'sd81,  24'sd0);
        set_sample(81,  24'sd82,  24'sd0);
        set_sample(82,  24'sd83,  24'sd0);
        set_sample(83,  24'sd84,  24'sd0);
        set_sample(84,  24'sd85,  24'sd0);
        set_sample(85,  24'sd86,  24'sd0);
        set_sample(86,  24'sd87,  24'sd0);
        set_sample(87,  24'sd88,  24'sd0);
        set_sample(88,  24'sd89,  24'sd0);
        set_sample(89,  24'sd90,  24'sd0);
        set_sample(90,  24'sd91,  24'sd0);
        set_sample(91,  24'sd92,  24'sd0);
        set_sample(92,  24'sd93,  24'sd0);
        set_sample(93,  24'sd94,  24'sd0);
        set_sample(94,  24'sd95,  24'sd0);
        set_sample(95,  24'sd96,  24'sd0);
        set_sample(96,  24'sd97,  24'sd0);
        set_sample(97,  24'sd98,  24'sd0);
        set_sample(98,  24'sd99,  24'sd0);
        set_sample(99,  24'sd100, 24'sd0);
        set_sample(100, 24'sd101, 24'sd0);
        set_sample(101, 24'sd102, 24'sd0);
        set_sample(102, 24'sd103, 24'sd0);
        set_sample(103, 24'sd104, 24'sd0);
        set_sample(104, 24'sd105, 24'sd0);
        set_sample(105, 24'sd106, 24'sd0);
        set_sample(106, 24'sd107, 24'sd0);
        set_sample(107, 24'sd108, 24'sd0);
        set_sample(108, 24'sd109, 24'sd0);
        set_sample(109, 24'sd110, 24'sd0);
        set_sample(110, 24'sd111, 24'sd0);
        set_sample(111, 24'sd112, 24'sd0);
        set_sample(112, 24'sd113, 24'sd0);
        set_sample(113, 24'sd114, 24'sd0);
        set_sample(114, 24'sd115, 24'sd0);
        set_sample(115, 24'sd116, 24'sd0);
        set_sample(116, 24'sd117, 24'sd0);
        set_sample(117, 24'sd118, 24'sd0);
        set_sample(118, 24'sd119, 24'sd0);
        set_sample(119, 24'sd120, 24'sd0);
        set_sample(120, 24'sd121, 24'sd0);
        set_sample(121, 24'sd122, 24'sd0);
        set_sample(122, 24'sd123, 24'sd0);
        set_sample(123, 24'sd124, 24'sd0);
        set_sample(124, 24'sd125, 24'sd0);
        set_sample(125, 24'sd126, 24'sd0);
        set_sample(126, 24'sd127, 24'sd0);
        set_sample(127, 24'sd128, 24'sd0);

        #50;

        $display("==============================================================");
        $display("128-point DIT FFT Output");
        $display("Format: X[k] = Re + jIm");
        $display("==============================================================");

        for (k = 0; k < 128; k = k + 1) begin
            $display("X[%0d] = %0d + j%0d",
                     k,
                     $signed(out_re[(k*WIDTH)+:WIDTH]),
                     $signed(out_im[(k*WIDTH)+:WIDTH]));
        end

        $display("==============================================================");
        $finish;
    end

endmodule
