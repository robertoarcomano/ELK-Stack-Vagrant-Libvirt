#!/usr/bin/env bats
@test "Check Items Count" {
  N_ITEMS=$(curl -X GET -H "Content-Type: application/json" "localhost:9200/customers/_search?pretty" \
       -d '{ "from" : 0, "size" : 20 }' 2>/dev/null |\
        jq -rj '.hits.hits[]._source | .id," ",.name," ",.price,"\n"'|wc -l)
  [ "$N_ITEMS" = "20" ]
}
