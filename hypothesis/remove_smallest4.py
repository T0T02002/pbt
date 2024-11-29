# pytest remove_smallest4.py

from hypothesis import given, assume
from hypothesis.strategies import *
from typing import List

def remove_smallest(numbers: List[int]) -> None:
    '''
    pre:  len(numbers) > 0
    post[numbers]: len(numbers) == 0 or min(numbers) > min(__old__.numbers)
    '''

    smallest = min(numbers) 
    i = 0

    while i<len(numbers):
        if numbers[i]==smallest:
            numbers.pop(i)
        i+=1

# Unit tests

def test_unit1():
    l = [1,2,3]
    remove_smallest(l)
    assert l == [2,3]

# def test_unit2():
#     l = [0,0]
#     remove_smallest(l)
#     assert l == []

@given(lists(integers()))
def test_remove_smallest(l):
    assume (len(l) > 0)
    smallest = min(l)
    remove_smallest(l)
    assert len(l) == 0 or min(l) > smallest
