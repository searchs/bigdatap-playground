#!/usr/bin/env bash

# Starting ZooKeeper
# Local Instance
bin/zookeeper-server-start.sh config/zookeeper.properties 

# ZooKeeper Config: broker-single node cluster 
# the directory where the snapshot is stored.
dataDir=/tmp/zookeeper
# the port at which the clients will connect
clientPort=2181
# disable the per-ip limit on the number of connections since this is a non-production config
maxClientCnxns=0

# multiple brokers on a single node, different server property files are required for each broker.
# configure: broker.id, port, log.dir
# Start each broker with its config
bin/kafka-server-start.sh config/server_1.properties

# Create Kafka topic
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partition 1 --topic replica-kafkatopic


# Get list of topics
bin/kafka-topics.sh --list --zookeeper localhost:2181


# Start a Kafka Producer
$ bin/kafka-console-producer.sh --broker-list localhost:9092  --topic your-kafkatopic

# Start a Kafka Consumer
$ bin/kafka-console-consumer.sh --zookeeper localhost:2181 --from-beginning --topic your-kafkatopic
