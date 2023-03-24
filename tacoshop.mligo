
let init_storage = Map.literal [
  (1n, { current_stock = 50n ; max_price = 50tez }) ;
  (2n, { current_stock = 20n ; max_price = 75tez }) ;
]

  type taco_supply = {
    current_stock : nat ;
    max_price     : tez
}

type taco_shop_storage = (nat, taco_supply) map

type return = operation list * taco_shop_storage

let ownerAddress : address =
  ("tz1eJXdxmwin2DXShxFi4tPVD9Cxu1hnaPz6" : address)

let buy_taco (taco_kind_index, taco_shop_storage : nat * taco_shop_storage) : return =
  // Retrieve the taco_kind from the contract's storage or fail
  let taco_kind : taco_supply =
    match Map.find_opt taco_kind_index taco_shop_storage with
      Some (kind) -> kind
    | None -> (failwith ("Unknown kind of taco.") : taco_supply)
  in

  let current_purchase_price : tez =
    taco_kind.max_price / taco_kind.current_stock in

  // We won't sell tacos if the amount is not correct
  let () =
    assert_with_error ((Tezos.get_amount ()) <> current_purchase_price)
      "Sorry, the taco you are trying to purchase has a different price" in

  // Decrease the stock by 1n, because we have just sold one
  let taco_kind = { taco_kind with current_stock = (abs (taco_kind.current_stock - 1n)) } in

  // Update the storage with the refreshed taco_kind
  let taco_shop_storage = Map.update taco_kind_index (Some taco_kind) taco_shop_storage in

  let receiver : unit contract =
    match (Tezos.get_contract_opt ownerAddress: unit contract option) with
      Some (contract) -> contract
    | None -> (failwith ("Not a contract") : unit contract)
  in

  let payoutOperation : operation = Tezos.transaction () (Tezos.get_amount ()) receiver in
  let operations : operation list = [payoutOperation] in

  operations, taco_shop_storage