#!/bin/bash
# based on https://gist.github.com/ipedrazas/9c622404fb41f2343a0db85b3821275d

# delete all evicted pods from all namespaces
kubectl get pods --all-namespaces | grep Evicted | awk '{print $2 " --namespace=" $1}' | xargs kubectl delete pod

# delete all containers in ImagePullBackOff state from all namespaces
kubectl get pods --all-namespaces | grep 'ImagePullBackOff' | awk '{print $2 " --namespace=" $1}' | xargs kubectl delete pod

# delete all containers in ImagePullBackOff or ErrImagePull or Evicted state from all namespaces
kubectl get pods --all-namespaces | grep -E 'ImagePullBackOff|ErrImagePull|Evicted' | awk '{print $2 " --namespace=" $1}' | xargs kubectl delete pod
