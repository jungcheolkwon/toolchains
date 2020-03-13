# There is no latest git package for centos 7. So building it from source using docker multi-stage builds
# also speed-up sub-sequent builds


###########################################################
# base tools and dependencies
###########################################################
FROM centos:7 as base

RUN yum makecache fast && \
    yum -y install \
        libtirpc \
        python3 \
        python3-libs \
        python3-pip \
        python3-setuptools \
        unzip \
        bzip2 \
        make \
        openssh-clients \
        man \
        ansible \
        net-tools \
        bind-utils \
        tar \
        which && \
    yum -y update


###########################################################
# toolchains image
###########################################################
FROM base

# Arguments set during docker-compose build -b --build from .env file
ARG versionTerraform
ARG versionAzureCli
ARG versionTflint
#ARG versionGit
ARG versionJq
ARG versionDockerCompose
ARG versionLaunchpadOpensource

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ENV versionTerraform=${versionTerraform} \
    versionAzureCli=${versionAzureCli} \
    versionTflint=${versionTflint} \
    versionJq=${versionJq} \
    versionGit=${versionGit} \
    versionDockerCompose=${versionDockerCompose} \
    versionLaunchpadOpensource=${versionLaunchpadOpensource} \
    TF_DATA_DIR="/home/${USERNAME}/.terraform.cache" \
    TF_PLUGIN_CACHE_DIR="/home/${USERNAME}/.terraform.cache/plugin-cache"

     
RUN yum -y install \
        make \
        zlib-devel \
        curl-devel \ 
        gettext \
        bzip2 \
        gcc \
        tar \
        gzip \
        unzip && \
    #echo "Installing git ${versionGit}..." && \
    #curl -sSL -o /tmp/git.tar.gz https://www.kernel.org/pub/software/scm/git/git-${versionGit}.tar.gz && \
    #tar xvf /tmp/git.tar.gz -C /tmp && \
    #cd /tmp/git-${versionGit} && \
    #./configure && make && make install && \
    echo "Installing git ..." && \
    yum -y install git && \
    # Install Docker CE CLI.
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum -y install docker-ce-cli && \
    #
    echo "Installing awscli" && \
    yum -y install awscli && \
    #
    # Install Docker-Compose 
    echo "Installing docker-compose ${versionDockerCompose}..." && \
    curl -sSL -o /usr/bin/docker-compose "https://github.com/docker/compose/releases/download/${versionDockerCompose}/docker-compose-Linux-x86_64" && \
    chmod +x /usr/bin/docker-compose && \
    #
    # Install Azure-cli
    echo "Installing azure-cli ${versionAzureCli}..." && \
    rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    sh -c 'echo -e "[azure-cli] \n\
name=Azure CLI \n\
baseurl=https://packages.microsoft.com/yumrepos/azure-cli \n\
enabled=1 \n\
gpgcheck=1 \n\
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo' && \
    cat /etc/yum.repos.d/azure-cli.repo && \
    yum -y install azure-cli-2.2.0 && \
    #
    echo "Installing jq ${versionJq}..." && \
    curl -sSL -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
    #
    # Install Terraform
    echo "Installing terraform ${versionTerraform}..." && \
    curl -sL -O https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip 2>&1 && \
    unzip -d /usr/local/bin terraform_0.12.23_linux_amd64.zip && \
    rm terraform*.zip && \
    #
    # Clean-up
    rm -f /tmp/*.zip && rm -f /tmp/*.gz && \
    rm -rfd /tmp/git-${versionGit} && \
    # 
    echo "Creating ${USERNAME} user..." && \
    useradd --uid $USER_UID -m -G docker ${USERNAME} && \
    # sudo usermod -aG docker ${USERNAME} && \
    mkdir -p /home/${USERNAME}/.vscode-server /home/${USERNAME}/.vscode-server-insiders /home/${USERNAME}/.ssh /home/${USERNAME}/.ssh-localhost /home/${USERNAME}/.azure /home/${USERNAME}/.terraform.cache /home/${USERNAME}/.terraform.cache/tfstates && \
    chown ${USER_UID}:${USER_GID} /home/${USERNAME}/.vscode-server* /home/${USERNAME}/.ssh /home/${USERNAME}/.ssh-localhost /home/${USERNAME}/.azure /home/${USERNAME}/.terraform.cache /home/${USERNAME}/.terraform.cache/tfstates  && \
    yum install -y sudo && \
    echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

RUN mkdir -p /tf/toolchains && \
    cd /tf/toolchains && \
    git clone https://github.com/jungcheolkwon/blueprint.git && \
    chown -R ${USERNAME}:1000 /tf/toolchains

WORKDIR /tf/toolchains

USER ${USERNAME}
