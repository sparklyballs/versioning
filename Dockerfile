ARG ALPINE_VER="3.9"
FROM alpine:${ALPINE_VER}

# add local files
COPY *.sh *.json /workdir/

# set workdir
WORKDIR /workdir

# install packages
RUN \
	set -ex \
	&& apk add --no-cache \
		bash \
		curl \
		grep \
		jq

# set permissions on run script
RUN \
	set -ex \
	&& chmod +x run.sh
