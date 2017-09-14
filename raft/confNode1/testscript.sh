#!/bin/bash
set -u
set -e

echo "[*] Sending first transaction"
PRIVATE_CONFIG=/opt/configNode/tm1.conf geth --exec 'loadScript("script1.js")' attach ipc:/opt/configNode/qdata/dd1/geth.ipc
