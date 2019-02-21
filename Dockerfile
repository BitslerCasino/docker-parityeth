FROM bitsler/wallet-base:latest

ARG version=stable
ENV WALLET_VERSION=$version
ENV HOME /eth

ENV USER_ID 1000
ENV GROUP_ID 1000

RUN groupadd -g ${GROUP_ID} eth \
  && useradd -u ${USER_ID} -g eth -s /bin/bash -m -d /eth eth \
  && set -x \
  && apt-get update -y \
  && apt-get install -y curl gosu sudo \
  && /bin/bash -c "bash <(curl https://get.parity.io -L) -r $version" \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/eth_oneshot

VOLUME ["/eth"]

EXPOSE 8545 30303

WORKDIR /eth

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["eth_oneshot"]
