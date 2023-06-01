#!/bin/bash

# clear preexisting variables not set by job
unset MOUNT_OPTIONS TEST_AREA SHELLCHECK_OPTIONS

# clear preexising checkstyle files
[[ -f /home/sparklyballs/Documents/delugetest/shellcheck-result.xml ]] && rm /home/sparklyballs/Documents/delugetest/shellcheck-result.xml

# check for common locations and exit if not found
if [[ ! -d /home/sparklyballs/Documents/delugetest/root/etc/cont-init.d  && ! -d /home/sparklyballs/Documents/delugetest/root/etc/services.d && \
! -d /home/sparklyballs/Documents/delugetest/init  && ! -d /home/sparklyballs/Documents/delugetest/services ]]; then
echo "no common files found, linting not required" exit 0
fi

if [[ ! -d /home/sparklyballs/Documents/delugetest/root/etc/cont-init.d  && ! -d /home/sparklyballs/Documents/delugetest/root/etc/services.d ]] && \
[[ -d /home/sparklyballs/Documents/delugetest/init && -d /home/sparklyballs/Documents/delugetest/services ]]; then
SHELLCHECK_OPTIONS="--format=checkstyle --shell=bash"
MOUNT_OPTIONS="-v /home/sparklyballs/Documents/delugetest/init:/init -v /home/sparklyballs/Documents/delugetest/services:/services"
TEST_AREA="init services"

elif [[ ! -d /home/sparklyballs/Documents/delugetest/root/etc/cont-init.d  && ! -d /home/sparklyballs/Documents/delugetest/root/etc/services.d ]] && \
[[ ! -d /home/sparklyballs/Documents/delugetest/init && -d /home/sparklyballs/Documents/delugetest/services ]]; then
SHELLCHECK_OPTIONS="--format=checkstyle --shell=bash"
MOUNT_OPTIONS="-v /home/sparklyballs/Documents/delugetest/services:/services"
TEST_AREA="services"

elif [[ ! -d /home/sparklyballs/Documents/delugetest/root/etc/cont-init.d  && ! -d /home/sparklyballs/Documents/delugetest/root/etc/services.d ]] && \
[[ -d /home/sparklyballs/Documents/delugetest/init && ! -d /home/sparklyballs/Documents/delugetest/services ]]; then
SHELLCHECK_OPTIONS="--format=checkstyle --shell=bash"
MOUNT_OPTIONS="-v /home/sparklyballs/Documents/delugetest/init:/init"
TEST_AREA="init"

elif [[ -d /home/sparklyballs/Documents/delugetest/root/etc/cont-init.d  && -d /home/sparklyballs/Documents/delugetest/root/etc/services.d ]]; then
SHELLCHECK_OPTIONS="--exclude=SC1008 --format=checkstyle --shell=bash"
MOUNT_OPTIONS="-v /home/sparklyballs/Documents/delugetest/root:/root"
TEST_AREA="root/etc/services.d root/etc/cont-init.d"

elif [[ ! -d /home/sparklyballs/Documents/delugetest/root/etc/cont-init.d  && -d /home/sparklyballs/Documents/delugetest/root/etc/services.d ]]; then
SHELLCHECK_OPTIONS="--exclude=SC1008 --format=checkstyle --shell=bash"
MOUNT_OPTIONS="-v /home/sparklyballs/Documents/delugetest/root:/root"
TEST_AREA="root/etc/services.d"

elif [[ -d /home/sparklyballs/Documents/delugetest/root/etc/cont-init.d  && ! -d /home/sparklyballs/Documents/delugetest/root/etc/services.d ]]; then
SHELLCHECK_OPTIONS="--exclude=SC1008 --format=checkstyle --shell=bash"
MOUNT_OPTIONS="-v /home/sparklyballs/Documents/delugetest/root:/root"
TEST_AREA="root/etc/cont-init.d"
fi

# run shellcheck
if [[ -d /home/sparklyballs/Documents/delugetest/root/etc/cont-init.d || -d /home/sparklyballs/Documents/delugetest/root/etc/services.d || \
-d /home/sparklyballs/Documents/delugetest/init  || -d /home/sparklyballs/Documents/delugetest/services ]];then

docker pull sparklyballs/shellcheck

docker run \
	--rm=true -t \
	${MOUNT_OPTIONS} \
	sparklyballs/shellcheck \
	find ${TEST_AREA} -type f -exec shellcheck ${SHELLCHECK_OPTIONS} {} + \
	> /home/sparklyballs/Documents/shellcheck-result.xml

fi

[[ ! -f /home/sparklyballs/Documents/shellcheck-result.xml ]] && echo "<?xml version='1.0' encoding='UTF-8'?><checkstyle version='4.3'></checkstyle>" > /home/sparklyballs/Documents/shellcheck-result.xml
sed -i 's/&#45;/-/g' /home/sparklyballs/Documents/shellcheck-result.xml

# exit out gracefully without hadolint on armXX platforms
if [[ "${NODE_LABELS}"  == *"ARM"* ]]; then
exit 0
else
:
fi

docker pull ghcr.io/hadolint/hadolint

docker run \
	--rm=true -t \
	-v /home/sparklyballs/Documents/delugetest/Dockerfile:/Dockerfile \
	ghcr.io/hadolint/hadolint \
	hadolint --ignore DL3008 --ignore DL3013 --ignore DL3018 --ignore DL3028 \
	--format json /Dockerfile > /home/sparklyballs/Documents/hadolint-result.xml

# exit gracefully
exit 0
