FROM alpine:3.7
RUN apk add --no-cache --virtual=build-dependencies \
	g++ \
	make \
	cmake \
	openssl-dev \
	libmpdclient-dev \
	curl \
	tar && \
apk add --no-cache \
	libmpdclient \
	openssl && \
mkdir -p /tmp/source/ympd && \
curl -Sl "https://codeload.github.com/notandy/ympd/tar.gz/refs/tags/v1.3.0" | tar xz -C \
	/tmp/source/ympd  --strip-components=1 && \
cd /tmp/source/ympd && mkdir build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr && make && make install && \
apk del --purge build-dependencies && \
cd /tmp && rm -rf /tmp/*

ENV MPD_SERVER=localhost
ENV MPD_PORT=6600

EXPOSE 8080
CMD /usr/bin/ympd -h $MPD_SERVER -p $MPD_PORT -w 8080
