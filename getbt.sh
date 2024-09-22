#!/bin/bash

# Parameters
BITCOIN_CLI="./bitcoin-cli -alpha "
NUM_BLOCKS=${1:-10}  # Default to the last 10 blocks if not specified

# Get the current block height
current_block_height=$($BITCOIN_CLI getblockchaininfo | jq -r '.blocks')

# Initialize variable to store the time of the previous block
previous_block_time=0

# Loop to get the block header time for the last n blocks
for ((i = 0; i < NUM_BLOCKS; i++)); do
    block_height=$((current_block_height - i))

    # Get the block hash for the block at block_height
    block_hash=$($BITCOIN_CLI getblockhash $block_height)

    # Get the block header for the given block hash and extract the time
    block_time=$($BITCOIN_CLI getblockheader $block_hash | jq -r '.time')

    # Convert the block timestamp to a human-readable format on macOS
    readable_time=$(date -r $block_time "+%Y-%m-%d %H:%M:%S")

    if [[ $i -gt 0 ]]; then
        # Calculate the time difference in seconds
        time_difference=$((previous_block_time - block_time))
        # Print the block height, hash, time, and time difference
        echo "Block Height: $block_height, Block Hash: $block_hash, Time: $readable_time, Time Difference: $time_difference seconds"
    else
        # Print the block height, hash, and time
        echo "Block Height: $block_height, Block Hash: $block_hash, Time: $readable_time"
    fi

    # Update previous_block_time to the current block_time for the next iteration
    previous_block_time=$block_time
done

