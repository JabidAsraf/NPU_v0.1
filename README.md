# NPU Simulation

## Steps to Run the Simulation

1. Make sure **Python** is installed.  
2. Run the following command:  
   ```bash
   python sim/run.py -test 1 -mode 0
## Options

### `-test`
- `0` → Full NPU Test  
- `1` → NPU SPI Register Interface Test  

### `-mode`
- `0` → Command-Line Interface (CLI) Run  
- `1` → Graphical User Interface (GUI) Run  

### Notes
- Compilation is **not required** before running. Each time `run.py` is executed, the full project is automatically compiled.  
- For development, you can modify the code using any preferred text editor. Running `run.py` again will recompile and resimulate the project with the updated changes.


# NPU Architecture

## NPU Parameters
- **Input Number**: Maximum 2^16 = 65536 inputs are allowed.  
- **Hidden Layer Number**: Maximum 2^4 = 16 hidden layers are allowed.  
- **Neurons/Nodes Per Hidden Layer**: Maximum 2^10 = 1024 neurons/nodes are allowed per hidden layer.  

---

## Register Interface
A total of **18 registers** are used to configure the NPU:
- `npu_confg_reg`
- `input_num_reg`
- `16 × hid_layer_confg_reg`

### npu_confg_reg
**Address**: `0x04`

| Bits  | 15:8     | 7        | 6              | 5:2       | 1        | 0         |
|:-----:|:---------|:---------|:---------------|:----------|:---------|:----------|
| Field | reserved | reserved | final_layer_act| layer_num | reserved | start_op  |

**Notes**  
`start_op`: Writing `1` starts operation and auto-exits CONFIG MODE.  
`layer_num`: Number of hidden layers (0–15).  
`final_layer_act`: Enable activation on final layer.

---

### input_num_reg
**Address**: `0x06`

| Bits  | 15:8            | 7:0            |
|:-----:|:-----------------|:---------------|
| Field | input_num[15:8]  | input_num[7:0] |

---

### nth hid_layer_confg_reg
**Address**: `(0x08 + 0x02*n)`

| Bits  | 15:10    | 9:8           | 7:0           |
|:-----:|:---------|:--------------|:--------------|
| Field | reserved | node_num[9:8] | node_num[7:0] |

---

## Data Distribution

### Maximum Allowable Parameters
The internal block RAM layout at **maximum** configuration is summarized below. Two size columns are shown: raw size (bits/bytes) and human-readable size (KB).

| Offset (start…end) | Data                                                | Size (bits/bytes)                 | Size (KB) |
|--------------------|-----------------------------------------------------|-----------------------------------|-----------|
| 0 … 65535          | `input_data[0] … input_data[65535]`                 | `65536 × 16 b = 1,048,576 b (131,072 B)` | 128 KB    |
| 65536 … 131071     | `weight_data_layer0_node0[0] … [65535]`             | `1,048,576 b (131,072 B)`         | 128 KB    |
| 131072             | `bias_layer0_node0`                                 | `16 b (2 B)`                      | —         |
| …                  | …                                                   | …                                 | …         |
| 67109887 … 67175422| `weight_data_layer0_node1023[0] … [65535]`          | `1,048,576 b (131,072 B)`         | 128 KB    |
| 67175423           | `bias_layer0_node1023`                              | `16 b (2 B)`                      | —         |
| 67175424           | **weights & biases of layer1 (all 1024 nodes)**     | `134,219,776 B`                   | **131,074 KB** |
| 134285312          | **weights & biases of layer2**                      | `134,219,776 B`                   | **131,074 KB** |
| 201395200          | **weights & biases of layer3**                      | `134,219,776 B`                   | **131,074 KB** |
| 268505088          | **weights & biases of layer4**                      | `134,219,776 B`                   | **131,074 KB** |
| 335614976          | **weights & biases of layer5**                      | `134,219,776 B`                   | **131,074 KB** |
| 402724864          | **weights & biases of layer6**                      | `134,219,776 B`                   | **131,074 KB** |
| 469834752          | **weights & biases of layer7**                      | `134,219,776 B`                   | **131,074 KB** |
| 536944640          | **weights & biases of layer8**                      | `134,219,776 B`                   | **131,074 KB** |
| 604054528          | **weights & biases of layer9**                      | `134,219,776 B`                   | **131,074 KB** |
| 671164416          | **weights & biases of layer10**                     | `134,219,776 B`                   | **131,074 KB** |
| 738274304          | **weights & biases of layer11**                     | `134,219,776 B`                   | **131,074 KB** |
| 805384192          | **weights & biases of layer12**                     | `134,219,776 B`                   | **131,074 KB** |
| 872494080          | **weights & biases of layer13**                     | `134,219,776 B`                   | **131,074 KB** |
| 939603968          | **weights & biases of layer14**                     | `134,219,776 B`                   | **131,074 KB** |
| 1006713856         | **weights & biases of layer15**                     | `134,219,776 B`                   | **131,074 KB** |

**Per-layer total (1024 nodes @ N=65536)**: `(N × 2 B + 2 B) × 1024 = (131,072 B + 2 B) × 1024 = 134,219,776 B = 131,074 KB`.

**Grand Total**: `2,097,312 KB ≈ 2,049 MB ≈ 2 GB`.

---

### Generalized Layout (for N inputs, L layers, P nodes per layer)

| Data Segment                                   | Size (bits/bytes)                  | Size (KB) |
|-----------------------------------------------|------------------------------------|-----------|
| `input_data[0 … N-1]`                          | `N × 16 b = 2N B`                  | `(2N / 1024) KB` |
| Per-layer weights per node                     | `N × 16 b = 2N B`                  | `(2N / 1024) KB` |
| Per-node bias                                  | `16 b = 2 B`                       | —         |
| **Per-layer total (P nodes)**                  | `((2N + 2) B) × P`                 | `((2N + 2) × P / 1024) KB` |
| **All hidden layers total**                    | `((2N + 2) B) × P × L`             | `((2N + 2) × P × L / 1024) KB` |
| **Overall total (incl. inputs)**               | `((2N + 2) × P × L + 2N) B`        | `(((2N + 2) × P × L + 2N) / 1024) KB` |

> Equivalent bit-form: **Total** = `(((N + 1) × 16 × P × L) + (N × 16)) b`.

---

## Configuring Registers using SPI Interface
The register interface is accessible using the **SPI interface**. Device aspects two SPI frames for a valid transfer. So each frame contains 8 bits. And a full trasnfer has 16 bits.

### Configuration Steps
1. Arduino performs two SPI frame transfer with **MOSI = 0xFF** (`0b11111111`). The NPU FSM enters **CONFIG MODE**.
2. Next SPI transfer → MOSI = register address. First SPI frame is used for data direction. 0xFF -> WRITE and 0x00 -> READ. And the last frame is used as register address.
3. The following two frames (16 bits) = data for that register.  
4. To configure another register, repeat step 1 with `0xFF`.  
5. Input data, weights, and biases are written sequentially to block RAM until overflow.  

---

## Parallel MAC Architecture
- **NPU Top**
![State Diagram](images/npu-Block_Diagram.drawio.svg)
- **Node Calculation Logic**
![State Diagram](images/npu-Four_node.drawio.svg)
- **Main State Diagram**
![State Diagram](images/npu-States.drawio.svg)
---

## Memory Management Logic State Diagram
_To be completed._
