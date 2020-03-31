#!/bin/sh

echo "############## Delete Openshift route AB deployment ###############"
ssh master1 'oc delete -f f5-demo/app-route-ab.yaml'
echo "##############           DONE        ###############"

echo "############## Delete Apps to test AB Deployment ###############"
ssh master1 'oc delete -f f5-demo/app-deployment-ab-v1.yaml'
ssh master1 'oc delete -f f5-demo/app-deployment-ab-v2.yaml'
echo "##############           DONE            ###############"


exec $SHELL
