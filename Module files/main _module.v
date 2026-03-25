`timescale 1ns / 1ps

// ============================================================
// Complex Twiddle Multiplier (LUT-based twiddle ROM)
// Twiddle = W_N^K = cos(2*pi*K/N) - j sin(2*pi*K/N)
// Coefficients stored in Q1.15
// Data is signed WIDTH-bit fixed point
// ============================================================
module complex_mult_twiddle #
(
    parameter WIDTH = 24,
    parameter N     = 8,
    parameter K     = 0
)
(
    input  signed [WIDTH-1:0] in_re,
    input  signed [WIDTH-1:0] in_im,
    output signed [WIDTH-1:0] out_re,
    output signed [WIDTH-1:0] out_im
);

    function signed [15:0] base_cos8;
        input integer idx;
        begin
            case (idx)
                0: base_cos8 = 16'sd32767;
                1: base_cos8 = 16'sd23170;
                2: base_cos8 = 16'sd0;
                default: base_cos8 = 16'sd0;
            endcase
        end
    endfunction

    function signed [15:0] base_sin8;
        input integer idx;
        begin
            case (idx)
                0: base_sin8 = 16'sd0;
                1: base_sin8 = 16'sd23170;
                2: base_sin8 = 16'sd32767;
                default: base_sin8 = 16'sd0;
            endcase
        end
    endfunction

    function signed [15:0] base_cos32;
        input integer idx;
        begin
            case (idx)
                0: base_cos32 = 16'sd32767;
                1: base_cos32 = 16'sd32138;
                2: base_cos32 = 16'sd30274;
                3: base_cos32 = 16'sd27246;
                4: base_cos32 = 16'sd23170;
                5: base_cos32 = 16'sd18205;
                6: base_cos32 = 16'sd12540;
                7: base_cos32 = 16'sd6393;
                8: base_cos32 = 16'sd0;
                default: base_cos32 = 16'sd0;
            endcase
        end
    endfunction

    function signed [15:0] base_sin32;
        input integer idx;
        begin
            case (idx)
                0: base_sin32 = 16'sd0;
                1: base_sin32 = 16'sd6393;
                2: base_sin32 = 16'sd12540;
                3: base_sin32 = 16'sd18205;
                4: base_sin32 = 16'sd23170;
                5: base_sin32 = 16'sd27246;
                6: base_sin32 = 16'sd30274;
                7: base_sin32 = 16'sd32138;
                8: base_sin32 = 16'sd32767;
                default: base_sin32 = 16'sd0;
            endcase
        end
    endfunction

    function signed [15:0] base_cos128;
        input integer idx;
        begin
            case (idx)
                0 : base_cos128 = 16'sd32767;
                1 : base_cos128 = 16'sd32729;
                2 : base_cos128 = 16'sd32610;
                3 : base_cos128 = 16'sd32413;
                4 : base_cos128 = 16'sd32138;
                5 : base_cos128 = 16'sd31786;
                6 : base_cos128 = 16'sd31357;
                7 : base_cos128 = 16'sd30853;
                8 : base_cos128 = 16'sd30274;
                9 : base_cos128 = 16'sd29622;
                10: base_cos128 = 16'sd28899;
                11: base_cos128 = 16'sd28106;
                12: base_cos128 = 16'sd27246;
                13: base_cos128 = 16'sd26320;
                14: base_cos128 = 16'sd25330;
                15: base_cos128 = 16'sd24279;
                16: base_cos128 = 16'sd23170;
                17: base_cos128 = 16'sd22006;
                18: base_cos128 = 16'sd20788;
                19: base_cos128 = 16'sd19520;
                20: base_cos128 = 16'sd18205;
                21: base_cos128 = 16'sd16846;
                22: base_cos128 = 16'sd15447;
                23: base_cos128 = 16'sd14010;
                24: base_cos128 = 16'sd12540;
                25: base_cos128 = 16'sd11039;
                26: base_cos128 = 16'sd9512;
                27: base_cos128 = 16'sd7962;
                28: base_cos128 = 16'sd6393;
                29: base_cos128 = 16'sd4808;
                30: base_cos128 = 16'sd3212;
                31: base_cos128 = 16'sd1608;
                32: base_cos128 = 16'sd0;
                default: base_cos128 = 16'sd0;
            endcase
        end
    endfunction

    function signed [15:0] base_sin128;
        input integer idx;
        begin
            case (idx)
                0 : base_sin128 = 16'sd0;
                1 : base_sin128 = 16'sd1608;
                2 : base_sin128 = 16'sd3212;
                3 : base_sin128 = 16'sd4808;
                4 : base_sin128 = 16'sd6393;
                5 : base_sin128 = 16'sd7962;
                6 : base_sin128 = 16'sd9512;
                7 : base_sin128 = 16'sd11039;
                8 : base_sin128 = 16'sd12540;
                9 : base_sin128 = 16'sd14010;
                10: base_sin128 = 16'sd15447;
                11: base_sin128 = 16'sd16846;
                12: base_sin128 = 16'sd18205;
                13: base_sin128 = 16'sd19520;
                14: base_sin128 = 16'sd20788;
                15: base_sin128 = 16'sd22006;
                16: base_sin128 = 16'sd23170;
                17: base_sin128 = 16'sd24279;
                18: base_sin128 = 16'sd25330;
                19: base_sin128 = 16'sd26320;
                20: base_sin128 = 16'sd27246;
                21: base_sin128 = 16'sd28106;
                22: base_sin128 = 16'sd28899;
                23: base_sin128 = 16'sd29622;
                24: base_sin128 = 16'sd30274;
                25: base_sin128 = 16'sd30853;
                26: base_sin128 = 16'sd31357;
                27: base_sin128 = 16'sd31786;
                28: base_sin128 = 16'sd32138;
                29: base_sin128 = 16'sd32413;
                30: base_sin128 = 16'sd32610;
                31: base_sin128 = 16'sd32729;
                32: base_sin128 = 16'sd32767;
                default: base_sin128 = 16'sd0;
            endcase
        end
    endfunction

    function signed [15:0] tw_re;
        input integer idx;
        integer kk;
        begin
            kk = idx % N;
            if (kk < 0)
                kk = kk + N;

            if (N == 8) begin
                if (kk <= 2)
                    tw_re =  base_cos8(kk);
                else if (kk < 4)
                    tw_re = -base_cos8(4-kk);
                else if (kk <= 6)
                    tw_re = -base_cos8(kk-4);
                else
                    tw_re =  base_cos8(8-kk);
            end
            else if (N == 32) begin
                if (kk <= 8)
                    tw_re =  base_cos32(kk);
                else if (kk < 16)
                    tw_re = -base_cos32(16-kk);
                else if (kk <= 24)
                    tw_re = -base_cos32(kk-16);
                else
                    tw_re =  base_cos32(32-kk);
            end
            else begin // N == 128
                if (kk <= 32)
                    tw_re =  base_cos128(kk);
                else if (kk < 64)
                    tw_re = -base_cos128(64-kk);
                else if (kk <= 96)
                    tw_re = -base_cos128(kk-64);
                else
                    tw_re =  base_cos128(128-kk);
            end
        end
    endfunction

    function signed [15:0] tw_im;
        input integer idx;
        integer kk;
        begin
            kk = idx % N;
            if (kk < 0)
                kk = kk + N;

            if (N == 8) begin
                if (kk <= 2)
                    tw_im = -base_sin8(kk);
                else if (kk < 4)
                    tw_im = -base_sin8(4-kk);
                else if (kk <= 6)
                    tw_im =  base_sin8(kk-4);
                else
                    tw_im =  base_sin8(8-kk);
            end
            else if (N == 32) begin
                if (kk <= 8)
                    tw_im = -base_sin32(kk);
                else if (kk < 16)
                    tw_im = -base_sin32(16-kk);
                else if (kk <= 24)
                    tw_im =  base_sin32(kk-16);
                else
                    tw_im =  base_sin32(32-kk);
            end
            else begin // N == 128
                if (kk <= 32)
                    tw_im = -base_sin128(kk);
                else if (kk < 64)
                    tw_im = -base_sin128(64-kk);
                else if (kk <= 96)
                    tw_im =  base_sin128(kk-64);
                else
                    tw_im =  base_sin128(128-kk);
            end
        end
    endfunction

    wire signed [15:0] w_re;
    wire signed [15:0] w_im;

    assign w_re = tw_re(K);
    assign w_im = tw_im(K);

    wire signed [WIDTH+15:0] mult_rr;
    wire signed [WIDTH+15:0] mult_ii;
    wire signed [WIDTH+15:0] mult_ri;
    wire signed [WIDTH+15:0] mult_ir;

    assign mult_rr = in_re * w_re;
    assign mult_ii = in_im * w_im;
    assign mult_ri = in_re * w_im;
    assign mult_ir = in_im * w_re;

    assign out_re = (mult_rr - mult_ii) >>> 15;
    assign out_im = (mult_ri + mult_ir) >>> 15;

endmodule


// ============================================================
// 4-point DIT FFT
// input/output buses are flattened:
// sample k occupies [(k*WIDTH)+:WIDTH]
// ============================================================
module fft4_dit #
(
    parameter WIDTH = 24
)
(
    input  [4*WIDTH-1:0] in_re,
    input  [4*WIDTH-1:0] in_im,
    output [4*WIDTH-1:0] out_re,
    output [4*WIDTH-1:0] out_im
);

    wire signed [WIDTH-1:0] x0_re, x1_re, x2_re, x3_re;
    wire signed [WIDTH-1:0] x0_im, x1_im, x2_im, x3_im;

    assign x0_re = in_re[(0*WIDTH)+:WIDTH];
    assign x1_re = in_re[(1*WIDTH)+:WIDTH];
    assign x2_re = in_re[(2*WIDTH)+:WIDTH];
    assign x3_re = in_re[(3*WIDTH)+:WIDTH];

    assign x0_im = in_im[(0*WIDTH)+:WIDTH];
    assign x1_im = in_im[(1*WIDTH)+:WIDTH];
    assign x2_im = in_im[(2*WIDTH)+:WIDTH];
    assign x3_im = in_im[(3*WIDTH)+:WIDTH];

    wire signed [WIDTH-1:0] e0_re, e0_im, e1_re, e1_im;
    wire signed [WIDTH-1:0] o0_re, o0_im, o1_re, o1_im;
    wire signed [WIDTH-1:0] t1_re, t1_im;

    assign e0_re = x0_re + x2_re;
    assign e0_im = x0_im + x2_im;

    assign e1_re = x0_re - x2_re;
    assign e1_im = x0_im - x2_im;

    assign o0_re = x1_re + x3_re;
    assign o0_im = x1_im + x3_im;

    assign o1_re = x1_re - x3_re;
    assign o1_im = x1_im - x3_im;

    // Multiply by W4^1 = -j
    assign t1_re =  o1_im;
    assign t1_im = -o1_re;

    assign out_re[(0*WIDTH)+:WIDTH] = e0_re + o0_re;
    assign out_im[(0*WIDTH)+:WIDTH] = e0_im + o0_im;

    assign out_re[(2*WIDTH)+:WIDTH] = e0_re - o0_re;
    assign out_im[(2*WIDTH)+:WIDTH] = e0_im - o0_im;

    assign out_re[(1*WIDTH)+:WIDTH] = e1_re + t1_re;
    assign out_im[(1*WIDTH)+:WIDTH] = e1_im + t1_im;

    assign out_re[(3*WIDTH)+:WIDTH] = e1_re - t1_re;
    assign out_im[(3*WIDTH)+:WIDTH] = e1_im - t1_im;

endmodule


// ============================================================
// 8-point DIT FFT
// Built from two 4-point DIT blocks + W8 twiddles
// ============================================================
module fft8_dit #
(
    parameter WIDTH = 24
)
(
    input  [8*WIDTH-1:0] in_re,
    input  [8*WIDTH-1:0] in_im,
    output [8*WIDTH-1:0] out_re,
    output [8*WIDTH-1:0] out_im
);

    wire [4*WIDTH-1:0] even_in_re, odd_in_re;
    wire [4*WIDTH-1:0] even_in_im, odd_in_im;
    wire [4*WIDTH-1:0] even_out_re, odd_out_re;
    wire [4*WIDTH-1:0] even_out_im, odd_out_im;

    genvar n;
    generate
        for (n = 0; n < 4; n = n + 1) begin : MAP8
            assign even_in_re[(n*WIDTH)+:WIDTH] = in_re[((2*n)*WIDTH)+:WIDTH];
            assign even_in_im[(n*WIDTH)+:WIDTH] = in_im[((2*n)*WIDTH)+:WIDTH];
            assign odd_in_re [(n*WIDTH)+:WIDTH] = in_re[((2*n+1)*WIDTH)+:WIDTH];
            assign odd_in_im [(n*WIDTH)+:WIDTH] = in_im[((2*n+1)*WIDTH)+:WIDTH];
        end
    endgenerate

    fft4_dit #(.WIDTH(WIDTH)) U_EVEN4 (
        .in_re(even_in_re), .in_im(even_in_im),
        .out_re(even_out_re), .out_im(even_out_im)
    );

    fft4_dit #(.WIDTH(WIDTH)) U_ODD4 (
        .in_re(odd_in_re), .in_im(odd_in_im),
        .out_re(odd_out_re), .out_im(odd_out_im)
    );

    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : COMB8
            wire signed [WIDTH-1:0] e_re, e_im;
            wire signed [WIDTH-1:0] o_re, o_im;
            wire signed [WIDTH-1:0] t_re, t_im;

            assign e_re = even_out_re[(k*WIDTH)+:WIDTH];
            assign e_im = even_out_im[(k*WIDTH)+:WIDTH];
            assign o_re = odd_out_re[(k*WIDTH)+:WIDTH];
            assign o_im = odd_out_im[(k*WIDTH)+:WIDTH];

            complex_mult_twiddle #(.WIDTH(WIDTH), .N(8), .K(k)) U_TW8 (
                .in_re(o_re), .in_im(o_im),
                .out_re(t_re), .out_im(t_im)
            );

            assign out_re[(k*WIDTH)+:WIDTH]       = e_re + t_re;
            assign out_im[(k*WIDTH)+:WIDTH]       = e_im + t_im;
            assign out_re[((k+4)*WIDTH)+:WIDTH]   = e_re - t_re;
            assign out_im[((k+4)*WIDTH)+:WIDTH]   = e_im - t_im;
        end
    endgenerate

endmodule


// ============================================================
// 32-point DIT FFT
// Built from 4 x 8-point FFTs on decimated subsequences
// Then twiddle multiply and 4-point DFT combine
// ============================================================
module fft32_dit #
(
    parameter WIDTH = 24
)
(
    input  [32*WIDTH-1:0] in_re,
    input  [32*WIDTH-1:0] in_im,
    output [32*WIDTH-1:0] out_re,
    output [32*WIDTH-1:0] out_im
);

    wire [8*WIDTH-1:0] in0_re, in1_re, in2_re, in3_re;
    wire [8*WIDTH-1:0] in0_im, in1_im, in2_im, in3_im;
    wire [8*WIDTH-1:0] y0_re,  y1_re,  y2_re,  y3_re;
    wire [8*WIDTH-1:0] y0_im,  y1_im,  y2_im,  y3_im;

    genvar m;
    generate
        for (m = 0; m < 8; m = m + 1) begin : MAP32_IN
            assign in0_re[(m*WIDTH)+:WIDTH] = in_re[((4*m+0)*WIDTH)+:WIDTH];
            assign in0_im[(m*WIDTH)+:WIDTH] = in_im[((4*m+0)*WIDTH)+:WIDTH];

            assign in1_re[(m*WIDTH)+:WIDTH] = in_re[((4*m+1)*WIDTH)+:WIDTH];
            assign in1_im[(m*WIDTH)+:WIDTH] = in_im[((4*m+1)*WIDTH)+:WIDTH];

            assign in2_re[(m*WIDTH)+:WIDTH] = in_re[((4*m+2)*WIDTH)+:WIDTH];
            assign in2_im[(m*WIDTH)+:WIDTH] = in_im[((4*m+2)*WIDTH)+:WIDTH];

            assign in3_re[(m*WIDTH)+:WIDTH] = in_re[((4*m+3)*WIDTH)+:WIDTH];
            assign in3_im[(m*WIDTH)+:WIDTH] = in_im[((4*m+3)*WIDTH)+:WIDTH];
        end
    endgenerate

    fft8_dit #(.WIDTH(WIDTH)) U8_0 (.in_re(in0_re), .in_im(in0_im), .out_re(y0_re), .out_im(y0_im));
    fft8_dit #(.WIDTH(WIDTH)) U8_1 (.in_re(in1_re), .in_im(in1_im), .out_re(y1_re), .out_im(y1_im));
    fft8_dit #(.WIDTH(WIDTH)) U8_2 (.in_re(in2_re), .in_im(in2_im), .out_re(y2_re), .out_im(y2_im));
    fft8_dit #(.WIDTH(WIDTH)) U8_3 (.in_re(in3_re), .in_im(in3_im), .out_re(y3_re), .out_im(y3_im));

    genvar kk;
    generate
        for (kk = 0; kk < 8; kk = kk + 1) begin : COL32
            wire signed [WIDTH-1:0] a0_re, a0_im;
            wire signed [WIDTH-1:0] a1_re, a1_im;
            wire signed [WIDTH-1:0] a2_re, a2_im;
            wire signed [WIDTH-1:0] a3_re, a3_im;

            wire signed [WIDTH-1:0] t1_re, t1_im;
            wire signed [WIDTH-1:0] t2_re, t2_im;
            wire signed [WIDTH-1:0] t3_re, t3_im;

            wire [4*WIDTH-1:0] col_re, col_im;
            wire [4*WIDTH-1:0] mix_re, mix_im;

            assign a0_re = y0_re[(kk*WIDTH)+:WIDTH];
            assign a0_im = y0_im[(kk*WIDTH)+:WIDTH];

            assign a1_re = y1_re[(kk*WIDTH)+:WIDTH];
            assign a1_im = y1_im[(kk*WIDTH)+:WIDTH];

            assign a2_re = y2_re[(kk*WIDTH)+:WIDTH];
            assign a2_im = y2_im[(kk*WIDTH)+:WIDTH];

            assign a3_re = y3_re[(kk*WIDTH)+:WIDTH];
            assign a3_im = y3_im[(kk*WIDTH)+:WIDTH];

            complex_mult_twiddle #(.WIDTH(WIDTH), .N(32), .K(kk))     TW1 (.in_re(a1_re), .in_im(a1_im), .out_re(t1_re), .out_im(t1_im));
            complex_mult_twiddle #(.WIDTH(WIDTH), .N(32), .K(2*kk))   TW2 (.in_re(a2_re), .in_im(a2_im), .out_re(t2_re), .out_im(t2_im));
            complex_mult_twiddle #(.WIDTH(WIDTH), .N(32), .K(3*kk))   TW3 (.in_re(a3_re), .in_im(a3_im), .out_re(t3_re), .out_im(t3_im));

            assign col_re[(0*WIDTH)+:WIDTH] = a0_re;
            assign col_im[(0*WIDTH)+:WIDTH] = a0_im;

            assign col_re[(1*WIDTH)+:WIDTH] = t1_re;
            assign col_im[(1*WIDTH)+:WIDTH] = t1_im;

            assign col_re[(2*WIDTH)+:WIDTH] = t2_re;
            assign col_im[(2*WIDTH)+:WIDTH] = t2_im;

            assign col_re[(3*WIDTH)+:WIDTH] = t3_re;
            assign col_im[(3*WIDTH)+:WIDTH] = t3_im;

            fft4_dit #(.WIDTH(WIDTH)) U4_COL32 (
                .in_re(col_re), .in_im(col_im),
                .out_re(mix_re), .out_im(mix_im)
            );

            assign out_re[((kk +  0*8)*WIDTH)+:WIDTH] = mix_re[(0*WIDTH)+:WIDTH];
            assign out_im[((kk +  0*8)*WIDTH)+:WIDTH] = mix_im[(0*WIDTH)+:WIDTH];

            assign out_re[((kk +  1*8)*WIDTH)+:WIDTH] = mix_re[(1*WIDTH)+:WIDTH];
            assign out_im[((kk +  1*8)*WIDTH)+:WIDTH] = mix_im[(1*WIDTH)+:WIDTH];

            assign out_re[((kk +  2*8)*WIDTH)+:WIDTH] = mix_re[(2*WIDTH)+:WIDTH];
            assign out_im[((kk +  2*8)*WIDTH)+:WIDTH] = mix_im[(2*WIDTH)+:WIDTH];

            assign out_re[((kk +  3*8)*WIDTH)+:WIDTH] = mix_re[(3*WIDTH)+:WIDTH];
            assign out_im[((kk +  3*8)*WIDTH)+:WIDTH] = mix_im[(3*WIDTH)+:WIDTH];
        end
    endgenerate

endmodule


// ============================================================
// 128-point DIT FFT
// Built from 4 x 32-point FFTs on decimated subsequences
// Then twiddle multiply and 4-point DFT combine
// ============================================================
module fft128_dit #
(
    parameter WIDTH = 24
)
(
    input  [128*WIDTH-1:0] in_re,
    input  [128*WIDTH-1:0] in_im,
    output [128*WIDTH-1:0] out_re,
    output [128*WIDTH-1:0] out_im
);

    wire [32*WIDTH-1:0] in0_re, in1_re, in2_re, in3_re;
    wire [32*WIDTH-1:0] in0_im, in1_im, in2_im, in3_im;
    wire [32*WIDTH-1:0] y0_re,  y1_re,  y2_re,  y3_re;
    wire [32*WIDTH-1:0] y0_im,  y1_im,  y2_im,  y3_im;

    genvar m;
    generate
        for (m = 0; m < 32; m = m + 1) begin : MAP128_IN
            assign in0_re[(m*WIDTH)+:WIDTH] = in_re[((4*m+0)*WIDTH)+:WIDTH];
            assign in0_im[(m*WIDTH)+:WIDTH] = in_im[((4*m+0)*WIDTH)+:WIDTH];

            assign in1_re[(m*WIDTH)+:WIDTH] = in_re[((4*m+1)*WIDTH)+:WIDTH];
            assign in1_im[(m*WIDTH)+:WIDTH] = in_im[((4*m+1)*WIDTH)+:WIDTH];

            assign in2_re[(m*WIDTH)+:WIDTH] = in_re[((4*m+2)*WIDTH)+:WIDTH];
            assign in2_im[(m*WIDTH)+:WIDTH] = in_im[((4*m+2)*WIDTH)+:WIDTH];

            assign in3_re[(m*WIDTH)+:WIDTH] = in_re[((4*m+3)*WIDTH)+:WIDTH];
            assign in3_im[(m*WIDTH)+:WIDTH] = in_im[((4*m+3)*WIDTH)+:WIDTH];
        end
    endgenerate

    fft32_dit #(.WIDTH(WIDTH)) U32_0 (.in_re(in0_re), .in_im(in0_im), .out_re(y0_re), .out_im(y0_im));
    fft32_dit #(.WIDTH(WIDTH)) U32_1 (.in_re(in1_re), .in_im(in1_im), .out_re(y1_re), .out_im(y1_im));
    fft32_dit #(.WIDTH(WIDTH)) U32_2 (.in_re(in2_re), .in_im(in2_im), .out_re(y2_re), .out_im(y2_im));
    fft32_dit #(.WIDTH(WIDTH)) U32_3 (.in_re(in3_re), .in_im(in3_im), .out_re(y3_re), .out_im(y3_im));

    genvar kk;
    generate
        for (kk = 0; kk < 32; kk = kk + 1) begin : COL128
            wire signed [WIDTH-1:0] a0_re, a0_im;
            wire signed [WIDTH-1:0] a1_re, a1_im;
            wire signed [WIDTH-1:0] a2_re, a2_im;
            wire signed [WIDTH-1:0] a3_re, a3_im;

            wire signed [WIDTH-1:0] t1_re, t1_im;
            wire signed [WIDTH-1:0] t2_re, t2_im;
            wire signed [WIDTH-1:0] t3_re, t3_im;

            wire [4*WIDTH-1:0] col_re, col_im;
            wire [4*WIDTH-1:0] mix_re, mix_im;

            assign a0_re = y0_re[(kk*WIDTH)+:WIDTH];
            assign a0_im = y0_im[(kk*WIDTH)+:WIDTH];

            assign a1_re = y1_re[(kk*WIDTH)+:WIDTH];
            assign a1_im = y1_im[(kk*WIDTH)+:WIDTH];

            assign a2_re = y2_re[(kk*WIDTH)+:WIDTH];
            assign a2_im = y2_im[(kk*WIDTH)+:WIDTH];

            assign a3_re = y3_re[(kk*WIDTH)+:WIDTH];
            assign a3_im = y3_im[(kk*WIDTH)+:WIDTH];

            complex_mult_twiddle #(.WIDTH(WIDTH), .N(128), .K(kk))     TW1 (.in_re(a1_re), .in_im(a1_im), .out_re(t1_re), .out_im(t1_im));
            complex_mult_twiddle #(.WIDTH(WIDTH), .N(128), .K(2*kk))   TW2 (.in_re(a2_re), .in_im(a2_im), .out_re(t2_re), .out_im(t2_im));
            complex_mult_twiddle #(.WIDTH(WIDTH), .N(128), .K(3*kk))   TW3 (.in_re(a3_re), .in_im(a3_im), .out_re(t3_re), .out_im(t3_im));

            assign col_re[(0*WIDTH)+:WIDTH] = a0_re;
            assign col_im[(0*WIDTH)+:WIDTH] = a0_im;

            assign col_re[(1*WIDTH)+:WIDTH] = t1_re;
            assign col_im[(1*WIDTH)+:WIDTH] = t1_im;

            assign col_re[(2*WIDTH)+:WIDTH] = t2_re;
            assign col_im[(2*WIDTH)+:WIDTH] = t2_im;

            assign col_re[(3*WIDTH)+:WIDTH] = t3_re;
            assign col_im[(3*WIDTH)+:WIDTH] = t3_im;

            fft4_dit #(.WIDTH(WIDTH)) U4_COL128 (
                .in_re(col_re), .in_im(col_im),
                .out_re(mix_re), .out_im(mix_im)
            );

            assign out_re[((kk +  0*32)*WIDTH)+:WIDTH] = mix_re[(0*WIDTH)+:WIDTH];
            assign out_im[((kk +  0*32)*WIDTH)+:WIDTH] = mix_im[(0*WIDTH)+:WIDTH];

            assign out_re[((kk +  1*32)*WIDTH)+:WIDTH] = mix_re[(1*WIDTH)+:WIDTH];
            assign out_im[((kk +  1*32)*WIDTH)+:WIDTH] = mix_im[(1*WIDTH)+:WIDTH];

            assign out_re[((kk +  2*32)*WIDTH)+:WIDTH] = mix_re[(2*WIDTH)+:WIDTH];
            assign out_im[((kk +  2*32)*WIDTH)+:WIDTH] = mix_im[(2*WIDTH)+:WIDTH];

            assign out_re[((kk +  3*32)*WIDTH)+:WIDTH] = mix_re[(3*WIDTH)+:WIDTH];
            assign out_im[((kk +  3*32)*WIDTH)+:WIDTH] = mix_im[(3*WIDTH)+:WIDTH];
        end
    endgenerate

endmodule
