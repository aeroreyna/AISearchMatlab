---
title: Parallel Implementation of AISearch Algorithms
author: Adolfo Reyna
bibliography: notes.bib
---


# Parallel Implementation of AISearch Algorithms

Recent versions of Matlab have a high level API to use GPU computation intuitively, which release the user from the complexity implicit on the creation of Nvidia Cuda Kernels and managing indexes and memory on GPU cores.
It allows the allocation of data on the GPU memory by using the [gupArray object](https://www.mathworks.com/help/parallel-computing/gpuarray.html).
Then, when mathematical operations are performed over these variables or one of the [Matlab functions compatible with GPU arrays](https://www.mathworks.com/help/parallel-computing/run-matlab-functions-on-a-gpu.html), the computational processing will be perform on the GPU.

A simple example of these capabilities can been tested using the [parallel comparison example](../Examples/ParallelComparison.m):

```matlab
%Partial Code
for sizeArray = 100:100:2000
  tic
  r = gpuArray.rand(sizeArray,sizeArray);
  r2 = r^2;
  GPU_R = [GPU_R, toc];

  tic
  r3 = rand(sizeArray,sizeArray);
  r4 = r3^2;
  CPU_R = [CPU_R, toc];
end
```

![](assets/dcc3f398.png)

This code generate random square matrixes and evaluate the square of these, which results on a matrix multiplication, performed both in the GPU and CPU.
The chart shows the execution time as the matrix increases in size.

There is two inefficient operations that should be avoided as possible when using GPU: 1) transferring memory from CPU to GPU [^1]; 2) non-vector operations (serial processing arrays).


[^1]: [Measuring GPU Performance, Mathworks](https://www.mathworks.com/help/parallel-computing/examples/measuring-gpu-performance.html).
