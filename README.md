# docker-parityeth
Docker Image for Parity for use with ETH and/or ETC

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
      bitsler/docker-parityeth:latest
```

Check Logs
```
docker logs -f parityeth-node
```

Auto Installation
```
sudo bash -c "$(curl -L https://git.io/fxIu6)"
```