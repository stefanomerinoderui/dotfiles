#!/bin/sh
export NODE_VERSION=24
export UTCP_CONFIG_FILE=/home/stefano/.config/utcp/.utcp_config.json
exec /home/stefano/.nvm/nvm-exec pnpx -y @utcp/code-mode-mcp

