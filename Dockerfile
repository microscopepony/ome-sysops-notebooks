FROM jupyter/base-notebook:45e010d9e849
MAINTAINER spli@dundee.ac.uk

# Bash kernel https://github.com/takluyver/bash_kernel
RUN pip install bash-kernel==0.7.1 && \
    python -m bash_kernel.install

USER root
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
    curl

# Based on kube-helm-docker
ARG KUBE_VERSION=1.10.4
ARG HELM_VERSION=2.9.1
ARG HELMFILE_VERSION=0.21.0
ARG HELMDIFF_VERSION=2.9.0+2
RUN curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -zxvf - linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rmdir linux-amd64 && \
    curl -sL https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 -o /usr/local/bin/helmfile && \
    chmod +x /usr/local/bin/*

USER $NB_UID

RUN mkdir -p $HOME/.helm/plugins && \
    curl -sSL https://github.com/databus23/helm-diff/releases/download/v${HELMDIFF_VERSION}/helm-diff-linux.tgz | \
    tar -C $HOME/.helm/plugins -xz

ENV JUPYTER_ENABLE_LAB=1
COPY --chown=1000:100 notebooks/ /notebooks/
