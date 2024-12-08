# Stateful testing of a set class

We consider here a simple class implementing a `Set` datatype. 
Our class stores the set as a list of its elements, and features the following methods:
- `union(add_elems)`: adds a list of elements to the set.
- `diff(rm_elems)`: removes a list of elements from the set.
- `mem(x)`: checks if an element is a member of the set.
- `to_string()`: returns a formatted string representation of the set.

Our property-based tests will specify:
- **invariants**, which specify conditions that are expected to hold in every reachable state, and
- **rules**, which specify conditions that must hold after specific sequences of operations.

Hypothesis will try to find *sequences* of method calls that result in a violation of a condition within invariants and rules,
a technique called [stateful testing](https://hypothesis.readthedocs.io/en/latest/stateful.html).

Here is our class implementation:
```python
class Set(RuleBasedStateMachine):
    def __init__(self):
        super(Set, self).__init__()
	self.elems = []

    @rule(add_elems=lists(integers(min_value=0,max_value=20), max_size=5))
    def union(self, add_elems):
        for item in add_elems:
	    if not item in self.elems:
	        self.elems.append(item)
            else:
		break # bug!

    @rule(rm_elems=lists(integers(min_value=0,max_value=10), unique=True))		
    def diff(self, rm_elems):
        for item in rm_elems:
	    if item in self.elems:
	        self.elems.remove(item) # bug, but not dangerous here

    def mem(self, x):
        return (x in self.elems)
				
    def to_string(self):
        formatted_set = "{ " + ", ".join(map(str, self.elems)) + " }"
	return formatted_set
```
This implementation hides two bugs:
- `union` bug: if a duplicate is encountered while adding elements, the loop breaks prematurely. This prevents the other elements of the list to be added to the set. 
- `diff` bug: as observed in the [remove_smallest](../remove_smallest) example, removing list elements within an iterator is problematic. However, in this specific class this is not an issue, since the list that stores the set elements does not contain duplicates.

## Invariant: no duplicates

The [`test_nodup`](set_nodop.py) invariant ensures that the `Set` implementation never contains duplicate elements:
```python
@invariant()
def test_nodup(self):
    occurrences = {}
    has_dup = False
    for item in self.elems:
        if item in occurrences:
            has_dup = True
            break
        occurrences[item] = 1
    assert has_dup == False
```
Hypothesis finds that this invariant is always respected:
```python
pytest set_nodup.py 
============================== test session starts ===============================
platform linux -- Python 3.10.12, pytest-8.3.2, pluggy-1.5.0
rootdir: /home/bart/progs/informatica-unica/pbt/hypothesis/set
plugins: hypothesis-6.122.1
collected 1 item                                                                 

set_nodup.py .                                                             [100%]
=============================== 1 passed in 8.06s ================================
```

## Rule: union adds elements

The [`test_union_mem`](set_union_mem.py) rule tests the `union` method.
Specifically, it checks that after union, all elements in the list `add_elems` are members of the set.
To reduce the search space of the rule, we constrain the input list `add_elems` to have maximum size 2,
and its elements to be included in the range [0,10]:
```python
@rule(add_elems=lists(integers(min_value=0, max_value=10), max_size=2))
def test_union_mem(self, add_elems):	
    self.union(add_elems)
    for x in add_elems:
        assert Set.mem(self, x)
```
Hypothesis manages to spot the bug:
```python
pytest set_union_mem.py 
============================== test session starts ===============================
platform linux -- Python 3.10.12, pytest-8.3.2, pluggy-1.5.0
rootdir: /home/bart/progs/informatica-unica/pbt/hypothesis/set
plugins: hypothesis-6.122.1
collected 1 item                                                                 

set_union_mem.py F                                                         [100%]

==================================== FAILURES ====================================
________________________________ TestSet.runTest _________________________________

self = <hypothesis.stateful.Set.TestCase testMethod=runTest>

    def runTest(self):
>       run_state_machine_as_test(cls, settings=self.settings)

/home/bart/.local/lib/python3.10/site-packages/hypothesis/stateful.py:437: 
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
/home/bart/.local/lib/python3.10/site-packages/hypothesis/stateful.py:241: in run_state_machine_as_test
    run_state_machine(state_machine_factory)
/home/bart/.local/lib/python3.10/site-packages/hypothesis/stateful.py:108: in run_state_machine
    @given(st.data())
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 

self = Set({}), add_elems = [0, 1]

    @rule(add_elems=lists(integers(min_value=0,max_value=10), max_size=2))
    def test_union_mem(self, add_elems):
    	self.union(add_elems)
    	for x in add_elems:
>   		assert(Set.mem(self,x))
E     assert False
E      +  where False = <function Set.mem at 0x7843123fa8c0>(Set({}), 1)
E      +    where <function Set.mem at 0x7843123fa8c0> = Set.mem
E     Falsifying example:
E     state = Set()
E     state.test_union_mem(add_elems=[0])
E     state.test_union_mem(add_elems=[0, 1])
E     state.teardown()

set_union_mem.py:36: AssertionError
============================ short test summary info =============================
FAILED set_union_mem.py::TestSet::runTest - assert False
=============================== 1 failed in 4.48s ================================
```
The output shows a counterexample where the `assert` within the rule fails, given by the following sequence of method calls:
```python
state.test_union_mem(add_elems=[0])
state.test_union_mem(add_elems=[0, 1])
```
We can turn this into a concrete executable counterexample:
```python
ipython -i set.py 

In [1]: s = Set()
In [2]: s.to_string()
Out[2]: '{  }'

In [3]: s.union([0])
In [4]: s.to_string()
Out[4]: '{ 0 }'

In [5]: s.union([0,1])
In [6]: s.to_string()
Out[6]: '{ 0 }'
```

## Rule: diff removes elements

The [`test_diff_mem`](set_diff_mem.py) rule tests the `diff` method.
Specifically, it checks that after difference, all elements in the list `rm_elems` are *not* members of the set.
```python
@rule(rm_elems=lists(integers(min_value=0, max_value=10), max_size=2))
def test_diff_mem(self, rm_elems):	
    self.diff(rm_elems)
    for x in rm_elems:
        assert not Set.mem(self, x)
```
Hypothesis now finds that the test always passes:
```python
pytest set_diff_mem.py 
============================== test session starts ===============================
platform linux -- Python 3.10.12, pytest-8.3.2, pluggy-1.5.0
rootdir: /home/bart/progs/informatica-unica/pbt/hypothesis/set
plugins: hypothesis-6.122.1
collected 1 item                                                                 

set_diff_mem.py .                                                          [100%]
=============================== 1 passed in 7.38s ================================
```
