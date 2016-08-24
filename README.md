# mesos-kubernetes
Mesos on Kubernetes

# Steps

    kubectl create -f zookeeper-controller.yaml
    kubectl create -f zookeeper-service.yaml
    kubectl create -f mesos-master-controller.yaml
    kubectl create -f mesos-master-service.yaml
    kubectl create -f mesos-agent-controller.yaml

    kubectl create -f pyspark-controller.yaml

# Known Issue
  
    Pyspark use client mode to work with Mesos cluster. The framework can send SUBSCRIBE to the mesos master. But seems it doesn't confirm when Mesos master offer back
