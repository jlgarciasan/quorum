#!/bin/bash
set -u
set -e
NETID=87234
BOOTNODE_KEYHEX=77bd02ffa26e3fb8f324bda24ae588066f1873d95680104de5bc2db9e7b2e510

echo "[*] Cleaning up temporary data directories"
rm -rf opt/qdata
mkdir -p opt/qdata/logs

echo "[*] Starting bootnode"
nohup bootnode --nodekeyhex "$BOOTNODE_KEYHEX" --addr="0.0.0.0:33445" 2>>opt/qdata/logs/bootnode.log
