#!/bin/bash

# Define the file containing random coinbase addresses
ADDRESS_FILE="addresses.txt"

# Check if the address file exists
if [[ ! -f "$ADDRESS_FILE" ]]; then
    echo "Error: Address file $ADDRESS_FILE does not exist."
    exit 1
fi

# Read all addresses into an array (using a while loop)
addresses=()
while IFS= read -r address; do
    addresses+=("$address")
done < "$ADDRESS_FILE"

# If no addresses are loaded, exit
if [[ ${#addresses[@]} -eq 0 ]]; then
    echo "Error: No addresses found in $ADDRESS_FILE."
    exit 1
fi

# Function to get a random address from the array
get_random_address() {
    local rand_index=$((RANDOM % ${#addresses[@]}))
    echo "${addresses[$rand_index]}"
}

# Run minerd with the random address, changing every 10 minutes
while true; do
    COINBASE_ADDR=$(get_random_address)
    echo "Using coinbase address: $COINBASE_ADDR"

    # Start the miner with the random address
    ./minerd --coinbase-addr="$COINBASE_ADDR" -o 127.0.0.1:8589 -O u:p -t 4 -D --no-getwork &

    # Store the miner process ID
    MINER_PID=$!

    # Let the miner run for 10 minutes (600 seconds)
    sleep 600

    # Kill the current miner process
    kill $MINER_PID

    echo "Switching to a new address after 10 minutes..."
done
