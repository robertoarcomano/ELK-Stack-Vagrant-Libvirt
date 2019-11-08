#!/bin/bash
# 0. Destroy existence vagrant VMs
vagrant destroy -f

# 1. Start Vagrant VMs
vagrant up --provider=libvirt

# 2. Launch tests
# for i in $(seq 1 3); do
#   echo "Testing elasticnode$i..."
#   vagrant ssh elasticnode$i -c "sudo /vagrant/testElasticsearch.sh"
# done
