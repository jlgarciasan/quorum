#!/bin/bash
set -u
set -e

NETID=87234
BOOTNODE_ENODE=enode://ac6b1096ca56b9f6d004b779ae3728bf83f8e22453404cc3cef16a3d9b96608bc67c4b30db88e0a5a6c6390213f7acbe1153ff6d23ce57380104288ae19373ef@172.18.0.2:21000

GLOBAL_ARGS="--bootnodes $BOOTNODE_ENODE --networkid $NETID --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

echo "[*] Cleaning up temporary data directories"
rm -rf opt/configNode
mkdir -p /opt/configNode
rm -rf /opt/qdata
mkdir -p /opt/qdata/logs


echo "[*] Configuring node 4"
mkdir -p /opt/qdata/dd4/keystore
mkdir -p /opt/qdata/dd4/geth

cp -R configNode/ /opt

#cp /opt/configNode/raft/static-nodes.json opt/qdata/dd4
cp /opt/configNode/keys/* opt/qdata/dd4/keystore
cp /opt/configNode/raft/nodekey4 opt/qdata/dd4/geth/nodekey
geth --datadir opt/qdata/dd4 init /opt/configNode/genesis.json

echo "[*] Starting Constellation nodes"
nohup constellation-node /opt/configNode/tm4.conf 2>> /opt/qdata/logs/constellation4.log &
sleep 6

echo "[*] Starting node 4"
PRIVATE_CONFIG=/opt/configNode/tm4.conf
nohup geth --datadir /opt/qdata/dd4 $GLOBAL_ARGS --rpcport 22000 --port 21000 2>>/opt/qdata/logs/4.log
