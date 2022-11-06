# Exact String Matching

## Reading

|             | Online | Offline |
| ----------- | ------ | ------- |
| Exact       | ✅     | ❓      |
| Approximate | ❓     | ❓      |

**Exact online** string matching is covered in depth in:

- [Exact Online String Matching Bibliography](https://arxiv.org/pdf/1605.05067.pdf)
- [Exact string matching algorithms](https://www-igm.univ-mlv.fr/~lecroq/string/)
- [The String Matching Algorithms Research Tool](https://www.dmi.unict.it/faro/papers/conference/faro47.pdf)
- [The Exact Online String Matching Problem:a Review of the Most Recent Results](https://www-igm.univ-mlv.fr/~lecroq/articles/acmsurv2013.pdf)

**Approximate online** string matching:

- [A guided tour to approximate string matching](https://users.dcc.uchile.cl/~gnavarro/ps/acmcs01.1.pdf)
  - https://www.connectedpapers.com/main/e001232a2876989f52a7b4ac12bd9ed550d41240/A-guided-tour-to-approximate-string-matching/graph

**TODO**: find source for other 3

## Graphs

### Dependency on the size of the alphabet and length of strings

Gonzalo Navarro & Mathieu Raffinot, 2002:

![](./exact-string-matching/1.png)

### Exact online string matching bibliography

![](exact-string-matching/graph.svg)

## Algorithms classification

1. Type
   - Exact
     - Substring
     - Paatern
   - Approximate
2. Algorithms are different by computational and space complexity
3. Online/Offline
   - Online algorithms search without pre-processing the target data, and need to traverse all data during the search
   - Offline algorithms pre-process the target data and may store it in memory or on disk to speed up query processing (see "Indexes" section below)
4. Exhaustive/Heuristic
   - Exhaustive algorithms guarantee to find all occurrences of the query in the target
   - Heuristic algorithms may not find all similar data. In heuristics, a reduction of the search time is achieved by evaluating only the statistically interesting patterns
5. Global/Local measure of similarity
   - Global - takes into account the similarity of all target data to the query
   - Local - takes into account the similarity between some part of the target and the query
6. For approximate matching
   - Type of measure (edit distance/similarity)
   - Ranking function
   - Recall and precision
7. Based on
   - characters comparison
   - automata
   - bit-parallelism
   - packed string matching
   - ...
8. Depends on size of
   - alphabet
   - text
   - query
9. Relationship to other algorithms
   - Combination of / Modification of / Refinement of / Variant of / Improvement of / Simplification of
10. Year

**Side note**: complexity comparison

- https://www.bigocheatsheet.com/
- https://www.wolframalpha.com/widgets/view.jsp?id=f1988323c9b98e870845564a17bfdf78
- https://www.sciencedirect.com/science/article/pii/S0022000074800085

## WIP

[Approximate String Matching using Backtracking over Suffix Arrays](https://www.cs.umd.edu/sites/default/files/scholarly_papers/ghodsi_1.pdf):

|             | Online                                            | Offline                              |
| ----------- | ------------------------------------------------- | ------------------------------------ |
| Exact       | KMP O(n+m)                                        | Suffix Tree O(m)                     |
| Approximate | Dynamic Programming O(n·m), Landau+Vishkin O(k·n) | Myers, Navarro+Baeza-Yates, Ukkonnen |
