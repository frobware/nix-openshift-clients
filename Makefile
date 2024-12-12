.PHONY: all
all:
	nix build .\#oc-meta --json \
	  | jq -r '.[].outputs | to_entries[].value' \
	  | cachix push frobware
