# Problem

you develop something that should work in the field, it something not trivial and does not fit into esp32 or arduino
maybe it is an item counting app or QR code detector with extra logic, or dimensioner, i.e. something that requires a pipeline of several small (yolo/resnet like) models to run relatively fast
and you want your system to run independently of internet connection, so you want to run it on the edge

what options do you have? how expensive are they? how easy is it to use conventional tools (pytorch for example)? how much power they consume, i.e. how long your system can run on a battery?

# Available options

There are several hardware categories to consider when moving beyond microcontrollers:

1.  **General Purpose SBCs (e.g., Raspberry Pi 4/5)**
    *   **Pros:** Extremely popular, massive community support, easy to deploy standard PyTorch/ONNX models (CPU inference).
    *   **Cons:** Limited inference performance on CPU. No native NPU (on older models) or GPU acceleration comparable to desktop.

2.  **Nvidia Jetson Series (Nano, Orin Nano, Orin NX)**
    *   **Pros:** The "gold standard" for ease of use with PyTorch/TensorFlow. Full CUDA support means most desktop code simply runs.
    *   **Cons:** Generally more expensive. Power consumption can be higher than dedicated NPUs.

3.  **NPU-centric Boards (e.g., Rockchip RK3588 / Orange Pi 5)**
    *   **Pros:** Incredible performance-per-dollar and performance-per-watt. The RK3588 NPU is quite powerful (6 TOPS).
    *   **Cons:** Software friction. You usually cannot run raw PyTorch; you must convert models to a proprietary format (RKNN), which can be buggy or limit operator support.

4.  **Rugged x86 miniPCs (e.g., NUC, miniPCs)**
    *   **Pros:** Incredible performance-per-dollar and performance-per-watt. The RK3588 NPU is quite powerful (6 TOPS).
    *   **Cons:** Software friction. You usually cannot run raw PyTorch; you must convert models to a proprietary format (RKNN), which can be buggy or limit operator support.
