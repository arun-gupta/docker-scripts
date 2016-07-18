set -x
publicIp=`aws ec2 describe-instances --filters Name=instance-state-name,Values=running | jq -r .Reservations[].Instances[].PublicDnsName`
privateIp=`aws ec2 describe-instances --filters Name=instance-state-name,Values=running | jq -r .Reservations[].Instances[].PrivateDnsName`

for node in $publicIpList
do
    ssh -o StrictHostKeyChecking=no -i ~/.ssh/aruncouchbase.pem ubuntu@$node 'curl -fsSL https://experimental.docker.com/ | sh'
    ssh -i ~/.ssh/aruncouchbase.pem ubuntu@$node 'sudo usermod -aG docker ubuntu'
    ssh -i ~/.ssh/aruncouchbase.pem ubuntu@$node 'docker version'
done
set -x

publicIp=($publicIpList)
privateIp=($privateIpList)

#Setup Swarm manager
ssh -o StrictHostKeyChecking=no -i ~/.ssh/aruncouchbase.pem ubuntu@${publicIp[0]} "docker swarm init --listen-addr ${privateIp[0]}:2377 --secret mySecret"

#Setup Swarm worker
ssh -o StrictHostKeyChecking=no -i ~/.ssh/aruncouchbase.pem ubuntu@${publicIp[1]} "docker swarm join --secret mySecret ${privateIp[0]}:2377"
ssh -o StrictHostKeyChecking=no -i ~/.ssh/aruncouchbase.pem ubuntu@${publicIp[2]} "docker swarm join --secret mySecret ${privateIp[0]}:2377"

