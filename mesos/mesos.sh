HOST=10.240.0.20

docker run -d -p 2181:2181 -p 2888:2888 -p 3888:3888 garland/zookeeper

docker run --privileged -d --net=host \
  linkerrepository/linker_exhibitor:1.5.6

  -v `pwd`/opt/zookeeper/snapshot:/opt/zookeeper/snapshot \
  -v `pwd`/opt/zookeeper/transactions:/opt/zookeeper/transactions 

docker run --privileged -d --net=host \
  -e MESOS_POST=5050 \
  -e MESOS_ZK=zk://$HOST_IP:2181/mesos \
  -e MESOS_QUORUM=1 \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -e MESOS_WORK_DIR=/var/lib/mesos/master \
  linkerrepository/mesos-master:0.28.1 mesos-master

docker run --privileged -d --net=host \
  -e MESOS_POST=5051 \
  -e MESOS_MASTER=zk://$HOST_IP:2181/mesos \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -e MESOS_WORK_DIR=/var/lib/mesos/master \
  -e MESOS_CONTAINERIZERS=docker,mesos \
  -v /sys/fs/cgroup:/sys/fs/cgroup \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin:/usr/local/bin \
  linkerrepository/mesos-slave:0.28.1 mesos-slave


docker run -d -p 5050:5050 \
  -e MESOS_POST=5050 \
  -e MESOS_ZK=zk://$HOST_IP:2181/mesos \
  -e MESOS_QUORUM=1 \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -e MESOS_WORK_DIR=/var/tmp/mesos \
  mesosphere/mesos-master:1.0.0

docker run -d --privileged -p 5051:5051 \
  -e MESOS_PORT=5051 \
  -e MESOS_MASTER=zk://$HOST_IP:2181/mesos \
  -e MESOS_QUORUM=1 \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -e MESOS_WORK_DIR=/var/tmp/mesos \
  -e MESOS_CONTAINERIZERS=docker\
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /sys/fs/cgroup:/cgroup -v /usr/bin/docker:/usr/bin/docker \
  mesosphere/mesos-slave:1.0.0
