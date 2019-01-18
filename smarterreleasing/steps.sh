#!/usr/bin/env bash

URL=$1
vamp2cli --login http://$URL --user root --password root
PROJECT_NAME=sava
vamp2cli create project $PROJECT_NAME --init
vamp2cli create user user1 -f https://raw.githubusercontent.com/magneticio/demo-resources/master/vamplamiacliv1/user1
.yaml
vamp2cli grant --user user1 --role admin -p $PROJECT_NAME
vamp2cli login --user user1 --password pass1
vamp2cli bootstrap cluster prod
kubectl get pods -n vamp-system
kubectl apply -f sava-namespace.yml
vamp2cli list virtualclusters
kubectl apply -f sava-cart-1.0.5-ie.yml
vamp2cli create gateway sava-gateway -f ./sava-gateway.yaml
vamp2cli create destination sava-cart-destination -f ./sava-cart-destination.yaml
vamp2cli create vampservice sava-cart-vampservice -f ./sava-cart-vampservice.yaml
GATEWAY_IP=$(vamp2cli get gateway sava-gateway -o=json --jsonpath '$.status.ip' --wait)
echo $GATEWAY_IP
curl -H "Host: ie.tutorials.vamp.cloud" -v http://$GATEWAY_IP
