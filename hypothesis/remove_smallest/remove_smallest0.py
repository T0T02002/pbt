# pytest remove_smallest0.py

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
	
