(* Private Bank *)
type storage = (address, tez) map
type parameter = tez
type return = operation list * storage


let main (param, store : parameter * storage) : return =
(([]: operation list), Map.add (Tezos.get_sender()) (param) store )

(* 
ligo run dry-run private_bank.mligo '0tz' '(Map.empty : (address, tez) map)'
 *)