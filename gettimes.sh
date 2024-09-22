#!/bin/bash

# Parameters
BITCOIN_CLI="./alpha-cli -alpha "
BLOCK_COUNTS=(5 10 50 100 200)  # Block counts to calculate average time for

# Function to calculate and print average time between blocks for a given number of blocks
calculate_average_time() {
    local num_blocks=$1

    echo "Calculating average time between the last $num_blocks blocks..."

    # Get the current block height
    local current_block_height=$($BITCOIN_CLI getblockchaininfo | jq -r '.blocks')

    # Initialize variables to store times
    local previous_block_time=0
    local total_time_difference=0
    local block_count=0

    # Loop through the last num_blocks blocks
    for ((i = 0; i < num_blocks; i++)); do
        local block_height=$((current_block_height - i))

        # Get the block hash for the block at block_height
        local block_hash=$($BITCOIN_CLI getblockhash $block_height)

        # Get the block header for the given block hash and extract the time
        local block_time=$($BITCOIN_CLI getblockheader $block_hash | jq -r '.time')

        if [[ $i -gt 0 ]]; then
            # Calculate the time difference in seconds
            local time_difference=$((previous_block_time - block_time))
            total_time_difference=$((total_time_difference + time_difference))
            block_count=$((block_count + 1))
        fi

        # Update previous_block_time to the current block_time for the next iteration
        previous_block_time=$block_time
    done

    # Calculate the average time between blocks in seconds
    if [[ $block_count -gt 0 ]]; then
        local average_time=$((total_time_difference / block_count))
        echo "Average time between the last $num_blocks blocks: $average_time seconds"
    else
        echo "Not enough blocks to calculate average time for $num_blocks blocks."
    fi
    echo
}

# Loop through each block count and calculate average time
for count in "${BLOCK_COUNTS[@]}"; do
    calculate_average_time $count
done

