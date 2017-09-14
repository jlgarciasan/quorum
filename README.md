# Quorum + Constellation
Quorum (v1.1.0) and Constellation (v.0.1.0) installation in normal mode and with raft consensus


## Prerequisites
It´s necessary to install Docker and Docker Compose on your local machine if you want to deploy Quorum development environment.

## Create Docker Container with Quorum and constellation in normal mode
To install Quorum with their constellation in your local machine you must go to the folder in which is located Docker Compose file (docker-compose.yml), and execute the following command:

	docker-compose up -d

This command create three docker containers:

* Bootnode
* Node 1 (Quorum and Constellation)
* Node 2 (Quorum and Constellation)

If you want to shut down the containers and remove all, you can execute the following command:

	docker-compose down -v


## Create a Docker containers with RAFT Algorithm

To start the cluster

docker-compose up -d

This command create four docker containers:

* Node 1 (Quorum and Constellation with Raft)
* Node 2 (Quorum and Constellation with Raft)
* Node 3 (Quorum and Constellation with Raft)
* Node 4 (Quorum and Constellation without Raft and connected to the network as relay node through node 1)


If you want to shut down the containers and remove all, you can execute the following command:

	docker-compose down -v
