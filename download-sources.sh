#!/bin/bash

function get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/$2/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' | # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/' # Pluck JSON value
}

owner="cpotter302"
repo="aliasrc-shell"
tag=$(get_latest_release $owner $repo)
artifact="alirc-sources-$tag.zip"
#[ -n $1  ] && tag=$1

list_asset_url="https://api.github.com/repos/${owner}/${repo}/releases/tags/${tag}"

# get url for artifact with name==$artifact
asset_url=$(curl "${list_asset_url}" | jq ".assets[] | select(.name==\"${artifact}\") | .url" | sed 's/\"//g')

# download the artifact

curl -vLJO -H 'Accept: application/octet-stream' "${asset_url}"
