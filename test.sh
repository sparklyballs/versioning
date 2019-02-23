#!/bin/bash

# read parameters from git json file
jq -M -r '
    .[] | .app, .branch, .url, .urlsuffix, .manip
' < endpoint.json | \
while read -r app; read -r branch; read -r url; read -r urlsuffix; read -r manip ; do

case "$branch" in
"0")
FETCH_URL="${url}"
;;
*)
FETCH_URL="${url}${branch}${urlsuffix}"
;;
esac

APP_RELEASE=$(curl -s "${FETCH_URL}" | eval "${manip}")
echo "${app^^}_RELEASE=${APP_RELEASE}"

done
