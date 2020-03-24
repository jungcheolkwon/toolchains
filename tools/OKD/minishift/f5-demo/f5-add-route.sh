#!/bin/sh

echo "############## Deploy App to test routes ###############"
ssh master1 'oc create -f f5-demo/app-deployment-route.yaml'
echo "##############           DONE            ###############"

echo "############## Create Openshift route ###############"
ssh master1 'oc create -f f5-demo/app-route.yaml'
echo "##############           DONE        ###############"

exec $SHELL
