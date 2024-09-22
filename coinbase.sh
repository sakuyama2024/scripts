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

  # Get the block details using the block hash
  coinbase_txid=$(./alpha-cli getblock $block_hash | jq -r '.tx[0]')

  # If the coinbase transaction ID was extracted correctly, fetch the raw transaction details
  if [ -n "$coinbase_txid" ]; then
    # Get the details of the coinbase transaction (use 1 for verbose output)
    coinbase_address=$(./alpha-cli getrawtransaction $coinbase_txid 1 | jq -r '.vout[0].scriptPubKey.address // empty')

    # Display only the coinbase address
    if [ -n "$coinbase_address" ]; then
      echo "$coinbase_address"
    fi
  fi
done

