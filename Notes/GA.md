---
  bibliography: notes.bib
---

# Genetic Algorithm

The Genetic Algorithm (GA) was initially developed by John Henry Holland in 1960 (and further extended in 1975) with the goal to understand the phenomenon of natural adaptation, and how this mechanism could be implemented into computers systems to solve complex problems.
GA is one of the earliest metaheuristics inspired in the concepts of natural selection and evolution and is among the most successful Evolutionary Algorithms (EA) due to its conceptual simplicity and easy implementation [@DOI:10.1007/978-1-4419-1665-5_5].
This algorithm emulates the evolutionary process of a group of individuals in a restricted environment, in which the fittest individuals have higher opportunities for survival and through generations procreate even fitter offspring.

![Genetic Algorithm Flowchart. ](assets\GA.png){#fig:genetic_alg width=80%}

In GA, the solutions $x_i$ of the population are considered individuals in the environment.
These solutions are usually converted to a binary string form (this is, $x_{i,n} \in \{ 0,1\}$) which represents the genetic code (chromosomes) of each individual.
At each iteration, called generation, the chromosome population is modified by applying a set of evolutionary operators, namely: parents selection, crossover, mutation and survival selection.
@Fig:genetic_alg shows the GA operators procedure to generate M new solution at each iteration of the evolutionary process.
Two different solutions are randomly chosen (parents), usually biased to choose fitter solutions.
The pair of solutions interchange their genetic information by the crossover operator, producing two new (offspring) solutions.
New solutions have a small chance of mutating, by randomly shifting some value of the binary string.
When the new population of M solutions is generated, the fitness function is applied to these to calculate their fitness value.
Finally, the survival selection step chooses between the old and new generations to maintain a fixed number of solutions in the population, based on the analogy of limited resources.
Several strategies have been proposed for each of the GA operators, enhancing the capabilities of this algorithm to provide a more balanced search.
Form this point the chosen operators are explained with their respective math equations.

For the selection operation, the selection of M parents solutions ($P_i \mid i=1,2,\ldots,M$) is performed by a tournament of two randomly selected solutions $x_{s_{1}}$ and $x_{s_{2}}$.

$$
P_{i} =
\left\{
\begin{matrix}
  x_{s_1}, \; \text{if} \; f(x_{s_1}) > f(x_{s_2}) \\
  x_{s_2}, \; \text{otherwise}\;\;\;\;\;\;\;\;\;\;\;\;
\end{matrix}
\right.\ \mid s_1, s_2 = \text{rand}_{int}(1, M), \; s_1 \neq s_2
$${#eq:ga_tournament}

The crossover operation recombines the information of each pair of selected solutions using a binary vector $r$ that selects the recombination pattern, such as:

$$
P'_{2i + 1, n} = \left\{
\begin{matrix}
  P_{2i+1, n} \quad  \text{if} \; r_n = 1 \;\; \\
  P_{2i+2, n} \quad \text{otherwise}
\end{matrix}
\right.\ ,
\\
P'_{2i + 2, n} = \left\{
\begin{matrix}
  P_{2i+1, n} \quad \text{if} \; r_n = 0 \;\; \\
  P_{2i+2, n} \quad \text{otherwise}
\end{matrix}
\right.\ ,
\\
\forall i \in [0, 1, \ldots, \frac{M}{2} - 1], \; \forall n \in [1, \ldots, D]
$${#eq:crossover}

where $r$ is usually form by selecting a random pivot point $l$ as:

$$
r_n = \left\{
\begin{matrix}
  1 \quad \text{if} \; n < l \;\;\;\; \\
  0 \quad \text{otherwise}
\end{matrix}
\right.\, l = rand_{int}(1,D)
$${#eq:one_point}

The vector $r$ can be form by using multiple random pivot points ($l=[l_1, l_2,\ldots] \mid l_1<l_2<\ldots$) or by a random binary choice, as:

$$
r_n = rand_{int}(0,1)
$${#eq:random_pivot}

As the crossover operator is controlled by a meta-parameter $r_{Crossover}$, the recombined solutions $P_i'$ replace the selected $P_i$ with a probability of $r_{Crossover}$, as:

$$
  P_i = \left\{
  \begin{matrix}
    P_i' \quad \text{if}\; rand < r_{Crossover}\\
    P_i \quad \text{otherwise} \;\;\;\;\;\;\;\;\;\;\;\;\;\;
  \end{matrix}
  \right.\
$$

The mutation operation introduce a random change in the generated $P_i$ solutions, usually changing a single bit from 1 to 0 or vice-versa.
Mutation can occur over each dimensionality of the solutions with a probability $r_{Mutation}$ (typically as low as 0.001), as given as follows:

$$
P_i = \left\{
\begin{matrix}
  \overline{P_i} \quad \text{if} \; rand(0,1) < r_{Mutation} \\
  P_i \quad \text{otherwise} \;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\;\; \\
\end{matrix} \right.\ \text{for}\ n = 1,2,\ldots,D
$${#eq:ga_mutation}

where $\overline{P_i}$ represent the bit flip for binary strings, or a random assignation between the domain of such dimension $n$, when working with discrete values.

As shown in @Fig:genetic_alg these three operators takes place until a population of $M$ new solutions has been produced, and then, the $M$ best solutions among the original and new populations are taken for the next generation, while the rest are discarded.

In practice, both selection operators seek to maintain elitism in the population; therefore, they enforce exploitation.
These operators can be purely greedy or admit some underfit solutions to avoid losing diversity.
On the other hand, Mutation is meant to be a strictly explorative operator, which seek to prevent premature convergence to local optima.
Although Crossover is usually considered as an exploitation operator, recent works have shown that it conveys a balance between exploration and exploitation when the population is dispersed, gradually shifting to exploitation as the population converges [@DOI:10.1145/2480741.2480752].

Given the operators that compose GA, this can be categorize as follows:

  * Greedy Selection
  * Sorts the Population
  * No Attraction Based Operator
  * Easy Tuning
  * Easy Implementation

## References

Črepinšek, Matej, Shih-Hsi Liu, and Marjan Mernik. 2013. “Exploration and Exploitation in Evolutionary Algorithms.” ACM Computing Surveys 45 (3). Association for Computing Machinery (ACM): 1–33. [https://doi.org/10.1145/2480741.2480752]().

Reeves, Colin R. 2010. “Genetic Algorithms.” In Handbook of Metaheuristics, 109–39. Springer US. [https://doi.org/10.1007/978-1-4419-1665-5_5]().
