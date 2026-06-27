# Router 1×3 — Design and Verification

A synthesizable 1×3 packet router designed in Verilog/SystemVerilog that routes an 8-bit input signal to one of three output ports based on OSI-layer addressing. The project includes a full UVM-style verification environment with coverage-driven verification, functional coverage, and SystemVerilog assertions (SVA).

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Signal Description](#signal-description)
- [Verification Methodology](#verification-methodology)
- [How to Run](#how-to-run)
- [Tools & Technologies](#tools--technologies)

---

## Overview

The Router 1×3 accepts an 8-bit data packet on a single input port and routes it to one of three destination ports (`port0`, `port1`, `port2`) based on address bits embedded in the packet header, following the OSI protocol framing convention.

Key objectives of this project:

- Design a synthesizable RTL model of the 1×3 router in Verilog
- Develop a structured, modular verification environment in SystemVerilog
- Achieve high functional coverage through constrained-random stimulus
- Validate correctness using SystemVerilog Assertions (SVA)

---

## Architecture

```
           ┌─────────────────────────┐
           │                         │
  data_in  │      Router 1×3         │──► port0 (destination 0)
 ─────────►│                         │
  addr[1:0]│    (Verilog RTL)        │──► port1 (destination 1)
 ─────────►│                         │
           │                         │──► port2 (destination 2)
           └─────────────────────────┘
```

The router decodes the 2-bit address field from the incoming packet header and steers the 8-bit data payload to the corresponding output port. Invalid addresses are handled gracefully with a default routing policy.

---

## Repository Structure

```
Router-1X3-Design-and-Verification/
│
├── rtl/                    # Synthesizable RTL design
│   └── router.v            # Top-level Verilog router module
│
├── tb/                     # Testbench top-level
│   └── router_tb.sv        # Top-level testbench / DUT instantiation
│
├── src_agt_top/            # Source agent (UVM-style)
│   ├── src_driver.sv       # Drives stimulus to DUT input
│   ├── src_monitor.sv      # Monitors DUT input port
│   └── src_agent.sv        # Source agent wrapper
│
├── dst_agt_top/            # Destination agent (UVM-style)
│   ├── dst_driver.sv       # Drives acknowledgment signals
│   ├── dst_monitor.sv      # Monitors DUT output ports
│   └── dst_agent.sv        # Destination agent wrapper
│
├── test/                   # Test cases
│   └── router_test.sv      # Directed and constrained-random tests
│
├── sim/                    # Simulation scripts and Makefile
│   └── Makefile            # Build and simulation commands
│
└── README.md
```

---

## Signal Description

| Signal       | Direction | Width  | Description                                      |
|--------------|-----------|--------|--------------------------------------------------|
| `clk`        | Input     | 1-bit  | System clock                                     |
| `resetn`     | Input     | 1-bit  | Active-low synchronous reset                     |
| `data_in`    | Input     | 8-bit  | Incoming data packet                             |
| `valid_in`   | Input     | 1-bit  | Asserted when input data is valid                |
| `addr`       | Input     | 2-bit  | Destination address (selects output port 0/1/2)  |
| `data_out_0` | Output    | 8-bit  | Data routed to destination port 0                |
| `data_out_1` | Output    | 8-bit  | Data routed to destination port 1                |
| `data_out_2` | Output    | 8-bit  | Data routed to destination port 2                |
| `valid_out`  | Output    | 3-bit  | Valid signals for each output port               |

---

## Verification Methodology

The verification environment follows a layered, agent-based architecture inspired by UVM principles, implemented in SystemVerilog.

**Source Agent (`src_agt_top/`)**
Generates constrained-random transactions targeting the router's input interface. Covers all valid address combinations and edge-case data patterns.

**Destination Agent (`dst_agt_top/`)**
Monitors all three output ports, collects observed transactions, and drives any required acknowledgment signals back to the DUT.

**Testbench (`tb/`)**
Instantiates the DUT alongside both agents, connects the interface, and drives the simulation clock and reset.

**Functional Coverage**
Covergroups are defined to track:
- All address values (0, 1, 2, and invalid addresses)
- Data patterns (all-zeros, all-ones, alternating bits)
- Back-to-back valid transfers
- Cross-coverage of address × data patterns

**SystemVerilog Assertions (SVA)**
Assertions are used to verify:
- Output is never driven when `valid_in` is de-asserted
- Only the addressed port receives data during a valid transaction
- No data corruption between input and the selected output
- Reset correctly de-asserts all outputs

---

## How to Run

### Prerequisites

- A SystemVerilog-capable simulator: **ModelSim**, **QuestaSim**, **VCS**, or **Xcelium**
- GNU Make

### Simulation

```bash
# Navigate to the sim directory
cd sim

# Compile and run the simulation
make

# To run a specific test
make TEST=router_test

# To view waveforms (ModelSim/QuestaSim)
make wave
```

> Adjust the `Makefile` tool paths to match your local simulator installation.

---

## Tools & Technologies

| Category        | Tool / Language               |
|-----------------|-------------------------------|
| RTL Design      | Verilog                       |
| Verification    | SystemVerilog                 |
| Assertions      | SystemVerilog Assertions (SVA)|
| Build System    | GNU Make                      |
| Simulator       | ModelSim / QuestaSim / VCS    |
| Protocol        | OSI Packet Framing            |

---

## Author

**Jandhyam Mohan Ganga**
[GitHub Profile](https://github.com/jandhyammohanganga)
