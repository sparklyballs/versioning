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
;;
"commit")
JQ_ARG=".sha"
GIT_SUFFIX="commits/$branch"
;;
esac

# get version of each app
APP_RELEASE=$(curl --user "" -sX GET "https://api.github.com/repos/${repo}/${GIT_SUFFIX}" \
		| jq -r "${JQ_ARG}")

# apply bash substitutions based on release type to clean releases of leading v
# or shorten commits to 7 characters

case "$type" in
"release")
APP_RELEASE="${APP_RELEASE#v}"
TYPE_SUFFIX="RELEASE"
;;
"commit")
APP_RELEASE="${APP_RELEASE:0:7}"
TYPE_SUFFIX="COMMIT"
;;
esac

echo "${app^^}_${TYPE_SUFFIX}=${APP_RELEASE}"

done
