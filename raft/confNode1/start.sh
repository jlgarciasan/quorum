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


echo "[*] Configuring node 1"
mkdir -p /opt/qdata/dd1/keystore
mkdir -p /opt/qdata/dd1/geth

cp -R configNode/ /opt

cp /opt/configNode/raft/static-nodes.json opt/qdata/dd1
cp /opt/configNode/keys/* opt/qdata/dd1/keystore
cp /opt/configNode/raft/nodekey1 opt/qdata/dd1/geth/nodekey
geth --datadir opt/qdata/dd1 init /opt/configNode/genesis.json

echo "[*] Starting Constellation nodes"
nohup constellation-node /opt/configNode/tm1.conf 2>> /opt/qdata/logs/constellation1.log &
sleep 6

echo "[*] Starting node 1"
PRIVATE_CONFIG=/opt/configNode/tm1.conf
nohup geth --datadir /opt/qdata/dd1 $GLOBAL_ARGS --rpcport 22000 --port 21000 --unlock 0 --password /opt/configNode/passwords.txt 2>>/opt/qdata/logs/1.log
