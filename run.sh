#!/bin/bash
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
