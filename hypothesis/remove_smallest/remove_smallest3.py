# pytest remove_smallest1.py

from hypothesis import given, assume
from hypothesis.strategies import *
from typing import List

def remove_smallest(numbers: List[int]) -> None:
    '''
    pre:  len(numbers) > 0
    post[numbers]: len(numbers) == 0 or min(numbers) > min(__old__.numbers)
    '''

    smallest = min(numbers)
    
    for i in range(len(numbers)):
        if i<len(numbers) and numbers[i]==smallest:
            numbers.pop(i)

@given(lists(integers()))
def test_remove_smallest(l):
    assume (len(l) > 0)
    smallest = min(l)
    remove_smallest(l)
    assert len(l) == 0 or min(l) > smallest
