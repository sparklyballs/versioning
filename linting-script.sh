#!/bin/bash
# shellcheck disable=SC2068,SC2086

# pull newest images needed for linting
docker pull sparklyballs/shellcheck:latest
docker pull ghcr.io/hadolint/hadolint:latest

# run shellcheck
SHELLCHECK_OPTIONS="--exclude=SC1008 --format=checkstyle --shell=bash"
SHELLCHECK_EXCLUDES=( \
"! -iname *.desktop" \
"! -iname dockerfile" \
"! -iname jenkinsfile" \
"! -iname license" \
"! -iname *.json" \
"! -iname *.list" \
"! -iname *.md" \
"! -iname pkgbuild*" \
"! -iname *.txt" \
"! -iname *.xml" \
)

docker run --rm=true -t \
-v ${WORKSPACE}:/test sparklyballs/shellcheck:latest \
find /test -type f ${SHELLCHECK_EXCLUDES[@]} -not -path '*/\.*' -exec shellcheck ${SHELLCHECK_OPTIONS} {} + \
> ${WORKSPACE}/shellcheck-result.xml

[[ ! -f ${WORKSPACE}/shellcheck-result.xml ]] && echo "<?xml version='1.0' encoding='UTF-8'?><checkstyle version='4.3'></checkstyle>" > ${WORKSPACE}/shellcheck-result.xml
sed -i -e 's/&#45;/-/g' -e 's# >#>#g' -e 's# />#/>#g' -e 's#/test/##g' ${WORKSPACE}/shellcheck-result.xml

# run hadolint
docker run \
	--rm=true -t \
	-v ${WORKSPACE}/Dockerfile:/Dockerfile \
	ghcr.io/hadolint/hadolint \
	hadolint --ignore DL3008 --ignore DL3013 --ignore DL3018 --ignore DL3028 \
	--format json /Dockerfile > ${WORKSPACE}/hadolint-result.xml

# exit gracefully
exit 0
