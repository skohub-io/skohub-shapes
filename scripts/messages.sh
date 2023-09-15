#!/bin/bash

sparql() {
  data=$1
  query=$2
  docker run --rm -v $query:/rdf/query.rq --mount type=bind,source=$data,target=/rdf/data.ttl skohub/jena:4.6.1 arq --data /rdf/data.ttl --query /rdf/query.rq --results=TSV
}

sparql $(pwd)/skos.shacl.ttl $(pwd)/scripts/messages.rq
