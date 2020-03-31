#!/bin/sh

echo "############## Deploy Apps to test AB deployment ###############"
ssh master1 'oc create -f f5-demo/app-deployment-ab-v1.yaml'
ssh master1 'oc create -f f5-demo/app-deployment-ab-v2.yaml'
echo "##############           DONE            ###############"

echo "############## Create Openshift route for AB deployment ###############"
ssh master1 'oc create -f f5-demo/app-route-ab.yaml'
echo "##############           DONE        ###############"

exec $SHELL
