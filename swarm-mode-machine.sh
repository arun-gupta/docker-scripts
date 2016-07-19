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

# docker-machine ssh manager1 docker node ls
#ID                           HOSTNAME  MEMBERSHIP  STATUS  AVAILABILITY  MANAGER STATUS
#3c8cb7vum10nb1g2nacayeug4    manager3  Accepted    Ready   Active        Reachable
#5agmss6z60n486ulkqoxb1f3w *  manager1  Accepted    Ready   Active        Leader
#awlvyg3blqvbiid3xthjevw0i    worker3   Accepted    Ready   Active        
#dcs7krlylp8ewjt9j460chebr    worker1   Accepted    Ready   Active        
#ds2fn1axn6ie4qymu0yzzitoh    manager2  Accepted    Ready   Active        Reachable
#e1oudnt4689inhbc50rmcgljn    worker2   Accepted    Ready   Active        

