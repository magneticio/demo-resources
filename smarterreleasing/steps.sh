#!/usr/bin/env bash

URL=$1
vamp login --url http://$URL --user root --password root
PROJECT_NAME=sava
vamp create project $PROJECT_NAME --init
vamp create user user1 -f https://raw.githubusercontent.com/magneticio/demo-resources/master/vamplamiacliv1/user1
.yaml
vamp grant --user user1 --role admin -p $PROJECT_NAME
vamp login --user user1 --password pass1
vamp bootstrap cluster prod
kubectl get pods -n vamp-system
kubectl apply -f sava-namespace.yml
vamp list virtualclusters
kubectl apply -f sava-cart-1.0.5-ie.yml
vamp create gateway sava-gateway -f ./sava-gateway.yaml
vamp create destination sava-cart-destination -f ./sava-cart-destination.yaml
vamp create vampservice sava-cart-vampservice -f ./sava-cart-vampservice.yaml
GATEWAY_IP=$(vamp get gateway sava-gateway -o=json --jsonpath '$.status.ip' --wait)
echo $GATEWAY_IP
curl -H "Host: ie.tutorials.vamp.cloud" -v http://$GATEWAY_IP
