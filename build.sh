#!/bin/bash

yum install -y yum-utils
yum-config-manager --add-repo https://pkgs.tailscale.com/stable/amazon-linux/2/tailscale.repo
yum -y install tailscale



mkdir /tmp/extensions
mkdir /tmp/bin
mkdir -p /tmp/python/lib/python3.9/site-packages

cd /tmp/extensions
cp /opt/layer/extension1.sh .
cp /opt/layer/curl /tmp/bin/
cp /usr/bin/tailscale /tmp/bin/
cp /usr/sbin/tailscaled /tmp/bin
pip install pysocks -t /tmp/python/lib/python3.9/site-packages/

cd /tmp
zip -r /opt/layer/tailscale.zip extensions 
zip -r /opt/layer/tailscale.zip bin
zip -r /opt/layer/tailscale.zip python 