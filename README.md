# Property-based testing

## Examples in Python/Hypothesis

- Remove least element from a list: [1](hypothesis/remove_smallest1.py), [2](hypothesis/remove_smallest2.py), [3](hypothesis/remove_smallest3.py), [4](hypothesis/remove_smallest4.py), [5](hypothesis/remove_smallest5.py), [6](hypothesis/remove_smallest6.py)

## Examples in OCaml/qcheck

- [Take / drop elements from a list](qcheck/take_drop.ml)
- [Mapping on a list](qcheck/map.ml)
- [All elements of a list satisfy a predicate](qcheck/forall.ml)
- [Insertion sort](qcheck/insertion_sort.ml)
- [Merge sort](qcheck/merge_sort.ml)

## References

### Property-based testing
- George Fink, Matt Bishop: [Property-based testing: a new approach to testing for assurance](https://dl.acm.org/doi/abs/10.1145/263244.263267), 1997
- D. R. MacIver: [In praise of property-based testing](https://increment.com/testing/in-praise-of-property-based-testing/), 2019
- J. Hughes: [How to Specify It!: A Guide to Writing Properties of Pure Functions](https://research.chalmers.se/publication/517894/file/517894_Fulltext.pdf), 2020 ([video](https://youtu.be/G0NUOst-53U?si=AY6THBq_DYjDRYu1))

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
