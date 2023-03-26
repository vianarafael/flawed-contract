(* Compile both contracts to see if it works*)
let private_bank : address =
    ("KT1LRe2LBTQypEfHuNDtpAQsN9ZSJ5sEMvPH" :  address)

let helper_get_contract (_) : tez contract =
    match Tezos.get_contract_opt private_bank  with 
    Some contract -> contract
    | None -> failwith "Contract not found." 

let main (_p, _store : unit * unit): operation list * unit =

  let a = helper_get_contract()
  in 
  let operation : operation = Tezos.transaction 10tez 1mutez a
    in
  (([operation] : operation list), unit)

