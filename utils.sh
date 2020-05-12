#!/usr/bin/env bash
set -e
if [[ $EUID -ne 0 ]]; then
   echo "This script must be ran as root or sudo" 1>&2
   exit 1
fi

sudo rm -rf /usr/bin/eth-update
sudo rm -rf /usr/bin/eth-rm
sudo rm -rf /usr/bin/ethd-cli
docker stop parityeth-node || true
docker wait parityeth-node || true
docker rm parityeth-node || true
echo "Parity Eth successfully exited"

echo "Updating to OpenEthereum"

cat >/usr/bin/openeth-update <<'EOL'
#!/usr/bin/env bash
set -e
if [[ $EUID -ne 0 ]]; then
   echo "This script must be ran as root or sudo" 1>&2
   exit 1
fi

VERSION="${1:-latest}"

echo "Stopping openeth-node if it exists"
docker stop openeth-node || true
echo "Waiting openeth gracefull shutdown..."
docker wait openeth-node || true
echo "Updating openeth to $VERSION version..."
docker pull bitsler/docker-openeth:$VERSION
echo "Removing old openeth installation"
docker rm openeth-node || true
echo "Running new openeth-node container"
docker run -v parityeth-data:/eth --name=openeth-node -d \
      -p 8545:8545 \
      -p 30303:30303 \
      -p 30303:30303/udp \
      -v $HOME/.ethdocker/config.toml:/eth/.local/share/io.parity.ethereum/config.toml \
      bitsler/docker-openeth:$VERSION

echo "Openeth successfully updated and started"
echo ""
EOL

cat >/usr/bin/openeth-cli <<'EOL'
#!/usr/bin/env bash
command=$1
shift
curldata='{"method":"'$command'","params":['$@'],"id":1,"jsonrpc":"2.0"}'
curl --fail --silent --data "${curldata}" -H "Content-Type: application/json" -X POST localhost:8545
EOL

cat >/usr/bin/openeth-rm <<'EOL'
#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be ran as root or sudo" 1>&2
   exit 1
fi
echo "WARNING! This will delete ALL openeth-docker installation and files"
echo "Make sure your wallet.dat is safely backed up, there is no way to recover it!"
function uninstall() {
  sudo docker stop openeth-node
  sudo docker rm openeth-node
  sudo rm -rf ~/docker/volumes/parityeth-data ~/.ethdocker /usr/bin/openeth-cli
  sudo docker volume rm parityeth-data
  echo "Successfully removed"
  sudo rm -- "$0"
}
read -p "Continue (Y)?" choice
case "$choice" in
  y|Y ) uninstall;;
  * ) exit;;
esac
EOL

cat >/usr/bin/openeth-backup <<'EOL'
#!/usr/bin/env bash
echo "Backing up Ethereum wallet, Please wait, this might take a few minutes"
mkdir -p $HOME/ethbackup

docker run -v parityeth-data:/dbdata --name dbstore ubuntu /bin/bash
docker run --rm --volumes-from dbstore -v $HOME/ethbackup:/backup ubuntu tar czvf /backup/ethereum-keys.tar.gz /dbdata/.local/share/io.parity.ethereum/keys
docker rm dbstore
echo "Done! Backup located at $HOME/ethbackup"
EOL

chmod +x /usr/bin/openeth-update
chmod +x /usr/bin/openeth-cli
chmod +x /usr/bin/openeth-rm
chmod +x /usr/bin/openeth-backup

echo "Successfully updated!"
echo "CLI use the command openeth-cli"