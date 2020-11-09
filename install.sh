#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be ran as root or sudo" 1>&2
   exit 1
fi

echo "Installing OpenEthereum Docker"

mkdir -p $HOME/.ethdocker

echo "Initial OpenEthereum Configuration"

echo "Creating OpenEthereum configuration at $HOME/.ethdocker/config.toml"

cat >$HOME/.ethdocker/config.toml <<EOL
[secretstore]
# You won't be able to encrypt and decrypt secrets.
disable = true

[rpc]
interface = "all"
apis = ["web3", "eth", "net", "parity", "traces", "personal", "parity_accounts"]

[ipc]
# You won't be able to use IPC to interact with Parity.
disable = true

[websockets]
# UI won't work and WebSockets server will be not available.
disable = true

[footprint]
# Compute and Store tracing data. (Enables trace_* APIs).
tracing = "on"
# Increase performance on HDD.
db_compaction = "hdd"
# Prune old state data. Maintains journal overlay - fast but extra 50MB of memory used.
pruning = "fast"
# Enables Fat DB
fat_db = "on"
# Number of threads will vary depending on the workload. Not guaranteed to be faster.
scale_verifiers = true
# Initial number of verifier threads
num_verifiers = 6
# If defined will never use more then 4096MB for all caches. (Overrides other cache settings).
cache_size = 4096

[misc]
log_file = "/eth/.local/share/io.parity.ethereum/parity.log"
logging = "own_tx=trace"

[parity]
mode = "active"
base_path = "/eth/.local/share/io.parity.ethereum"
no_persistent_tx_queue = true

[network]
min_peers = 50
max_peers = 100
EOL

echo Installing OpenEthereum Container

docker volume create --name=parityeth-data
docker run -v parityeth-data:/eth --name=parityeth-node -d \
      -p 8545:8545 \
      -p 30303:30303 \
      -p 30303:30303/udp \
      -v $HOME/.ethdocker/config.toml:/eth/.local/share/io.parity.ethereum/config.toml \
      bitsler/docker-openeth:latest


echo
echo "==========================="
echo "==========================="
echo "Installation Complete"
echo "RUN the utils.sh file to install openeth-cli utilities"
echo "Your configuration file is at $HOME/.ethdocker/config.toml"
echo "If you wish to change it, make sure to restart parityeth-node"
echo "IMPORTANT: To start parityeth-node manually simply start the container by docker start parityeth-node"
echo "IMPORTANT: To stop parityeth-node simply stop the container by docker stop parityeth-node"
