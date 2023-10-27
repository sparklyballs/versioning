#!/bin/bash

# set curl timeout parameters
curl_max_time=5
curl_retry=3
curl_retry_delay=5

# read parameters from cryptogit json file
jq -M -r '
    .[] | .app, .repo, .branch, .type
' < cryptogit.json | \
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
APP_RELEASE=$(curl -u "${SECRETUSER}:${SECRETPASS}" \
--retry $curl_retry --retry-delay $curl_retry_delay --max-time $curl_max_time \
-sX GET "https://api.github.com/repos/${repo}/${GIT_SUFFIX}" \
		| jq -r "${JQ_ARG}")

# apply bash substitutions dependent on type
case "$type" in
"release"|"tag")
APP_RELEASE="${APP_RELEASE#v}"
APP_RELEASE="${APP_RELEASE#V}"
;;
"commit")
APP_RELEASE="${APP_RELEASE:0:7}"
;;
esac

case "$app" in
"qbittorrent")
APP_RELEASE="${APP_RELEASE#release-}"
APP_RELEASE="${APP_RELEASE//_/.}"
;;
"libtorrent")
APP_RELEASE="${APP_RELEASE#libtorrent-}"
APP_RELEASE="${APP_RELEASE//_/.}"
;;
"jq")
APP_RELEASE="${APP_RELEASE#jq-}"
;;
"jitsi")
APP_RELEASE="${APP_RELEASE#stable-}"
;;
"nginx")
APP_RELEASE="${APP_RELEASE#release-}"
;;
esac

echo "${app^^}_${TYPE_SUFFIX}=${APP_RELEASE}"

done
