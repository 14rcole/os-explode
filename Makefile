all: os-explode

DOCKER:=/usr/bin/docker

.PHONY: install
.PHONY: clean

image: os-explode
	${DOCKER} build -t projectatomic/exploder .

os-explode: main.go
	go build

install: kube/sa-exploder.yaml kube/dc-exploder.yaml
	oc create -f kube/sa-exploder.yaml -n default
	oc create -f kube/dc-exploder.yaml -n default
	oadm policy add-scc-to-user privileged system:serviceaccount:default:exploder

clean:
	rm os-explode
