## Setup
### Install and setup MicroK8s
- Follow the instructions in the [documentation](https://microk8s.io/docs)
- Enable ingress: `microk8s enable ingress`

### Create Plex Secret
- Create a claim token by following the link [https://plex.tv/claim](https://plex.tv/claim)
- `microk8s kubectl create secret generic plex-secret --from-literal=claim-token=<CLAIM>`

### Create Plex Server
- `./installPlex.sh`

## Uninstall
- `./uninstallPlex.sh`
- `microk8s kubectl delete secret plex-secret`