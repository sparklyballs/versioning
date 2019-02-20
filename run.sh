#!/bin/bash

# read parameters from git json file
jq -M -r '
    .[] | .app, .repo, .branch, .type
' < git.json | \
while read -r app; read -r repo; read -r branch; read -r type ;do

# set url elements and jq argument based on release type
case "$type" in
"release")
JQ_ARG=".tag_name"
GIT_SUFFIX="releases/latest"
TYPE_SUFFIX="RELEASE"
;;
"commit")
JQ_ARG=".sha"
GIT_SUFFIX="commits/$branch"
TYPE_SUFFIX="COMMIT"
;;
esac

# get version of each app
APP_RELEASE=$(curl --user "${SECRETUSER}:${SECRETPASS}" -sX GET "https://api.github.com/repos/${repo}/${GIT_SUFFIX}" \
		| jq -r "${JQ_ARG}")

# strip commit type version to 7 characters or strip leading v, if present on release type
if [ "${#APP_RELEASE}" = 40 ] ; then
APP_RELEASE="${APP_RELEASE:0:7}"
else APP_RELEASE="${APP_RELEASE#v}"
fi

echo "${app^^}_${TYPE_SUFFIX}=${APP_RELEASE}"

done
