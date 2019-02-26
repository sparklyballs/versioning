ARG ALPINE_VER="3.9"
FROM alpine:${ALPINE_VER}

# add local files
COPY *.sh /workdir/

# set workdir
WORKDIR /workdir

# install packages
RUN \
	set -ex \
	&& apk add --no-cache \
		bash \
		curl \
		grep \
		jq \
		shadow

# add versionging user
RUN \
	set -ex \
	&& groupmod -g 1000 users \
	&& useradd -u 1000 -U -s /bin/false versioning \
	&& usermod -G users versioning

# set permissions on run script
RUN \
	set -ex \
	&& chown -R versioning:versioning . \
	&& chmod +x run.sh
