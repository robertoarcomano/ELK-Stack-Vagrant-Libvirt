#!/bin/bash

# 2. Install base packages
apt-get install -y bats jq openjdk-11-jre-headless mc apt-transport-https

# 3. Activate repository and install elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
add-apt-repository "deb https://artifacts.elastic.co/packages/7.x/apt stable main"
apt-get update
apt-get install -y elasticsearch logstash kibana

# 4. Configure ELK
# 4.1. Configure Elasticsearch
echo "
network.host: 0.0.0.0
cluster.name: elkcluster
node.name: \"elkhost\"
cluster.initial_master_nodes:
  - elkhost
" >> /etc/elasticsearch/elasticsearch.yml
# # 4.2. Configure Logstash
# echo "
# network.host: 0.0.0.0
# cluster.name: elkcluster
# node.name: \"elkhost\"
# cluster.initial_master_nodes:
#   - elkhost
# " >> /etc/elasticsearch/elasticsearch.yml
# 4.3. Configure Kibana
echo "
server.host: \"0.0.0.0\"
" >> /etc/kibana/kibana.yml

# 5. Enable and start Elasticsearch logstash
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
systemctl enable logstash.service
systemctl start logstash.service
systemctl enable kibana
systemctl start kibana
