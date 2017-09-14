#!/bin/bash
set -u
set -e

NETID=87234

GLOBAL_ARGS="--networkid $NETID --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

echo "[*] Cleaning up temporary data directories"
rm -rf opt/configNode
mkdir -p /opt/configNode
rm -rf /opt/qdata
mkdir -p /opt/qdata/logs


echo "[*] Configuring node 2"
mkdir -p /opt/qdata/dd2/keystore
mkdir -p /opt/qdata/dd2/geth

cp -R configNode/ /opt

cp /opt/configNode/raft/static-nodes.json opt/qdata/dd2
cp /opt/configNode/keys/* opt/qdata/dd2/keystore
cp /opt/configNode/raft/nodekey2 opt/qdata/dd2/geth/nodekey
geth --datadir opt/qdata/dd2 init /opt/configNode/genesis.json

echo "[*] Starting Constellation nodes"
nohup constellation-node /opt/configNode/tm2.conf 2>> /opt/qdata/logs/constellation2.log &
sleep 6

echo "[*] Starting node 2"
PRIVATE_CONFIG=/opt/configNode/tm2.conf
nohup geth --datadir /opt/qdata/dd2 $GLOBAL_ARGS --rpcport 22000 --port 21000 2>>/opt/qdata/logs/2.log
