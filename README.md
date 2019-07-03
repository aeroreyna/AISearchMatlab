# AISearchMatlab
AISearch Library for Matlab

This is a open source toolbox with the aim of **implement**, **test**, **learn** and **compare** metaheuristic algorithms.

The main idea of this toolbox is to accelerate the learning curve for this algorithms, by offering a clean and reusable code. We would like that this toolbox is accesible to new applications even for people with low or none knowledge of these techniques.

## Installation

  1. Clone this repo using git.

```sh
  git clone https://github.com/aeroreyna/AISearchMatlab.git
```
  2. Add the folder and subfolders to the Matlab Path.
  3. Execute one of the examples in the Example folder.

## List of Algorithms in the toolbox.

So far this is the list of metaheuristic algorithms to implement:

- [X] Genetic Algorithm (GA)
- [X] Differential Evolution (DE)
- [X] [Harmony Search (HS)](Notes/HS.md)
- [X] [Particle Swarm Optimization (PSO)](Notes/PSO.md)
- [X] Cuckoo Search (CS)
- [X] States of Matter Search (SMS)
- [X] Whale Optimization Algorithm (WOA)
- [ ] Bat Algorithm (BA)
- [ ] Simulated Annealing (SA)
- [ ] Firefly Algorithm (FA)
- [ ] Social Spider Optimization (SSO)

An extensive list of this algorithms can be found at the [AISearch GitHub page](https://aisearch.github.io/#/).

## Usage

Using these algorithms over new problems it's a easy task.
It only requires a proper fitness function and the number of dimensions of the problem.
Then one can execute the algorithm with the method start() which returns the best set of parameters founded.


```matlab
D = 2; %Dimensionality = No. Variables to Optimize
de = DE(@schwefel, D);
solution = de.start(); %Executes the algorithm optimization

function [ r, x ] = schwefel( vector )
  x = vector * 1000 - 500;
  m = size(vector, 2); %dimensions
  r= 418.9829 * m + sum(-x .* sin(sqrt(abs(x))), 2);
end

```

Other parameters of these algorithm can be modify before their execution, such as the population size `sizePopulation` and the number of iterations `maxNoIterations`, which have a default value of 30 and 100 per default respectively.

## Examples

The examples provided are can be easily modified to use any of the algorithms included or your own.
Feel free to test them out, and change them as will.
It is highly recommendable to inspect the code to understand better their functionality.
