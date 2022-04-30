## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## kafka/docker/up: runs service containers from kafka and zookeeper
.PHONY: kafka/docker/up
kafka/docker/up:
	@echo 'Run docker containers...'
	cd ~/Tools/kafka/docker && docker compose -f kafka.yml up -d

## kafka/docker/down: stops service containers from kafka and zookeeper
.PHONY: kafka/docker/down
kafka/docker/down:
	@echo 'Stop docker containers...'
	cd ~/Tools/kafka/docker && docker compose -f kafka.yml down

## kafka/topic/list: list available topics
.PHONY: kafka/topic/list
kafka/topic/list:
	@echo 'Listing topics...'
	docker exec -it docker_kafka_1 kafka-topics.sh --bootstrap-server kafka:9092 --list

## kafka/topic/create topic_name=$1: create a new kafka topic
.PHONY: kafka/topic/create
kafka/topic/create:
	@echo 'Creating a new topic...'
	docker exec -it docker_kafka_1 kafka-topics.sh --bootstrap-server kafka:9092 --create --topic ${topic_name}

## kafka/topic/describe/all: show all created topics
.PHONY: kafka/topic/describe/all
kafka/topic/describe/all:
	@echo 'Showing all topic statuses...'
	docker exec -it docker_kafka_1 kafka-topics.sh --bootstrap-server kafka:9092 --describe

## kafka/topic/describe/topic: show specific topic status
.PHONY: kafka/topic/describe/topic
kafka/topic/describe/topic:
	@echo 'Showing specific topic status...'
	docker exec -it docker_kafka_1 kafka-topics.sh --bootstrap-server kafka:9092 --describe --topic ${topic_name}

## kafka/producer/write topic_name=$1: Push a new message into queue
.PHONY: kafka/producer/write
kafka/producer/write:
	@echo 'Put some message into topic'
	docker exec -it docker_kafka_1 kafka-console-producer.sh --bootstrap-server kafka:9092 --topic ${topic_name}

## kafka/consumer/read topic_name=$1: Read all messages from the the beginning of topic
.PHONY: kafka/consumer/read
kafka/consumer/read:
	@echo 'Reading messages from topic'
	docker exec -it docker_kafka_1 kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic ${topic_name} --from-beginning

## kafka/topic/delete topic_name=$1: Delete a topic
.PHONY: kafka/topic/delete
kafka/topic/delete:
	@echo 'Deleting topic'
	docker exec -it docker_kafka_1 kafka-topics.sh --bootstrap-server kafka:9092 --delete --topic ${topic_name}


## kafka/topic/configs entity_name=$1 max_msg_bytes=$2
.PHONY: kafka/topic/configs
kafka/topic/configs:
	@echo 'Configure messages size in kafka topic'
	docker exec -it docker_kafka_1 kafka-configs.sh --bootstrap-server kafka:9092 --entity-type topics --entity-name ${entity_name} --alter --add-config max.message.bytes=${max_msg_bytes}






