# pytest remove_smallest1.py

from hypothesis import given, assume
from hypothesis.strategies import *
from typing import List

def remove_smallest(numbers: List[int]) -> None:
    '''
    pre: len(numbers) > 0
    post[numbers]: len(numbers) == 0 or min(numbers) > min(__old__.numbers)
    '''
    smallest = min(numbers)
    
    for n in numbers:
        if n==smallest:
            numbers.remove(n)

# Unit tests

def test_unit1():
    l = [1,2,3]
    remove_smallest(l)
    assert l == [2,3]

# Property-based test

@given(lists(integers()))
def test_remove_smallest(l):
    assume (len(l) > 0)
    smallest = min(l)
    remove_smallest(l)
    assert len(l) == 0 or min(l) > smallest


# crosshair check --analysis_kind=PEP316 remove_smallest6.py
# crosshair check succeeds, but property is false by counterexample [0, 0]