from hypothesis import settings
from hypothesis.strategies import *
from hypothesis.stateful import rule, invariant, precondition, RuleBasedStateMachine

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
