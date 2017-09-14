#!/bin/bash
set -u
set -e
NETID=87234
BOOTNODE_ENODE=enode://61077a284f5ba7607ab04f33cfde2750d659ad9af962516e159cf6ce708646066cd927a900944ce393b98b95c914e4d6c54b099f568342647a1cd4a262cc0423@10.0.2.15:33445?discport=21000

GLOBAL_ARGS="--bootnodes $BOOTNODE_ENODE --networkid $NETID --rpc --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

echo "[*] Cleaning up temporary data directories"
rm -rf /opt/qdata
mkdir -p /opt/qdata/logs

echo "[*] Configuring node 1"
mkdir -p /opt/qdata/dd1/keystore
cp -arx /configNode/* /opt
cp /opt/keys/key1 /opt/qdata/dd1/keystore
geth --datadir /opt/qdata/dd1 init /opt/genesis.json

echo "[*] Starting Constellation nodes"
nohup constellation-node /opt/tm1.conf 2>> /opt/qdata/logs/constellation1.log &
sleep 6

echo "[*] Starting node 1"
PRIVATE_CONFIG=/opt/tm1.conf nohup geth --datadir /opt/qdata/dd1 $GLOBAL_ARGS --rpcport 22000 --port 21000 --unlock 0 --password /opt/passwords.txt 2>>/opt/qdata/logs/1.log
