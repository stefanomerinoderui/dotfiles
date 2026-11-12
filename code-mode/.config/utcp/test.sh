#!/bin/sh
export NODE_VERSION=24
export UTCP_CONFIG_FILE=/home/stefano/.config/utcp/.utcp_config.json

pnpx @modelcontextprotocol/inspector \
  /home/stefano/.config/utcp/run-utcp.sh \
  --method tools/list \
  --format json
