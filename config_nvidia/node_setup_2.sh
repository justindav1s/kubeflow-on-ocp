#/bin/bash

# https://developer.ibm.com/linuxonpower/2018/09/19/using-nvidia-docker-2-0-rhel-7/

#run on the master as root

# 1. If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
yum remove nvidia-docker

# 2. Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.repo | tee /etc/yum.repos.d/nvidia-container-runtime.repo

# 3. Install the nvidia runtime hook
yum install -y nvidia-container-runtime-hook

# NOTE:  Step 4 is only needed if you're using the older nvidia-container-runtime-hook-1.3.0  The default(1.4.0) now includes this file
# 4. Add hook to OCI path

mkdir -p /usr/libexec/oci/hooks.d

echo -e '#!/bin/sh\nPATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" exec nvidia-container-runtime-hook "$@"' | tee /usr/libexec/oci/hooks.d/nvidia

chmod +x /usr/libexec/oci/hooks.d/nvidia

# 5. Adjust SELINUX Permissions
chcon -t container_file_t  /dev/nvidia*
