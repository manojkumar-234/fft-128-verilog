# 128-Point DIT FFT in Verilog

## 📌 Overview

This project implements a **128-point Decimation-In-Time (DIT) Fast Fourier Transform (FFT)** using Verilog HDL.

The design is fully modular and hierarchical:

* 128-point FFT
* Built using 32-point FFT blocks
* Which are built from 8-point and 4-point FFTs

## 🧠 Key Concepts

* Decimation-In-Time (DIT) FFT
* Butterfly operations
* Twiddle factor multiplication
* Fixed-point arithmetic (Q1.15)

## 🧩 Architecture

```
128-point FFT
   ↓
4 × 32-point FFT
   ↓
4 × 8-point FFT
   ↓
2 × 4-point FFT
```

## ⚙️ Features

* Parameterized data width
* LUT-based twiddle factors
* Complex number support (real + imaginary)
* Modular design (reusable blocks)

## 📂 Project Structure

* `rtl/` → Verilog source code
* `tb/` → Testbench files
* `docs/` → Architecture diagrams

## 🚧 Status

🟡 Under development

## 👨‍💻 Author

 * ASHISH P 123EC0011
* B CHETHAN 123EC0049
* MANOJ KUMAR 523EC0008
* SURAJ PAL 523EC0009
