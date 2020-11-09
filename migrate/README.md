# Docker Openethereum 3.1 DB migrator

This is used to migrate the DB of Openethereum from 2.5.13, 2.7.2, 3.0.1 to 3.1.0

### Usage

- The container expects that the directory `/eth/.local/share/io.parity.ethereum/chains/ethereum/db/906a34e69aec8c0d/overlayrecent` exists inside the container

If not using Docker, you can still use this:

Assuming `.local/...` is located on the user's home directory.
```
docker run --rm -it -v /home/user:/eth bitsler/docker-openeth-migrate:latest
```

If using custom path example `/usr/app/eth/.local/...`
```
docker run --rm -it -v /usr/app/eth:/eth bitsler/docker-openeth-migrate:latest
```

If using Docker Volumes, example `parity-data`
```
docker run --rm -it -v parity-data:/eth bitsler/docker-openeth-migrate:latest
```