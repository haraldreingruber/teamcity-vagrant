#!/bin/sh

sudo apt-get update -y
sudo apt-get install -y openjdk-7-jre-headless
sudo apt-get install -y curl
apt-get install -y -q unzip

cat >> /etc/hosts <<EOF
192.168.80.10   teamcity.localdomain teamcity
EOF

# install team city
# Download Build Agent from server and install
sudo wget -q http://teamcity:8111/update/buildAgent.zip -O /tmp/buildAgent.zip
sudo mkdir -p /srv/agent
unzip -q /tmp/buildAgent.zip -d /srv/agent

# create user
sudo useradd -m teamcity
sudo mkdir -p /srv/agent/conf
sudo chown -R teamcity /srv/agent
sudo chmod ug+x /srv/agent/bin/agent.sh

#AGENT_NAME=`hostname -s`
#sed -e "s/^name=.*$/name=$AGENT_NAME/g" \
#    -e "s/^serverUrl=.*$/serverUrl=http:\/\/teamcity:8111\/g" \
#     < /srv/agent/conf/buildAgent.dist.properties > /etc/teamcity-agent.properties
sudo cp /vagrant/files/agent/buildAgent.agent0.properties /srv/agent/conf/buildAgent.properties

sudo /srv/agent/bin/agent.sh start
