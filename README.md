# OME Kubernetes SysOps Notebooks

Notebooks with examples of managing OME systems and applications.

Kubernetes production applications are managed with Helm and Helmfile.
All other OME deployments are managed with Ansible.


## Basic usage

Generate a secure access token.
Ensure you have access to a kube-config file containing credentials for accessing your Kubernetes cluster.

Run the container:

    JUPYTER_TOKEN=$(env LANG=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 32)

    docker run -d --name jupyter-notebook -p 8888:8888 \
        -e JUPYTER_TOKEN=$JUPYTER_TOKEN ome-k8s-helm-sysops-notebooks

Open the notebook server in your browser:

    echo http://localhost:8888/?token=$JUPYTER_TOKEN


## Usage with production deployments

You will need a copy of the OME's production deployment and private configuration repositories.
The following command assumes a local directory `./ome/` containing the following directory layout:
- `prod/playbooks/`: https://github.com/openmicroscopy/prod-playbooks/
- `ansible/inventory/`: Private Ansible inventory and variables for `prod/playbooks/`
- `k8s/apps/`: https://github.com/openmicroscopy/kubernetes-apps/
- `k8s/config/`: Private configuration files for `k8s/apps/`

Optionally configure your local `~/.ssh/` directory (otherwise omit the corresponding volume mount from the following )

    docker run -d --name jupyter-notebook -p 8888:8888 \
        -v /path/to/kube-config:/home/jovyan/.kube/config:ro \
        -v ~/.ssh:/home/jovyan/.ssh \
        -v $PWD/ome:/home/jovyan/ome:ro \
        -e JUPYTER_TOKEN=$JUPYTER_TOKEN ome-k8s-helm-sysops-notebooks


## Ansible authentication

The Bash kernel does not support interactive prompts, so passwords for SSH or sudo must be encoded in a file, for example `operator-secrets.yml`:
```
ansible_ssh_pass: login-password
ansible_become_pass: sudo-password
```
This file should be included on the Ansible command line with `-e @operator-secrets.yml`
