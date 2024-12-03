from hypothesis import note, assume, settings
from hypothesis.strategies import *
from hypothesis.stateful import rule, invariant, precondition, RuleBasedStateMachine

from datetime import datetime

class Bank(RuleBasedStateMachine):
    """
    A simple Bank module to handle deposits and withdrawals.
    """

    def __init__(self):
        super(Bank, self).__init__()
        # A mapping to store balances associated with each address
        self.credits = {}
        self.frozen  = {}
        self.owner = 12345

    @rule(address=integers(min_value=1,max_value=100), amount=integers(min_value=1,max_value=100))
    def deposit(self, address, amount):
        if amount <= 0:
            raise ValueError("Deposit amount must be greater than zero.")

        # If the address is new, initialize its balance
        if address not in self.credits:
            self.credits[address] = 0
            old_bal = 0
        else:
            old_bal = self.credits[address]
        
        self.credits[address] += amount
        
        # the balance update is correct
        assert 0 <= self.credits[address] == old_bal + amount

    @rule(address=integers(min_value=1,max_value=100), amount=integers(min_value=1))
    def withdraw(self, address, amount):
        """
        Withdraws a specified amount from the address if sufficient balance exists.
        """
        #assume(address in self.credits and 0 < amount <= self.credits[address])
        
        if address not in self.credits or self.credits[address] < amount:
            return

        old_bal = self.credits[address]

        # Deduct the amount from the account balance - BUT ONLY IF NOT FROZEN
        if not address in self.frozen:
            self.credits[address] -= amount

        # the balance update is correct
        assert(0 <= self.credits[address] == old_bal - amount)

    def get_balance(self, address):
        """
        Returns the balance of the given address.
        """
        return self.credits.get(address, 0)

    @rule(address=integers(min_value=1,max_value=100))
    def freeze(self, address):
        self.frozen[address] = True

TestBank = Bank.TestCase

Bank.TestCase.settings = settings(
    max_examples=500, stateful_step_count=20
)
