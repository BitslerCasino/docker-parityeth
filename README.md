# docker-parityeth
Docker Image for OpenEthereum for use with ETH

### Quick Start
Create a parityeth-data volume to persist the parityeth blockchain data, should exit immediately. The parityeth-data container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):
```
docker volume create --name=parityeth-data
```
Create a config.toml file and put your configurations
```
mkdir -p ~/.ethdocker
nano /home/$USER/.ethdocker/config.toml
```

Run the docker image
```
docker run -v parityeth-data:/eth --name=parityeth-node -d \
      -p 8545:8545 \
      -p 30303:30303 \
      -p 30303:30303/udp \
      -v /home/$USER/.ethdocker/config.toml:/eth/.local/share/io.parity.ethereum/config.toml \
      bitsler/docker-openeth:latest
```

Check Logs
```
docker logs -f parityeth-node
```

Auto Installation
```
sudo bash -c "$(curl -L https://github.com/BitslerCasino/docker-parityeth/releases/download/v3.1.0/install.sh)"
```

Auto Updater
```
sudo bash -c "$(curl -L https://github.com/BitslerCasino/docker-parityeth/releases/download/v3.1.0/utils.sh)"
```
Then run `sudo openeth-update 3.0.0` for the latest version

