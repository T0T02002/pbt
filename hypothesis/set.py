from hypothesis import note, assume, settings
from hypothesis.strategies import *
from hypothesis.stateful import rule, invariant, precondition, RuleBasedStateMachine

from datetime import datetime

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
				break # bug here!

	@rule(rm_elems=lists(integers(min_value=0,max_value=10), unique=True))		
	def diff(self, rm_elems):
		for item in rm_elems:
			if item in self.elems:
				self.elems.remove(item)
				
	@invariant()
	def nodup(self):
		occurrences = {}
		has_dup = False
		for item in self.elems:
			if item in occurrences:
				has_dup = True  # Duplicate found
				break
			occurrences[item] = 1
    
		assert(has_dup == False)			

	def mem(self, x):
		return (x in self.elems)

	@rule(add_elems=lists(integers(min_value=0,max_value=10), max_size=2))
	def union_mem(self, add_elems):	
		self.union(add_elems)
		for x in add_elems:
			assert(Set.mem(self,x))
		
TestSet = Set.TestCase

Set.TestCase.settings = settings(
    max_examples=500, stateful_step_count=20
)