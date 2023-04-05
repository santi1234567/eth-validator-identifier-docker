# eth-validator-identifier-docker

Docker compose project for identifying the list of validators for pools in Ethereum. The file `run.sh` defines a routine in which 4 repositories are run in order to have a DB filled with this information. The repositories are:

## [wealdtech/chaind](https://github.com/wealdtech/chaind/)

Used for indexing information necessary to identify pools into a DB. Two of the tables created are used in the latter repositories:

- `t_validators` mapping index to pubkey for validators and containing the activation and deactivation epochs
- `t_eth1_deposits` containing the transactions done to the [beaconchain contract](https://etherscan.io/address/0x00000000219ab540356cBB839Cbe05303d7705Fa). Used to link the pubkey of the validator created and the depositor.

## [beaconcha.in-validator-scraper](https://github.com/santi1234567/beaconcha.in-validator-scraper)

The information of which depositor address (or validator pubkey) corresponds to a pool is not directly on-chain. [beaconcha.in](https://beaconcha.in/) is used as a primary source of this information. Validators are labeled but we have seen that the labeling process isn't 100% complete. Many validators are not labeled but using the depositor address obtained from other validators which are labeled, they can be labeled.

## [coinbase-validator-identifier](https://github.com/santi1234567/coinbase-validator-identifier)

The staking solution from Coinbase requires users to deposit the ETH so the method of linking validators with depositors doesn't work correctly. Using a pattern found in this repository [alrevuelta/eth-deposits](https://github.com/alrevuelta/eth-deposits) and an API, validators are identified.

## [eth-pools-identifier](https://github.com/santi1234567/eth-pools-identifier)

The last block of the process. This repository makes use of the information gathered on the previous steps to make a table containing the validators for each pool. It also creates a table containing the history of the amount of validators for every epoch that each pool has.

# Requirements

To run this project, a postgres DB must be created called `chain` and a user called `chain`. This requirement is imposed by chaind. Also, an eth1 and eth2 client is needed. Check [wealdtech/chaind](https://github.com/wealdtech/chaind/) for more details on this.

## Loading a backup

If a backup is to be restored in order to start the execution of the repositories from a checkpoint, it can be done for the `t_scraped_validators` and `t_depositors` tables from [beaconcha.in-validator-scraper](https://github.com/santi1234567/beaconcha.in-validator-scraper) and `t_coinbase_validators` from [coinbase-validator-identifier](https://github.com/santi1234567/coinbase-validator-identifier) with no problem. In the case of the tables created by [wealdtech/chaind](https://github.com/wealdtech/chaind/), the program doesn't allow single tables to be created beforehand (it's either all tables or none). To fix this, the following script can be run to make chaind create all tables and so you can then restore the backups before running the project:

```
docker-compose up chaind-only-tables
```

## .env

A `.env` file must be created with the variables listed in [.env.example](https://github.com/santi1234567/eth-validator-identifier-docker/blob/main/.env.example):

- `C_KEY` an API key from [covalent](https://www.covalenthq.com/docs/api/). The free plan at the moment of the creation of this repository has enough calls to have this table maintained.
- `INFURA_PROJECT_ID` project ID from [infura](https://app.infura.io/dashboard). Used to decode logs of transactions.
- `POSTGRES_ENDPOINT` postgres endpoint for the DB created following the format `postgresql://user:password@netloc:port/chain`
- `POSTGRES_ENDPOINT_CHAIND` same as `POSTGRES_ENDPOINT` but without `/chain`. Example: `postgresql://user:password@netloc:port`
- `ETH2_CLIENT_ADDRESS` address of the eth2 client used in chaind. Example: `IP:PORT`
- `ETH1_CLIENT_ADDRESS` address of the eth1 client used in chaind. Example: `IP:PORT`

# Usage

The shell script [run.sh](https://github.com/santi1234567/eth-validator-identifier-docker/blob/main/run.sh) runs the routine. If any repository fails in the execution, the routine with stop.
