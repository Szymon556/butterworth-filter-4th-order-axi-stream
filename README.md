
### FPGA implementation

The filter was successfully implemented and synthesized on a Xilinx FPGA device.
The design utilizes dedicated DSP48E1 slices for multiply–accumulate operations within the biquad sections, ensuring efficient resource usage and high-performance signal processing.

The AXI4-Stream based architecture allows seamless integration into FPGA-based DSP pipelines and supports high-throughput streaming data processing.
### Design focus
- IIR Butterworth filter design
- Cascade of second-order sections (biquads)
- AXI4-Stream based dataflow
- FPGA implementation using DSP48E1 slices
- MATLAB reference model and verification
