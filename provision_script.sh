#!/bin/bash

# 1. Create CSV file
export N=1000
awk -v N=$N 'BEGIN {
  srand();
  # Header
  print "id;name;price;date";
  for (i=0; i<N; i++) {
    # Day
    d=sprintf("%.2d",(rand()*30)+1);

    # Month
    m=sprintf("%.2d",(rand()*11)+1);

    # Year
    y="2019"

    # Hour
    hh=sprintf("%.2d",(rand()*22));
    mm=sprintf("%.2d",(rand()*60));
    ss=sprintf("%.2d",(rand()*60));

    # Timestamp
    # 2016-11-10 06:06:11
    timestamp=y "/" m "/" d " " hh ":" mm ":" ss
    print i ";" "Name " i ";" (rand()*100) ";" timestamp;
  }
}' > /vagrant/document.csv

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

# 4.2. Configure Logstash
cp /vagrant/document.conf /etc/logstash/conf.d/

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
