#!/bin/bash

# Check if start_from_backup flag is set
source .env
if [ -z "$POSTGRES_ENDPOINT" ]; then
    echo "No database URL found. Exiting the program..."
    exit 1
fi
latest_start_block=$(psql.exe -t -c "SELECT f_eth1_block_number FROM t_eth1_deposits ORDER BY f_eth1_block_number DESC LIMIT 1;" "$POSTGRES_ENDPOINT" | sed 's/[^0-9]//g')
if [ -z "$latest_start_block" ]; then
    latest_start_block=11185311
    echo "No start block found. Starting from block $latest_start_block..."
else
    echo "Starting from block: $latest_start_block"
fi

if [ -z "$(echo $START_BLOCK)" ]; then
    echo "START_BLOCK=$latest_start_block" >>.env
else
    # If the value has changed, update the .env file
    if [[ "$START_BLOCK" != "$latest_start_block" ]]; then
        sed -i "s/^START_BLOCK=.*/START_BLOCK=$latest_start_block/" .env
    fi
fi

docker-compose.exe up chaind-wrapper > >(tee logs/chaind-wrapper.log) 2>&1
grep -i "error" -q logs/chaind-wrapper.log
if [ $? -eq 0 ]; then
    echo "Errors found on chaind wrapper. Aborting script."
    exit 1
fi

docker-compose.exe up beaconchain-validator-scraper > >(tee logs/beaconchain-validator-scraper.log) 2>&1
grep -i "error" -q logs/beaconchain-validator-scraper.log
if [ $? -eq 0 ]; then
    echo "Errors found on beaconchain validator scraper. Aborting script."
    exit 1
fi

docker-compose.exe up coinbase-validator-identifier > >(tee logs/coinbase-validator-identifier.log) 2>&1
grep -i "error" -q logs/coinbase-validator-identifier.log
if [ $? -eq 0 ]; then
    echo "Errors found on coinbase validator identifier. Aborting script."
    exit 1
fi

docker-compose.exe up eth-pools-identifier > >(tee logs/eth-pools-identifier.log) 2>&1
grep -i "error" -q logs/eth-pools-identifier.log
if [ $? -eq 0 ]; then
    echo "Errors found on eth pools identifier. Aborting script."
    exit 1
fi
