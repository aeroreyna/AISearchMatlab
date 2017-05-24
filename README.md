# AISearchMatlab
AISearch Library for Matlab

This is a open source toolbox to **implement**, **test**, **learn** and **compare** metaheuristic algorithms. 

The main idea of this toolbox is to accelerate the learning curve for this algorithms, by offering a clean and reusable code. We would like that this toolbox is accesible to new applications even for people with low or none knowlage of this techniques.

## Instalation 

1. Download this git. [Link](https://github.com/aeroreyna/AISearchMatlab/archive/master.zip)
2. Unzip the folder.
3. Add the folder and subfolders to the MatLab Path.
4. Execute one of the examples.
5. Enjoy the metaheuristics.

## List of Algorithms in the toolbox.

So far this is the list of metaheuristic algorithms to implement:

- [X] Genetic Algorithm (GA)
- [X] Differential Evolution (DE)
- [X] Harmony Search (HS)
- [X] Particle Swarm Optimization (PSO)
- [X] Cuckoo Search (CS)
- [X] States of Matter Search (SMS)
- [X] Whale Optimization Algorithm (WOA)
- [ ] Bat Algorithm (BA)
- [ ] Simulated Annealing (SA)
- [ ] Firefly Algorithm (FA)
- [ ] Social Spider Optimization (SSO)

An extensive list of this algorithms can be found at this blog: [TheScienceMatrix](http://thesciencematrix.com/Apps/metaheuristics/)

## Usage

To implement this algorithms over new problems it's really easy. The initialization ask you for the fitness fucntion and the number of dimensions of the problem. Then you can modify the parameters you need. (Documentation pending). Finally start the algorith with the method start().


```matlab
anyVariableName = DE(@fitnessFunction, 2);
anyVariableName.start();
anyVariableName.bestSolution
anyVariableName.bestFitness
```

## Examples

The examples provided are easily configurable to use the algorithm of your choice. Feel free to test them out, and change them as will. We highly recomend to inspect the code of them to understand better their ways.


