$!/bin/sh

sudo -i
apt-get update
apt-get upgrade -y

apt-get install ruby ruby-dev tmux htop -y

echo "gem: --no-document" > /root/.gemrc
gem i bundler

cd /vagrant
bundle
