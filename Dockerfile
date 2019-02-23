FROM alpine:edge

# install fetch packages
RUN \
	set -ex \
	&& apk add --no-cache \
		bash \
		curl \
		grep \
		jq
# set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# set workdir
WORKDIR /tmp

# copy local files
COPY *.json *.sh /tmp/ 

# get versions
RUN \
	set -ex \
	&& mkdir -p \
		/build \
	&& /bin/bash run.sh \
	&& /bin/bash test.sh

# chown results
RUN chown 1000:1000 /build/version.txt

# copy files out to /mnt
CMD ["cp", "-avr", "/build", "/mnt/"]
