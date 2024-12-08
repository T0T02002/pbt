from hypothesis import settings
from hypothesis.strategies import *
from hypothesis.stateful import rule, invariant, precondition, RuleBasedStateMachine

import pytest

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
		return "{ " + ", ".join(map(str, self.elems)) + " }"

	@rule(rm_elems=lists(integers(min_value=0,max_value=10), max_size=2))
	def test_diff_mem(self, rm_elems):	
		self.diff(rm_elems)
		for x in rm_elems:
			assert(not Set.mem(self,x))
			
TestSet = Set.TestCase

TestSet.settings = settings(
    max_examples=500, stateful_step_count=20
)
