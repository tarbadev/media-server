## Setup
### Install and setup MicroK8s
- Follow the instructions in the [documentation](https://microk8s.io/docs)
- Enable ingress: `microk8s enable ingress helm3`

### Setup Cert Manager
- `microk8s kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.14/deploy/manifests/00-crds.yaml`
- `microk8s helm3 repo add jetstack https://charts.jetstack.io && helm repo update`
- `microk8s helm3 install cert-manager jetstack/cert-manager --namespace kube-system`
- `microk8s kubectl create -f cert/staging.yml`
- `microk8s kubectl create -f cert/prod.yml`

### Setup Media Storage
- `microk8s kubectl create -f media-pv.yml`
- `microk8s kubectl create -f media-pvc.yml`

### Create Plex Secret
- Create a claim token by following the link [https://plex.tv/claim](https://plex.tv/claim)
- `microk8s kubectl create secret generic plex-secret --from-literal=claim-token=<CLAIM>`

### Create Plex Server
- `./installPlex.sh`

### Setup Next Cloud
Extract helm chart values: `microk8s helm3 show values stable/nextcloud >> nextcloud.values.yml`  
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

## Uninstall
- `./uninstallPlex.sh`
- `microk8s kubectl delete secret plex-secret`