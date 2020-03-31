#!/bin/sh

echo "############## Delete Openshift route ###############"
ssh master1 'oc delete -f f5-demo/app-route.yaml'
echo "##############           DONE        ###############"

echo "############## Delete App to test routes ###############"
ssh master1 'oc delete -f f5-demo/app-deployment-route.yaml'
echo "##############           DONE            ###############"


exec $SHELL
