#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be ran as root or sudo" 1>&2
   exit 1
fi

echo "Stopping parityeth-node"
docker stop parityeth-node || true
docker wait parityeth-node || true

echo "Updating Config..."
mv $HOME/.ethdocker/config.toml $HOME/.ethdocker/config.toml.3.1.bak

cat >$HOME/.ethdocker/config.toml <<EOL
[parity]
base_path = "/eth/.local/share/io.parity.ethereum"
no_persistent_txqueue = true
mode = "active"

[rpc]
interface = "all"
cors = ["*"]
apis = ["web3", "eth", "net", "parity", "traces", "personal", "parity_accounts"]

[websockets]
disable = true

[ipc]
disable = true

[secretstore]
disable = true

[footprint]
tracing = "on"
cache_size = 4096

[misc]
logging = "own_tx=trace"
log_file = "/eth/.local/share/io.parity.ethereum/parity.log"
color = false
EOL

echo "Updating Openethereum DB to 3.1, this might take awhile."
echo "Type I AGREE if prompted"
sleep 3
docker run --rm -it -v parityeth-data:/eth bitsler/docker-openeth-migrate:latest
echo "DB updated!"
openeth-update 3.1.0