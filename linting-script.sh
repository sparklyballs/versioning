#!/bin/bash
# shellcheck disable=SC2068,SC2086

# pull newest images needed for linting
docker pull sparklyballs/shellcheck:latest
docker pull sparklyballs/hadolint:latest

# set variables/array
HADOLINT_OPTIONS="--ignore DL3008 --ignore DL3013 --ignore DL3018 --ignore DL3028 --format json"
SHELLCHECK_OPTIONS="--exclude=SC1008 --format=checkstyle --shell=bash"
SHELLCHECK_EXCLUDES=( \
"! -iname *.conf" \
"! -iname *.csv" \
"! -iname *.dat" \
"! -iname *.desktop" \
"! -iname dockerfile" \
"! -iname jenkinsfile" \
"! -iname *.json" \
"! -iname license" \
"! -iname *.list" \
"! -iname *.md" \
"! -iname pkgbuild*" \
"! -iname *.py" \
"! -iname *.png" \
"! -iname *.txt" \
"! -iname *.xml" \
)

# run shellcheck
docker run \
	--rm=true -t \
	-v ${WORKSPACE}:/test sparklyballs/shellcheck:latest \
	find /test -type f ${SHELLCHECK_EXCLUDES[@]} -not -path '*/\.*' -exec shellcheck ${SHELLCHECK_OPTIONS} {} + \
	> ${WORKSPACE}/shellcheck-result.xml

[[ ! -f ${WORKSPACE}/shellcheck-result.xml ]] && touch ${WORKSPACE}/shellcheck-result.xml
sed -i -e 's/&#45;/-/g' -e 's# >#>#g' -e 's# />#/>#g' -e 's#/test/##g' ${WORKSPACE}/shellcheck-result.xml

# run hadolint
docker run \
	--rm=true -t \
	-v ${WORKSPACE}/Dockerfile:/Dockerfile \
	sparklyballs/hadolint:latest \
	hadolint ${HADOLINT_OPTIONS} /Dockerfile > ${WORKSPACE}/hadolint-result.xml

# exit gracefully
exit 0
