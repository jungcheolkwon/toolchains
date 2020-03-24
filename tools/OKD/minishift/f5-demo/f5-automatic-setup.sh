#!/bin/sh

echo "############## Deploy Container Connector 1 ###############"
ssh master1 'oc create -f f5-demo/cc-bigip1-deployment.yaml'
echo "##############           DONE               ###############"

echo "############## Deploy Container Connector 2 ###############"
ssh master1 'oc create -f f5-demo/cc-bigip2-deployment.yaml'
echo "##############           DONE               ###############"

echo "############## Deploy APPLICATION IN THE F5-DEMO SECTION  ###############"
ssh master1 'oc create -f f5-demo/app-deployment.yaml'
ssh master1 'oc create -f f5-demo/app-configmap.yaml'
echo "##############           DONE               #############################"

echo "Your APP and Container connectors are setup, access http://10.1.10.80 to test the app."
echo  "You have shortcuts in chrome to access the different environment"
echo "openshift credentials: student/student and go to the f5-demo pod"
echo "bigip: admin/admin and go to the kubernetes partition"


exec $SHELL
