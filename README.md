# Property-based testing

Property-based testing is a testing approach that focuses on verifying general properties of code, rather than specific examples. 

Instead of writing individual test cases with predefined inputs and expected outputs (as in [unit testing](https://en.wikipedia.org/wiki/Unit_testing)), a property-based test randomly generates input data adhering to given constraints, and checks that your code respects the required properties in all the executions driven by the randomly generated inputs. This approach helps uncover hidden bugs by exposing unexpected behaviors that unit tests might miss. 

We show in this repository some examples of property-based testing in Hypothesis (Python) and QCheck (OCaml).

## Examples in Python/Hypothesis

- [Remove least element from a list](hypothesis/remove_smallest/)
- [Stateful testing of a set class](hypothesis/set/)

## Examples in OCaml/qcheck

- [Take / drop elements from a list](qcheck/take_drop.ml)
- [Lists are functors](qcheck/map.ml)
- [All elements of a list satisfy a predicate](qcheck/forall.ml)
- [Insertion sort](qcheck/insertion_sort.ml)
- [Merge sort](qcheck/merge_sort.ml)

## References

### Property-based testing
- George Fink, Matt Bishop: [Property-based testing: a new approach to testing for assurance](https://dl.acm.org/doi/abs/10.1145/263244.263267), 1997
- D. R. MacIver: [In praise of property-based testing](https://increment.com/testing/in-praise-of-property-based-testing/), 2019
- J. Hughes: [How to Specify It!: A Guide to Writing Properties of Pure Functions](https://research.chalmers.se/publication/517894/file/517894_Fulltext.pdf), 2020 ([video](https://youtu.be/G0NUOst-53U?si=AY6THBq_DYjDRYu1))
- [Choosing properties for property-based testing](https://fsharpforfunandprofit.com/posts/property-based-testing-2/)


### Hypothesis
- [Python Hypothesis library](https://hypothesis.readthedocs.io/en/latest/)
  - [Strategies](https://hypothesis.readthedocs.io/en/latest/data.html)
  - [Stateful testing](https://hypothesis.readthedocs.io/en/latest/stateful.html)
- [Solving the Water Jug Problem from Die Hard 3 with TLA+ and Hypothesis](https://hypothesis.works/articles/how-not-to-die-hard-with-hypothesis/)
- [Rule Based Stateful Testing](https://hypothesis.works/articles/rule-based-stateful-testing/)

### Qcheck
- [Qcheck github](https://github.com/c-cube/qcheck)
- Michael Ryan Clarkson: [Randomized Testing and QCheck](https://youtu.be/62SYeSlSCNM?si=Z1c6FlP8B8bUvgPC)
  
### Other languages
- [QuickCheck: Automatic testing of Haskell programs](https://hackage.haskell.org/package/QuickCheck)
- [QuickChick: Property-Based Testing in Coq](https://softwarefoundations.cis.upenn.edu/qc-current/index.html)
