import smartpy as sp

class Token(sp.Contract):
    def __init__(self, token_sale_address, initial_balance):
        self.init(balances = {sp.sender: initial_balance}, token_sale_address=token_sale_address)

    @sp.entry_point
    def transfer(self, params):
        to_address = params.to_address
        amount = params.amount
        sp.verify(self.data.balances[sp.sender] >= amount, message="Insufficient balance")
        self.data.balances[sp.sender] -= amount
        if to_address in self.data.balances:
            self.data.balances[to_address] += amount
        else:
            self.data.balances[to_address] = amount

    @sp.view(sp.TAddress)
    def balance_of(self, owner):
        return self.data.balances.get(owner, 0)

    @sp.view(sp.TNat)
    def total_supply(self):
        return sum(self.data.balances.values())

if "templates" not in __name__:
    @sp.add_test(name = "Token Contract")
    def test():
        scenario = sp.test_scenario()
        token_sale = TokenSale(token_price=sp.tez(100), total_supply=1000)
        token = Token(token_sale_address=token_sale.address, initial_balance=100)
        scenario += token_sale
        scenario += token
        scenario += token_sale.buy_tokens(amount=1, sender=sp.address("tz1abc"))
        scenario += token.transfer(sp.record(to_address=sp.address("tz1def"), amount=1)).run(sender=sp.address("tz1abc"))
