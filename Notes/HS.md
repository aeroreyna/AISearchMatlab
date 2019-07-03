---
  bibliography: notes.bib
---

# Harmony Search

The musical metaheuristic algorithm.
HS is inspired by the way jazz musicians improvise using chords of previously learned melodies and mixing them with slightly adjusted or new random ones.
In this way, the population of HS works as a memory of "good" known melodies, and the operators improvise new variants of these with random changes.

### Meta-Parameters

  1. New Melody Rate `newMelodyRate = 0.9`
  2. Pitch Adjust Rate `pitchAdjustRate = 0.5`
  3. Step Adjust `stepAdjust = 0.01`

These default parameters were suggested by Kumar, Chhabra, and Kumar (2012) [1].

### Simplified Implementation <a id="SC"></a>

```matlab
for i = 1:N               %Each Solution
  newS = zeros(1, D);
  for j = 1:D             %Each Dimension
     if newMelodyRate < rand
         newS(j) = rand;  %pure random
     else
         a = randi(N);    %Random known Melody
         newS(j) = population(a,j);
         if pitchAdjustRate < rand
            % slight adjustment
            newS(j) = newS(j) + stepAdjust * randn;
        end
     end
  end
  newS = checkBounds(newS);
  tempFit = evalPopulation(newS);
  [worstF, worstI] = max(fitness); %sort complexity O(N^2)
  if tempFit < worstI
     fitness(worstI) = tempFit;
     population(worstI,:) = newS;
  end
end
```

This implementation is similar to the one presented in [Harmony Search Method: Theory and Applications](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4405318/#sec2title).

## In depth

HS is a very special metaheuristic due to the lack of Elitism in the selection of previously known melodies, considering that any of them is as good as the others.
Also, it has no attraction mechanisms, so new solutions are just a dimensional mix of the current solutions in the population (in a way similar to the Genetic Algorithm or Evolutionary Strategies) with randomness added.

## Known Disadvantages

Some HS implementations, like the [vectorized use in this toolbox](../HS.m), requires to sort the population on each iteration which can increase its computational complexity.
In the case of the [simplified code](#SC) here presented, this sort process is made by the substitution of the inferior solution in the population, which requires to compare the $N$ solutions to find the one with the maximum fitness value.
If the record of the worst current solution is kept and update when new solutions are added to the population, the complexity is similar to the sort process of sorting the population in the vectorized implementation, $O(Nlog(N))$.

Usually these algorithms are executed with low population sizes, which makes this extra complexity non-significant.
However, parallel implementations take advantages of using high population sizes.

In the other hand, this algorithm favors exploration over exploitation, which rise the probability of found solutions over the global optima neighborhood but with poor precision.

References:

  1. Kumar, Vijay, Jitender Kumar Chhabra, and Dinesh Kumar. 2012. “[Effect of Harmony Search Parameters’ Variation in Clustering.](https://doi.org/10.1016/j.protcy.2012.10.032)” Procedia Technology 6. Elsevier BV: 265–74.
