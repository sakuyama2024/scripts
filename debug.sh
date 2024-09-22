#!/bin/bash

# Check if the number of blocks is provided as an argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <number_of_blocks>"
  exit 1
fi

# Get the total number of blocks in the blockchain
tip=$(./alpha-cli getblockcount)
n=$1

# Loop over the last n blocks
for ((i=0; i<n; i++)); do
  # Get the block hash for the block at height (tip - i)
  block_hash=$(./alpha-cli getblockhash $((tip - i)))
  
  echo "Processing Block: $((tip - i)) with Block Hash: $block_hash"

  # Get the block details using the block hash
  block_info=$(./alpha-cli getblock $block_hash)

  # Print the raw block info for debugging
  echo "Raw Block Info: $block_info"

  echo "------------------------------------------------"
  
  # Stop after printing the first block for debugging purposes
  break
done

