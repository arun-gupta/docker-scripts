# Swarm mode using Docker Machine

# Create manager and worker Machines
docker-machine create -d virtualbox manager1
docker-machine create -d virtualbox manager2
docker-machine create -d virtualbox manager3
docker-machine create -d virtualbox worker1
docker-machine create -d virtualbox worker2
docker-machine create -d virtualbox worker3

# Initialize Swarm mode and create a manager
docker-machine ssh manager1 docker swarm init --listen-addr $(docker-machine ip manager1) --auto-accept manager --auto-accept worker --secret mySecret

# Other masters join Swarm
docker-machine ssh manager2 docker swarm join --manager --listen-addr $(docker-machine ip manager2) --secret mySecret $(docker-machine ip manager1)
docker-machine ssh manager3 docker swarm join --manager --listen-addr $(docker-machine ip manager3) --secret mySecret $(docker-machine ip manager1)

# Workers join Swarm
docker-machine ssh worker1 docker swarm join $(docker-machine ip manager1):2377 --secret mySecret
docker-machine ssh worker2 docker swarm join $(docker-machine ip manager1):2377 --secret mySecret
docker-machine ssh worker3 docker swarm join $(docker-machine ip manager1):2377 --secret mySecret

#Connect to Swarm
echo 'eval $(docker-machine env manager1)'

