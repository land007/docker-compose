#!/bin/bash
service docker start ; /usr/bin/docker-compose up -d ; /iptables.sh ; /portainer ; bash
