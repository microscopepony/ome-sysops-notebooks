# OME Kubernetes SysOps Notebooks

Notebooks with examples of managing the OME Kubernetes systems


## Basic usage

Generate a secure access token. Ensure you have access to a kube-config file containing credentials for accessing your Kubernetes cluster.
Run the container:

    JUPYTER_TOKEN=$(env LANG=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 32)

    docker run -d --name jupyter-notebook -p 8888:8888 \
        -v /path/to/kube-config:/home/jovyan/.kube/config:ro \
        -e JUPYTER_TOKEN=$JUPYTER_TOKEN ome-k8s-helm-sysops-notebooks

Open the notebook server in your browser:

    echo http://localhost:8888/?token=$JUPYTER_TOKEN


## Usage with production deployments

OME Kubernetes production applications can be managed with Helmfile.
You will need a copy of https://github.com/openmicroscopy/kubernetes-apps/ plus private config. The following command assumes a local directory `./k8s/` containing two subdirectories:
- `apps`: Contains the contents of the `openmicroscopy/kubernetes-apps/` repo
- `config`: Contains the private configuration files

    docker run -d --name jupyter-notebook -p 8888:8888 \
        -v /path/to/kube-config:/home/jovyan/.kube/config:ro \
        -v $PWD/k8s:/home/jovyan/k8s:ro \
        -e JUPYTER_TOKEN=$JUPYTER_TOKEN ome-k8s-helm-sysops-notebooks
