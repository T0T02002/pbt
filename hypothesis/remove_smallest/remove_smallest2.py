# pytest remove_smallest2.py

from hypothesis import given, assume, settings
from hypothesis.strategies import *
from typing import List

def remove_smallest(numbers: List[int]) -> None:
    '''
    pre:  len(numbers) > 0
    post[numbers]: len(numbers) == 0 or min(numbers) > min(__old__.numbers)
    '''

    smallest = min(numbers)

    for i in range(len(numbers) -1, -1, -1):
        if numbers[i]==smallest:
            numbers.pop(i) 

# Unit tests

def test_unit1():
    l = [1,2,3]
    remove_smallest(l)
    assert l == [2,3]

# def test_unit2():
#     l = [12345,12346]
#     remove_smallest(l)
#     assert l == [12345]

# Property-based test

@given(lists(integers()))
@settings(max_examples=10000)
def test_remove_smallest(l):
    assume (len(l) > 0)
    smallest = min(l)
    remove_smallest(l)
    assert len(l) == 0 or min(l) > smallest
