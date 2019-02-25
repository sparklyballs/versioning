#!/bin/bash

# read parameters from git json file
jq -M -r '
    .[] | .app, .repo, .branch, .type
' < git.json | \
while read -r app; read -r repo; read -r branch; read -r type ;do

# set url elements and jq argument based on type
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
"tag")
JQ_ARG=".[0].name"
GIT_SUFFIX="tags"
TYPE_SUFFIX="TAG"
;;
esac

# get version of each app
APP_RELEASE=$(curl --user "${SECRETUSER}:${SECRETPASS}" -sX GET "https://api.github.com/repos/${repo}/${GIT_SUFFIX}" \
		| jq -r "${JQ_ARG}")

# apply bash substitutions dependent on type
case "$type" in
"release"|"tag")
APP_RELEASE="${APP_RELEASE#v}"
;;
"commit")
APP_RELEASE="${APP_RELEASE:0:7}"
;;
esac

case "$app" in
"libtorrent")
APP_RELEASE="${APP_RELEASE#libtorrent_}"
APP_RELEASE="${APP_RELEASE//_/.}"
;;
"jq")
APP_RELEASE="${APP_RELEASE#jq-}"
;;
esac

echo "${app^^}_${TYPE_SUFFIX}=${APP_RELEASE}"

done


# read parameters from endpoint json file
jq -M -r '
    .[] | .app, .branch, .url, .urlsuffix, .manip
' < endpoint.json | \
while read -r app; read -r branch; read -r url; read -r urlsuffix; read -r manip ; do

# set url elements and string manipulation argument
case "$branch" in
"0")
FETCH_URL="${url}"
;;
*)
FETCH_URL="${url}${branch}${urlsuffix}"
;;
esac

# get version of each app
APP_RELEASE=$(curl -sX GET "${FETCH_URL}" | eval "${manip}")

echo "${app^^}_RELEASE=${APP_RELEASE}"

done
