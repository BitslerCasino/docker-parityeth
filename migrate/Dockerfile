FROM rust:buster

ENV HOME /eth
ENV USER_ID 1000
ENV GROUP_ID 1000

RUN groupadd -g ${GROUP_ID} eth \
  && useradd -u ${USER_ID} -g eth -s /bin/bash -m -d /eth eth \
  && set -x \
  && apt-get update -y \
  && apt-get install -y sudo unzip libc6 llvm clang-6.0 \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./bin/eth_migratedb /usr/local/bin/eth_migratedb
RUN chmod +x /usr/local/bin/eth_migratedb
RUN mkdir /db-upgrade
VOLUME ["/eth"]

WORKDIR /eth

RUN wget https://github.com/dev-nodes/3.1-db-upgrade-tool/archive/0.1.0-rc2.zip && \
 unzip 0.1.0-rc2.zip -d /db-upgrade && \
 rm -rf 0.1.0-rc2.zip && cd /db-upgrade/3.1-db-upgrade-tool-0.1.0-rc2/

WORKDIR /db-upgrade/3.1-db-upgrade-tool-0.1.0-rc2/

CMD ["eth_migratedb"]


