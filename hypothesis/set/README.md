# Stateful testing of a set class

We consider here a simple class implementing a set datatype. 
Our `Set` class stores a set as a list of its elements, and it implementats the following methods:
- `union(add_elems)`: adds a list of elements to the set.
- `diff(rm_elems)`: removes a list of elements from the set.
- `mem(x)`: checks if an element is a member of the set.
- `to_string()`: returns a formatted string representation of the set.

Our tests will specify **invariants** of the class, i.e. conditions that are expected to hold in every reachable state, 
and **rules** that specify conditions that must hold after specific sequences of operations.
Hypothesis will try to find sequences of method calls that result in a violation of an invariant or of a rule,
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

## Invariant: No Duplicates

The `test_nodup` invariant ensures that the `Set` implementation never contains duplicate elements:
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

## Rule: Union adds elements

The test_union_mem and test_diff_mem rules ensure the correctness of the mem method:

After union, all added elements should be members of the set.
After diff, all removed elements should no longer be members.
Example:

```python
@rule(add_elems=lists(integers(min_value=0, max_value=10), max_size=2))
def test_union_mem(self, add_elems):	
    self.union(add_elems)
    for x in add_elems:
        assert Set.mem(self, x)
```

## Rule: Diff remove elements

```python
@rule(rm_elems=lists(integers(min_value=0, max_value=10), max_size=2))
def test_diff_mem(self, rm_elems):	
    self.diff(rm_elems)
    for x in rm_elems:
        assert not Set.mem(self, x)
```
