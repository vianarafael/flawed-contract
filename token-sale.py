import smartpy as sp

class TokenSale(sp.Contract):
    def __init__(self, token_price, total_supply):
        self.init(token_price=token_price, total_supply=total_supply, balance=sp.tez(0), tokens_sold=0, test=sp.tez(0))

    @sp.entry_point
    def buy_tokens(self, amount):
        sp.verify(self.data.total_supply - self.data.tokens_sold >= amount, message="Not enough tokens remaining for sale")
        cost = sp.mul(self.data.token_price , abs(amount))
        self.data.test = cost
        # sp.verify(sp.amount >= cost, message="Not enough tez sent")
        self.data.balance += sp.amount
        self.data.tokens_sold += amount
        # sp.transfer(amount, sp.sender)

if "templates" not in __name__:
    @sp.add_test(name = "Token Sale Contract")
    def test():
        scenario = sp.test_scenario()
        alice = sp.test_account("Alice")
        token_sale = TokenSale(token_price=sp.tez(5), total_supply=10)
        scenario += token_sale
        # scenario += token_sale.buy_tokens(amount=2, sender=sp.address("tz1abc"))
        scenario += token_sale.buy_tokens(sp.int(2), sp.tez(10)).run(sender=alice.address)
