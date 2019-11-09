#!/bin/bash
# 0. Destroy existence vagrant VMs
vagrant destroy -f

# 1. Start Vagrant VMs
vagrant up --provider=libvirt

# 2. Wait for the ELK Stack to settle
sleep 60

# 3. Launch tests
vagrant ssh -c "sudo /vagrant/testELK.sh"
