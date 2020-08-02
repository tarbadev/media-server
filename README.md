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

### Use kubectl remotely
- Retrieve the config from microk8s: `microk8s config`
- Store it on the local machine under `~/.kube/config`

### Setup HDDs with Raid 1
- Identify the drives  
`sudo blkid`
- Create a RAID-1 drive  
`sudo mdadm --create --verbose /dev/md/vol1 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1`
- Confirm the RAID Array  
`sudo mdadm --detail /dev/md/vol1`
- Save RAID Array
```bash
sudo -i
mdadm --detail --scan >> /etc/mdadm/mdadm.conf
exit
```
- Create File System  
`sudo mkfs.ext4 -v -m .1 -b 4096 -E stride=32,stripe-width=64 /dev/md/vol1`
- Identify the drives  
`sudo blkid`
- Add the new drive in /etc/fstab (need sudo)
`UUID=e921ab4c-c7f7-4008-a30d-a6b588e341a2       /home/ubuntu/k8s/media  ext4    defaults        0       0`

### Setup helm
- `helm repo add stable https://kubernetes-charts.storage.googleapis.com`

### Setup Cert Manager
- `kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager.yaml`
- `kubectl apply -f cert`

- `kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.14/deploy/manifests/00-crds.yaml`
- `helm repo add jetstack https://charts.jetstack.io && helm repo update`
- `helm install cert-manager jetstack/cert-manager --namespace kube-system`

### Setup Media Storage
- `kubectl create -f media-pv.yml`
- `kubectl create -f media-pvc.yml`

### Setup Plex
- Create storage directory `mkdir -p /home/ubuntu/k8s/plex`
- Create a claim token by following the link [https://plex.tv/claim](https://plex.tv/claim)
- Create secret `kubectl create secret generic plex-secret --from-literal=claim-token=<CLAIM>`
- Run `./installPlex.sh`

### Setup File Browser
- Modify the file under `file-browser/users.json` with the password hash (using https://bcrypt-generator.com for example)
- Run `./installFileBrowser.sh`

### Monitoring
- Will install Prometheus, Grafana and Kube State Metrics
- `kubectl create namespace monitoring`
- On the node: `mkdir -p /home/ubuntu/k8s/grafana`
- `./monitoring/installMonitoring.sh`

## Uninstall
- `./uninstallPlex.sh`
- `./uninstallFileBrowser.sh`
- `kubectl delete secret plex-secret`
- `kubectl delete pvc media-claim`
- `kubectl delete pv media-volume`
- `./monitoring/uninstallMonitoring.sh`