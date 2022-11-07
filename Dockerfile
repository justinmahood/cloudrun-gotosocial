from alpine

# Download Litestream
ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.8/litestream-v0.3.8-linux-amd64-static.tar.gz /tmp/litestream.tar.gz
RUN tar -C /usr/local/bin -xzf /tmp/litestream.tar.gz


# Copy Litestream configuration file & startup script.
COPY litestream/litestream.yml /etc/litestream.yml
COPY litestream/run.sh /scripts/run.sh
RUN apk add bash

WORKDIR /gotosocial

# download GTS binary
RUN wget https://github.com/superseriousbusiness/gotosocial/releases/download/v0.5.2/gotosocial_0.5.2_linux_amd64.tar.gz \
    && tar -xzf gotosocial_0.5.2_linux_amd64.tar.gz
COPY . /gotosocial

# set GTS config
ENV REPLICA_URL="gcs://gotosocialstate"

# for local testing
#ENV GOOGLE_APPLICATION_CREDENTIALS=""

RUN mkdir -p /gotosocial/storage
RUN chmod 755 /gotosocial/gotosocial && chmod 755 /scripts/run.sh && chown -R 1000:1000 /gotosocial
EXPOSE 8080
CMD ["/scripts/run.sh"]
