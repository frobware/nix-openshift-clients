#!/usr/bin/env bash

# Fetches SHA256 hashes for OpenShift client binaries across all
# supported platforms. This script downloads the OpenShift client from
# mirror.openshift.com for each architecture and system combination,
# then generates the SHA256 hashes needed for the Nix flake.
#
# Usage: ./fetch-hash.sh <OCP-VERSION> [additional-versions...]
#
# Examples:
#   nix develop --command ./fetch-hash.sh 4.19.8
#   nix develop --command ./fetch-hash.sh 4.19.8 4.19.9
#
# Note: This script requires nix-prefetch. If running outside the
# development environment, use 'nix develop --command' to ensure
# required tools are available. Requires full version number (e.g.,
# 4.19.8, not 4.19). The script will output hashes in the format
# expected by flake.nix.

set -eu

if [[ $# -eq 0 ]]; then
    echo "Usage: ${0##*/} <OCP-VERSION>"
    echo
    echo "Fetches SHA256 hashes for OpenShift client binaries."
    echo "Requires full version number (e.g., 4.19.1, not 4.19)."
    echo
    echo "Examples:"
    echo "  ${0##*/} 4.19.1"
    echo "  ${0##*/} 4.19.1 4.19.2"
    exit 1
fi

for arch in aarch64 x86_64; do
    for system in mac linux; do
	for version in "$@"; do
	    filename="openshift-client-${system}.tar.gz"
	    if [[ $arch == "aarch64" ]]; then
		filename="openshift-client-${system}-arm64.tar.gz"
	    fi
	    url="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$version/$filename"
	    hash=$(nix hash to-sri --type sha256 "$(nix-prefetch fetchurl --type sha256 --quiet --url "$url")")
	    if [[ $system =~ mac ]]; then
		system=darwin
	    fi
	    echo "${arch}-${system} = \"$hash\";"
	done
    done
done
