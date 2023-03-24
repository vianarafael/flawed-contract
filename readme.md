-  Deployed Contract ``


## Dependencies
- You need octez-client installed (& ligo compiler if you are going to compile the Cameligo file)

## Compile
1. The contract

`ligo compile contract <contract>.mligo --entry-point <entry_point> > <file_name>.tz`

2. The storage

`ligo compile storage tacoshop.mligo "$(cat init_storage.mligo)" --entry-point buy_taco > init_storage.tz`
## Originate contract
1. Add your user to the knwown user's list
```bash
octez-client import secret key <user_alias> unencrypted:<private_key>
```
- you can check the aliases & addresses with the following command:
```bash
octez-client list known contracts
```

2. Set the Node (usually either Ghostnet for test or Mainet for production)
```bash
octez-client --endpoint https://ghostnet.tezos.marigold.dev/ config update
```
3. Deploy it
```bash
octez-client originate contract <contract_alias> transferring <amount> from <sender> running <michelson_contract> --init <initial_value> --burn-cap 0.4
```
e.g.
 octez-client originate contract tacoshop  transferring 1 from me running tacoshop.tz --init "{ Elt 1 (Pair 50 50000000) ; Elt 2 (Pair 20 75000000) }" --burn-cap 0.2