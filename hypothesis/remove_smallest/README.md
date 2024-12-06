# Remove the least element from a list

We are assigned with this programming task in Python: write a function that takes as input a non-empty list of integers, and removes from it all the occurrences of its least element. 

A tentative solution is to iterate all the elements of the list, and remove each occurrence of the least element. To this purpose, we use the Python `remove` method, which removes the first occurrence of a specified element:
```python
from typing import List

def remove_smallest(numbers: List[int]) -> None:
    smallest = min(numbers)
    
    for n in numbers:
        if n==smallest:
            numbers.remove(n)
```

## Unit tests

To check if our solution is correct, we try [some unit tests](remove_smallest0.py):
```python

def test_unit1():
    l = [1,2,3]
    remove_smallest(l)
    assert l == [2,3]

def test_unit2():
    l = [2,1,3]
    remove_smallest(l)
    assert l == [2,3]

def test_unit3():
    l = [1,2,3,1]
    remove_smallest(l)
    assert l == [2,3]

def test_unit4():
    l = [1,2,1,3]
    remove_smallest(l)
    assert l == [2,3]

def test_unit5():
    l = [1,2,1,3,1]
    remove_smallest(l)
    assert l == [2,3]
```
We see that all the tests pass:
```
pytest remove_smallest0.py 
============================= test session starts ==============================
platform linux -- Python 3.10.12, pytest-6.2.5, py-1.11.0, pluggy-1.4.0
rootdir: /home/bart/progs/informatica-unica/pbt/hypothesis/remove_smallest
plugins: hypothesis-6.112.1
collected 5 items                                                              

remove_smallest0.py .....                                                [100%]

============================== 5 passed in 0.10s ===============================
```

## Property-based tests

At this point, we could be convinced that our function is correct: this would be wrong, because of a subtle bug in the use of the `remove` function. 
To uncover the bug, we exploit property-based testing with the Hypothesis framework.

In particular, we want to check the following property. 
Consider the least element in the list *before* the function is called.
Then, *after* the function is executed, either the list is empty, or its new smallest element is less than the old one.
This property is encoded in Hypothesis as the function `test_remove_smallest`:
```python
from hypothesis import given, assume 
from hypothesis.strategies import *
from typing import List

# Property-based test
@given(lists(integers()))                    # an arbitrary list of integers
def test_remove_smallest(l):
    assume (len(l) > 0)                      # precondition: before the call, the list is non-empty
    smallest = min(l)                        # old smallest element in the list 
    remove_smallest(l)                       # invoking the function...
    assert len(l) == 0 or min(l) > smallest  # either the list is empty, or
                                             # the new least element is greater than the old one 
```
The test is structured as follows:
- the [`@given`](https://hypothesis.readthedocs.io/en/latest/details.html#hypothesis.given) decorator specifies [strategies](https://hypothesis.readthedocs.io/en/latest/data.html) that describe the range of valid inputs for the test.
In our `test_remove_smallest`, the strategy considers as input every possible list of integers. The test is expected to pass for *any* possible argument allowed by its strategies;
- the [`assume`](https://hypothesis.readthedocs.io/en/latest/details.html#hypothesis.assume) command makes the test skips (without failing) whenever the inputs do not satisfy the given condition. In our case, we skip the test whenever the input list is empty;
- the `remove_smallest` command executes the function we are going to test; 
- the `assert` command makes the test fail whenever the output list is non-empty and its new least element is *not* greater than the old one.

By running `pytest`, we now obtain an error:
```bash
pytest  remove_smallest1.py 
==================================== FAILURES ====================================
______________________________ test_remove_smallest ______________________________

    @given(lists(integers()))
>   def test_remove_smallest(l):

remove_smallest1.py:21: 
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 

l = [0]

    @given(lists(integers()))
    def test_remove_smallest(l):
        assume (len(l) > 0)
        smallest = min(l)
        remove_smallest(l)
>       assert len(l) == 0 or min(l) > smallest
E       assert (1 == 0 or 0 > 0)
E        +  where 1 = len([0])
E        +  and   0 = min([0])
E       Falsifying example: test_remove_smallest(
E           l=[0, 0],
E       )

remove_smallest1.py:25: AssertionError
============================ short test summary info =============================
FAILED remove_smallest1.py::test_remove_smallest - assert (1 == 0 or 0 > 0)
=============================== 1 failed in 0.28s ================================
```

## Reproducing the bug

This lengthy error message reveals the falsifying example: the list `[0,0]`.
Let's see what happens on this example using the interactive Python shell:
```python
ipython -i remove_smallest0.py

In [1]: l = [0,0]
In [2]: remove_smallest(l)
In [3]: l
Out[3]: [0]
```
From the output, we see that `remove_smallest` has not removed all the occurrences of the least elemement, but only the first one of them.
The bug in the function is caused by modifying the list while iterating over it using a `for` loop. Specifically:
1. When `remove(n)` is called, it removes an element from the list. This causes the list to be re-indexed immediately.
2. However, the `for` loop iterator does not account for this re-indexing: then, after an element is removed, the loop skips the next element in the list.
3. Therefore, when the smallest element is encountered and removed, the next element after it is skipped because the loop index moves to the next position, but the list has shifted to the left.

## Fixing the code

A possible [workaround](remove_smallest2.py) is to scan the list from right to left, and use the function `pop` to remove the element at a given index: 
```python
def remove_smallest(numbers: List[int]) -> None:
    smallest = min(numbers)
    for i in range(len(numbers) -1, -1, -1):
        if numbers[i]==smallest:
            numbers.pop(i) 
```
This time, the property-based tests pass:
```bash
pytest remove_smallest2.py 
============================= test session starts ==============================
platform linux -- Python 3.10.12, pytest-8.3.2, pluggy-1.5.0
rootdir: /home/bart/progs/informatica-unica/pbt/hypothesis/remove_smallest
plugins: hypothesis-6.111.1
collected 1 item                                                               
remove_smallest2.py .                                                                                                    [100%]

====================================================== 1 passed in 17.71s ======================================================
```
We can also check the function against the previous falsifying example:
```python
ipython -i remove_smallest2.py

In [1]: l = [0,0]
In [2]: remove_smallest(l)
In [3]: l
Out[3]: []
```
Another possible workaround, scanning the list from left to right, is to use the Python `pop` method within a `while` iterator.
It is important to increase the index of the loop only when not removing the least element:
```python
def remove_smallest(numbers: List[int]) -> None:
    smallest = min(numbers) 
    i = 0

    while i<len(numbers):
        if numbers[i]==smallest:
            numbers.pop(i)
        else:
            i+=1
```
Also in this case, the property-based tests pass. 
```bash
pytest remove_smallest5.py 
===================================================== test session starts ======================================================
platform linux -- Python 3.10.12, pytest-8.3.2, pluggy-1.5.0
rootdir: /home/bart/progs/informatica-unica/pbt/hypothesis/remove_smallest
plugins: hypothesis-6.111.1
collected 1 item                                                                                                              

remove_smallest5.py ...                                                                                                  [100%]
====================================================== 1 passed in 17.88s ======================================================
```
It is important to note that property-based testing does not guarantee corretnesss: it might happen that no errors are reported, but the property does not always hold.
This is because property-based testing analyzes a large (but finite) set of possible randomly generated executions. 
If the code contains some strange corner cases, then is might be unlikely that the corner case is explored.

For example, consider the following [variant](remove_smallest6.py) of our while-based workaround, where we refrain from removing the least element if it is equal to a given constant:
```python
def remove_smallest(numbers: List[int]) -> None:
    smallest = min(numbers) 
    i = 0

    while i<len(numbers):
        if numbers[i]==smallest and numbers[i]!=12345:
            numbers.pop(i)
        else:
            i+=1
```
In this case, `pytest` does not report the error. Here we are testing only 10000 examples, but even with a larger number of tests the bug is likely not to be found: 
```bash
pytest remove_smallest6.py 
===================================================== test session starts ======================================================
platform linux -- Python 3.10.12, pytest-8.3.2, pluggy-1.5.0
rootdir: /home/bart/progs/informatica-unica/pbt/hypothesis/remove_smallest
plugins: hypothesis-6.111.1
collected 1 item                                                                                                               

remove_smallest6.py .                                                                                                    [100%]

====================================================== 1 passed in 17.82s ======================================================
```
