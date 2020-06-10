## Setup
### Install and setup MicroK8s
- Follow the instructions in the [documentation](https://microk8s.io/docs)
- Enable ingress: `microk8s enable ingress dns helm3`

### Create aliases
Insert into `~/.bash_aliases`
```
alias kubectl='microk8s kubectl'
alias helm='microk8s helm3'
```

### Setup helm
- `helm repo add stable https://kubernetes-charts.storage.googleapis.com`

### Use kubectl from another machine
- Retrieve the config from microk8s: `microk8s config`
- Store it on the local machine under `~/.kube/config`

### Setup Cert Manager
- `kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.14/deploy/manifests/00-crds.yaml`
- `helm repo add jetstack https://charts.jetstack.io && helm repo update`
- `helm install cert-manager jetstack/cert-manager --namespace kube-system`
- `kubectl create -f cert/staging.yml`
- `kubectl create -f cert/prod.yml`

### Setup Media Storage
- `kubectl create -f media-pv.yml`
- `kubectl create -f media-pvc.yml`

### Setup Plex
- Create storage directory `mkdir -p /home/ubuntu/k8s/plex`
- Create a claim token by following the link [https://plex.tv/claim](https://plex.tv/claim)
- Create secret `microk8s kubectl create secret generic plex-secret --from-literal=claim-token=<CLAIM>`
- Run `./installPlex.sh`
- Expose TCP ports from plex-service `kubectl create configmap --namespace=ingress nginx-ingress-tcp-microk8s-conf --from-literal=32400="default/plex-service:32400" --from-literal=32469="default/plex-service:32469"`
- Expose UDP ports from plex-service `kubectl create configmap --namespace=ingress nginx-ingress-udp-microk8s-conf --from-literal=5353="default/plex-service:5353" --from-literal=1900="default/plex-service:1900"`
- Edit daemonset `kubectl edit daemonsets.apps -n=ingress nginx-ingress-microk8s-controller`
- Add ports:
  ```
  ports:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
  - containerPort: 32400
    hostPort: 32400
    protocol: TCP
  - containerPort: 32469
    hostPort: 32469
    protocol: TCP
  - containerPort: 1900
    hostPort: 1900
    protocol: UDP
  - containerPort: 5353
    hostPort: 5353
    protocol: UDP
  ```

### Setup Next Cloud
Extract helm chart values: `helm show values stable/nextcloud >> nextcloud.values.yml`  
Replace the host, username, password values and the storage values:
```
nextcloud:
  host: "nextcloud.<domain.com>"
  username: "admin" # Admin
  password: "<PASSWORD>"
(...)
persistence:
  enabled: true
  existingClaim: "media-claim"
  accessMode: ReadWriteOnce
  size: "50Gi"
```
Install the helm chart: `microk8s helm3 install nextcloud stable/nextcloud --values nextcloud.values.yml`

### Monitoring
- Will install Prometheus, Grafana and Kube State Metrics
- `kubectl create namespace monitoring`
- On the node: `mkdir -p /home/ubuntu/k8s/grafana`
- `./monitoring/installMonitoring.sh`

## Uninstall
- `./uninstallPlex.sh`
- `microk8s kubectl delete secret plex-secret`
- `./monitoring/uninstallMonitoring.sh`