#!/bin/bash

for i in {1..200}
do

  curl http://www.gslb.cloud5demo.com
  echo "------------- $i -----------"
  sleep 2

done
