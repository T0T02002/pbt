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
