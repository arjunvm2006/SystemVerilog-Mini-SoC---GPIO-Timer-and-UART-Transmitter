## Mini-SoC RTL Design Project

This project is a small SystemVerilog-based SoC foundation that I designed to strengthen my RTL design, digital verification, and VLSI design-flow skills.

The design combines three common digital peripherals—GPIO, a timer, and a UART transmitter—under one top-level module. Each peripheral was designed independently, verified with a self-checking testbench, inspected using GTKWave, and then integrated and synthesized using Yosys.

## Why I built this

I wanted a hands-on project that connects the digital electronics concepts I have studied with a practical chip-design workflow.

Instead of only writing individual Verilog examples, I built and verified reusable hardware blocks, integrated them into a mini-SoC, and generated a synthesis report. This resembles the early RTL-to-synthesis stages of real FPGA and ASIC development.

## GPIO peripheral

The GPIO peripheral provides:

- 8-bit registered output
- Write enable for updating output pins
- Input readback interface
- Reset behavior verification

## Timer peripheral

The timer peripheral provides:

- 32-bit counter
- Enable and pause control
- Clear/reset control
- Counter readback interface

## UART transmitter

The UART transmitter provides:

- UART 8N1 frame format
- Start bit generation
- 8 data bits transmitted LSB first
- Stop bit generation
- Busy signal while transmission is active

> The UART baud divider is intentionally set to a small value for fast simulation. A real hardware target would use a divider calculated from the board clock frequency and required baud rate.

## Verification

Each module has a dedicated self-checking SystemVerilog testbench.

The following simulations passed successfully:

| Testbench | Verification performed |
|---|---|
| `tb_gpio.sv` | GPIO write and input-read behavior |
| `tb_timer.sv` | Reset, count, pause, clear, and readback |
| `tb_uart_tx.sv` | UART start bit, data bits, and stop bit |
| `tb_soc_top.sv` | Integration of GPIO, timer, and UART |

Waveforms were generated as VCD files and inspected in GTKWave.

## Synthesis

The complete `soc_top` design was synthesized using Yosys.

| Result | Value |
|---|---:|
| Top module | `soc_top` |
| Generic logic cells | 281 |
| GPIO cells | 16 |
| Timer cells | 186 |
| UART TX cells | 79 |
| Reported synthesis problems | 0 |

The detailed report is available in [`docs/synthesis_report.txt`](docs/synthesis_report.txt).

## Tools used

- SystemVerilog
- Icarus Verilog for simulation
- GTKWave for waveform analysis
- Yosys for RTL synthesis
- Git for version control
- VS Code, WSL2, and Ubuntu for development

## Project structure

```text
riscv-fpga-soc/
├── README.md
├── docs/
│   └── synthesis_report.txt
├── rtl/
│   ├── gpio.sv
│   ├── timer.sv
│   ├── uart_tx.sv
│   └── soc_top.sv
└── tb/
    ├── tb_gpio.sv
    ├── tb_timer.sv
    ├── tb_uart_tx.sv
    └── tb_soc_top.sv
```

## How to run the complete Mini-SoC simulation

```bash
iverilog -g2012 -o simv_soc rtl/gpio.sv rtl/timer.sv rtl/uart_tx.sv rtl/soc_top.sv tb/tb_soc_top.sv
vvp simv_soc
```

Expected output:

```text
PASS: Mini-SoC integration verified.
```

## Next improvements

This Version 1 project is simulation- and synthesis-verified. Planned Version 2 improvements are:

- Add a memory-mapped bus interface
- Integrate a RISC-V CPU core
- Add SPI and I2C peripherals
- Add an interrupt controller
- Target an FPGA board and perform timing-constraint analysis
- Explore ASIC physical design using OpenLane/OpenROAD