#!/bin/bash

USER=grenade
PASS=<PASSWORD HERE>

apt-get update
apt-get -y install build-essential python-pip git python3-pip

useradd -m $USER
echo "$USER:$PASS" | chpasswd

sudo adduser $USER sudo
chsh -s /bin/bash $USER
su $USER <<'DONE'
cd
mkdir .ssh
chmod 700 .ssh

cat > .ssh/authorized_keys << EOF
<PUBLIC KEY HERE>
EOF

git clone git://git.openstack.org/openstack-dev/grenade

cd grenade
cat > devstack.localrc << FINIS
disable_service h-api h-api-cfn h-api-cw h-eng heat
SCREEN_SLEEP=0.5
disable_service n-net
enable_service q-agt q-dhcp q-l3 q-meta q-svc quantum
Q_USE_DEBUG_COMMAND=True
NETWORK_GATEWAY=192.168.0.1
FIXED_RANGE=192.168.0.0/20
FLOATING_RANGE=172.24.5.0/24
PUBLIC_NETWORK_GATEWAY=172.24.5.1
USE_SCREEN=False
FINIS

DONE