#!/usr/bin/env bats
# Test Elasticsearch

# Global Vars
VAR="catalog/users"

get_cluster() {
  local value=$(curl -X GET -H "Content-Type: application/json" "http://localhost:9200/_cluster/health" 2>/dev/null|jq -r ".$1")
  echo $value
}

get_host() {
  local value=$(curl -X GET -H "Content-Type: application/json" "http://localhost:9200/" 2>/dev/null|jq -r ".$1")
  echo $value
}

insert() {
  # Insert data
  for i in $(seq 1 10); do
    OUT=$(curl -X PUT -H "Content-Type: application/json" \
      "http://localhost:9200/$VAR/$i" \
      -d '{ "name": "roberto", "id": 1 }' 2>/dev/null )
  done
}

implicit_insert() {
  # Insert data
  for i in $(seq 1 10); do
    OUT=$(curl -X POST -H "Content-Type: application/json" \
      "http://localhost:9200/$VAR/" \
      -d '{ "name": "roberto", "id": "'$i'" }' 2>/dev/null )
  done
}

# get() {
#   # Read data
#   curl -X GET -H "Content-Type: application/json" \
#     "localhost:9200/$VAR/1?pretty"
#   echo
#   echo
# }

search() {
  local N=$(curl -X POST -H "Content-Type: application/json" \
    "localhost:9200/$VAR/_search?pretty" 2>/dev/null|jq -r ".hits.total.value")
  echo "$N"
}

delete() {
  # Delete data
  OUT=$(curl -X DELETE "localhost:9200/*" 2>/dev/null )
  echo
  echo
}

@test "Check Node Name" {
  node_name=$(get_host "name")
  [ "$node_name" = "$HOSTNAME" ]
}

@test "Check Cluster Name" {
  cluster_name=$(get_cluster "cluster_name")
  [ "$cluster_name" = "Elasticsearch_Cluster" ]
}

@test "Check Cluster Status" {
  status=$(get_cluster "status")
  [ "$status" = "green" ]
}

@test "Insert and Read 10 items" {
 delete
 sleep 1
 insert
 sleep 1
 N=$(search)
 echo "post insert: " $N
 [ "$N" = "10" ]
}

@test "Delete all" {
 delete
 sleep 1
 N=$(search)
 [ "$N" = "null" ]
}

@test "Implicit Insert and Read 10 items" {
 implicit_insert
 sleep 1
 N=$(search)
 echo "post insert: " $N
 [ "$N" = "10" ]
}
