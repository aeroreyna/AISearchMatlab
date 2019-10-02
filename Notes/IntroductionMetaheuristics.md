---
  bibliography: notes.bib
---

#Introduction

Metaheuristic algorithms are global optimizations techniques based on intelligent random search patterns, looking for either the maximum or minimum possible value of any given objective function.
Unlike complete algorithms, heuristics are approximate algorithms which sacrifice the guarantee of finding optimal solutions for the sake of finding "good solutions" in a significantly reduced amount of time [@DOI:10.1145/937503.937505].
This is specially necessary in problem with NP-hard complexity, as no polynomial time complete algorithm is known or exist (if $N\ne NP$), thus requiring exponential computation time in the worst-case.

The term _heuristic_ refers to "to find", and it is associated to fast and problem specific search algorithms [REF].
This algorithms, either generate solutions from scratch by adding components, to an initially empty partial solution, until a solution is complete (constructive) or start from initial complete solutions and improve them locally until a local optima is found (local search).
In the other hand, the term _meta_ makes reference to algorithms that are “beyond, or in an upper level” from the heuristics algorithms [REF].
Differently from these, metaheuristics are designed to work as black boxes over any given optimization problem with none or few modifications [REF] and to avoid premature convergence, i.e., escape from local optima [REF].
Avoiding premature convergence is achieved by either allowing worsening moves or generating new starting solutions for the local search in a more “intelligent” way than just providing random initial solutions.

Most novel and popular metaheuristics on the literature are population-based [@DOI:10.1007/s10462-018-09676-2].
These begins by generating $M$ initial random solutions as the population, with the idea to evolve them iteratively through a variety of mechanisms, usually inspired by natural phenomena.
This initial random start makes an unbiased sample of the search space with the objective of recognize potentially "good" regions in the search space.
Then, the information of the known solutions in the population and other possible data storage in memory, is used to make generate educated guesses (bias sampling), either by exploration (diversification) or exploitation (intensification).
Exploration refers to the algorithm's ability to generate solutions in unknown regions of the search space, while exploitation is the refining of previously obtained "good" solutions [@DOI:10.1145/2480741.2480752].
The skillfulness of these algorithms to find suitable solutions is mostly attributed to having the right balance between exploration and exploitation.
However, the question of how to achieve the appropriate balance, or even measure it, is still an open issue [@DOI:10.1016/j.swevo.2019.04.008].
For this reason, multiple metaheuristic methods are usually applied and compared in real-world problems to correctly select one that offers the best solutions for a given problem [REF].

The generation of educated guesses relies on probabilistic decisions made during the search trough random variables and a variety of operators.
Given the strong dependency of random values in these algorithms, it might seems that these will behave similarly as pure random search.
"The main difference to pure random search is that in metaheuristic algorithms randomness is not used blindly but in an intelligent, biased form [@Sttzle1998LocalSA]."

Given the non-deterministic nature of these algorithms, each execution travels a unique search route and returns a different final solution when the stop criteria is meet.
This stop criteria is necessary as the value of the optimal is usually unknown and there is no guarantee that, otherwise, this can be found.
This criteria also controls the algorithm time response, or computational complexity, as it limits the number of time the objective function is evaluated.

## References:

Blum, Christian, and Andrea Roli. 2003. “Metaheuristics in Combinatorial Optimization.” ACM Computing Surveys 35 (3). Association for Computing Machinery (ACM): 268–308. https://doi.org/10.1145/937503.937505.

Črepinšek, Matej, Shih-Hsi Liu, and Marjan Mernik. 2013. “Exploration and Exploitation in Evolutionary Algorithms.” ACM Computing Surveys 45 (3). Association for Computing Machinery (ACM): 1–33. https://doi.org/10.1145/2480741.2480752.

Fausto, Fernando, Adolfo Reyna-Orta, Erik Cuevas, Ángel G. Andrade, and Marco Perez-Cisneros. 2019. “From Ants to Whales: Metaheuristics for All Tastes.” Artificial Intelligence Review, January. Springer Nature. https://doi.org/10.1007/s10462-018-09676-2.

Ser, Javier Del, Eneko Osaba, Daniel Molina, Xin-She Yang, Sancho Salcedo-Sanz, David Camacho, Swagatam Das, Ponnuthurai N. Suganthan, Carlos A. Coello Coello, and Francisco Herrera. 2019. “Bio-Inspired Computation: Where We Stand and Whats Next.” Swarm and Evolutionary Computation 48 (August). Elsevier BV: 220–50. https://doi.org/10.1016/j.swevo.2019.04.008.

Stützle, Thomas G. 1998. “Local Search Algorithms for Combinatorial Problems-Analysis.”.
