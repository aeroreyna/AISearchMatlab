clear, clc 
GPU_R = [];
CPU_R = [];

range = 100:100:3000;

for sizeArray = range
    
tic
%r = gpuArray.rand(sizeArray,sizeArray);
%r2 = r^2;
f = @() gpuArray.rand(sizeArray,sizeArray)^4;
GPU_R = [GPU_R, gputimeit(f)];


%tic
%r3 = rand(sizeArray,sizeArray);
%r4 = r3^2;
g = @() rand(sizeArray,sizeArray)^4;
CPU_R = [CPU_R, timeit(g)];

end

plot(range, GPU_R)
hold on
plot(range, CPU_R)