# Remove least element from a list

We are assigned with this programming task in Python: write a function that takes as input a non-empty list of integers, and removes from it all the occurrences of its least element. 
A tentative solution is the following:
```python
from typing import List

def remove_smallest(numbers: List[int]) -> None:
    smallest = min(numbers)
    
    for n in numbers:
        if n==smallest:
            numbers.remove(n)
```

To check if our solution is correct, we try some unit tests (in [remove_smallest0.py ](remove_smallest0.py )):
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
