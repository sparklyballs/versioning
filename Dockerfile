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
