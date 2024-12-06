# pytest remove_smallest6.py

from hypothesis import given, assume, settings
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
        if numbers[i]==smallest and numbers[i]!=12345:
            numbers.pop(i)
        else:
            i+=1

@given(lists(integers()))
@settings(max_examples=10000)
def test_remove_smallest(l):
    assume (len(l) > 0)
    smallest = min(l)
    remove_smallest(l)
    assert len(l) == 0 or min(l) > smallest
