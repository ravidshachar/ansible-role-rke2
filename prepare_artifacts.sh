#!/bin/bash

usage() {
    cat <<EOF
Creates an artifacts tar ready with everything needed for airgap installation.
usage: $0 --rke2_version RKE2_VERSION [--download_path ARTIFACTS_DIR] [--arch ARCHITECTURE] [--clone]
RKE2_VERSION is the rke2 version including the suffix e.g. v1.25.3+rke2r1
ARTIFACTS_DIR is the directory in which all of the artifacts will be downloaded. by default /tmp/rke2_artifacts
ARCHITECTURE is the release architecture e.g. amd64. by default amd64.
--clone: wether or not should the repository also be cloned
EOF
    exit 1
}

# parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --rke2_version)
            RKE2_VERSION="$2" && shift 2 ;;
        --arch)
            RKE2_ARCH="$2" && shift 2 ;;
        --download_path)
            DOWNLOAD_PATH="$2" && shift 2 ;;
        --clone)
            CLONE=1 && shift ;;
        *)
            echo "Unknown option: $1"
            usage ;;
    esac
done

[ "$RKE2_VERSION" ] || usage
[ "$RKE2_ARCH" ] || RKE2_ARCH="amd64"
[ "$DOWNLOAD_PATH" ] || DOWNLOAD_PATH="/tmp/rke2_artifacts"

mkdir -p $DOWNLOAD_PATH

wget -P $DOWNLOAD_PATH https://github.com/rancher/rke2/releases/download/${RKE2_VERSION}/sha256sum-${RKE2_ARCH}.txt
wget -P $DOWNLOAD_PATH https://github.com/rancher/rke2/releases/download/${RKE2_VERSION}/rke2.linux-${RKE2_ARCH}.tar.gz
wget -P $DOWNLOAD_PATH https://github.com/rancher/rke2/releases/download/${RKE2_VERSION}/rke2-images.linux-${RKE2_ARCH}.tar.zst
wget -P $DOWNLOAD_PATH https://github.com/rancher/rke2/releases/download/${RKE2_VERSION}/rke2-images-calico.linux-${RKE2_ARCH}.tar.zst
wget -P $DOWNLOAD_PATH https://github.com/rancher/rke2/releases/download/${RKE2_VERSION}/rke2-windows-ltsc2022-${RKE2_ARCH}-images.tar.gz
wget -P $DOWNLOAD_PATH https://github.com/rancher/rke2/releases/download/${RKE2_VERSION}/rke2.windows-${RKE2_ARCH}.tar.gz 
wget -O $DOWNLOAD_PATH/install.ps1 https://raw.githubusercontent.com/rancher/rke2/master/install.ps1
wget -O $DOWNLOAD_PATH/rke2.sh https://get.rke2.io
[ "$CLONE" ] && git clone https://github.com/ravidshachar/ansible-role-rke2 $DOWNLOAD_PATH/rke2-ansible