#!/bin/bash -v
sudo chown root:wheel `which brew`

brew cask install https://raw.githubusercontent.com/caskroom/homebrew-cask/master/Casks/java.rb
brew install wget
brew install homebrew/dupes/unzip

cat >> /etc/hosts <<EOF
192.168.50.170   teamcity.localdomain teamcity
EOF

# install team city
# Download Build Agent from server and install
sudo wget -q http://teamcity:8111/update/buildAgent.zip -O ${TMPDIR}buildAgent.zip
sudo mkdir -p /srv/agent
unzip -q ${TMPDIR}buildAgent.zip -d /srv/agent

# create user
sudo dscl . -create /Users/teamcity
sudo dscl . -create /Users/teamcity UserShell /bin/bash
sudo dscl . -create /Users/teamcity RealName "teamcity"
sudo dscl . -create /Users/teamcity UniqueID 8005
sudo dscl . -create /Users/teamcity PrimaryGroupID 20
sudo dscl . -create /Users/teamcity NFSHomeDirectory /Users/teamcity
sudo dscl . -passwd /Users/teamcity teamcity

sudo mkdir -p /srv/agent/conf
sudo chown -R teamcity /srv/agent
#sudo chmod ug+x /srv/agent/bin/agent.shs
sudo chmod ug+x /srv/agent/launcher/bin/*

#AGENT_NAME=`hostname -s`
#sed -e "s/^name=.*$/name=$AGENT_NAME/g" \
#    -e "s/^serverUrl=.*$/serverUrl=http:\/\/teamcity:8111\/g" \
#     < /srv/agent/conf/buildAgent.dist.properties > /etc/teamcity-agent.properties
sudo cp /vagrant/files/agent/buildAgent.osx.properties /srv/agent/conf/buildAgent.properties

sudo sh /srv/agent/bin/mac.launchd.sh load


#sudo chown : `which brew`