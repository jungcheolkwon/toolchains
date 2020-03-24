#!/bin/sh

echo "############## Remove APPLICATION ###############"
ssh master1 'oc delete -f f5-demo/app-configmap.yaml'
ssh master1 'oc delete -f f5-demo/app-deployment.yaml'
echo "##############       DONE         ###############"

sleep 10s

echo "############## Remove Container Connector 1 ###############"
ssh master1 'oc delete -f f5-demo/cc-bigip1-deployment.yaml'
echo "##############           DONE               ###############"

echo "############## Remove Container Connector 2 ###############"
ssh master1 'oc delete -f f5-demo/cc-bigip2-deployment.yaml'
echo "##############           DONE               ###############"

exec $SHELL
