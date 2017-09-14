#!/bin/bash
set -u
set -e
NETID=87234
BOOTNODE_ENODE=enode://61077a284f5ba7607ab04f33cfde2750d659ad9af962516e159cf6ce708646066cd927a900944ce393b98b95c914e4d6c54b099f568342647a1cd4a262cc0423@10.0.2.15:33445?discport=21000

GLOBAL_ARGS="--bootnodes $BOOTNODE_ENODE --networkid $NETID --rpc --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum"

echo "[*] Cleaning up temporary data directories"
rm -rf /opt/qdata
mkdir -p /opt/qdata/logs

echo "[*] Configuring node 2 as block maker and voter"
mkdir -p /opt/qdata/dd2/keystore
cp -arx /configNode/* /opt
cp /opt/keys/key2 /opt/qdata/dd2/keystore
cp /opt/keys/key3 /opt/qdata/dd2/keystore
geth --datadir /opt/qdata/dd2 init /opt/genesis.json

echo "[*] Starting Constellation nodes"
nohup constellation-node /opt/tm2.conf 2>> /opt/qdata/logs/constellation2.log &
sleep 6

echo "[*] Starting node 2"
PRIVATE_CONFIG=/opt/tm2.conf nohup geth --datadir /opt/qdata/dd2 $GLOBAL_ARGS --rpcport 22000 --port 21000 --voteaccount "0x0fbdc686b912d7722dc86510934589e0aaf3b55a" --votepassword "" --blockmakeraccount "0xca843569e3427144cead5e4d5999a3d0ccf92b8e" --blockmakerpassword "" --singleblockmaker --minblocktime 2 --maxblocktime 5 2>>/opt/qdata/logs/2.log
