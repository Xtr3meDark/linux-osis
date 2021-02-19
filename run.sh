#!/bin/bash

#-----#
# VAR #
#-----#
DOWNLOADS="/tmp/OSIS"
echo "Digite o user.name para o GIT: "
read gitName
echo "Digite o user.email para o GIT: "
read gitEmail

#-----------#
# FUNCTIONS #
#-----------#

function bash_theme {
    cd $HOME
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
    mv .bashrc .bashrcBAK
    sed '6 cOSH_THEME="powerline-multiline"' .bashrcBAK > .bashrc
    rm .bashrcBAK
    source .bashrc
}

function cleanup {
    echo "Removing /tmp/OSIS"
    rm -rf $DOWNLOADS
}

function install() {
    sudo apt-get -y install $@
}

function installSnap() {
    sudo snap install $@
}

#----------#
# PACKAGES #
#----------#


# BROWSER

function install_chrome() {
    wget -c "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -P "$DOWNLOADS"
}

# EMAIL

function install_mailspring() {
    installSnap mailspring
}

# IDE

function install_android-studio() {
    installSnap "android-studio --classic"
    install "qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager"
    sudo usermod -aG libvirt $USER
    sudo usermod -aG kvm $USER
}

function install_vscode() {
    installSnap "code --classic"
}

# PASSWORD MANAGER

function install_myki() {
    wget -c "https://static.myki.com/releases/da/MYKI-latest-amd64.deb" -P "$DOWNLOADS"
}

# PROGRAMMING

function install_docker() {
    install "docker docker-compose"

    sudo service docker stop

    echo "{" | sudo tee /etc/docker/daemon.json
    echo "  \"graph\": \"$HOME/Documents/.docker\"" | sudo tee /etc/docker/daemon.json -a
    echo "}" | sudo tee /etc/docker/daemon.json -a

    sudo usermod -aG docker ${USER}

    sudo service docker start

    zenity \
    --info \
    --no-wrap \
    --text="Docker installation needs a logout or a reboot, dont forget to do it later"
}

function install_flutter() {
    cd $HOME
    install git
    git clone https://github.com/flutter/flutter.git
    echo "alias adb='\$HOME/Android/Sdk/platform-tools/adb'" >> .bash_aliases
    echo "alias flutter='\$HOME/flutter/bin/flutter'" >> .bash_aliases
}

function install_node() {
    curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    nvm install node --lts
}

# VCS

function install_git() {
    install git

    git config --global core.fileMode false
    git config --global credential.helper store

    getInput "GIT" "Default commit NAME"
    git config --global user.name "$gitName"
    getInput "GIT" "Default commit EMAIL"
    git config --global user.email "$gitEmail"
}

function install_git-flow() {
    install git-flow
}

#------#
# MAIN #
#------#

trap cleanup EXIT

install "curl"

# Make dir
mkdir "$DOWNLOADS"

# Remove apt lock and update repo
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock
sudo apt update -y

# Install packages
install_git
install_git-flow
install_chrome
install_mailspring
install_android-studio
install_vscode
install_myki
install_docker
install_flutter

bash_theme

# wget install
sudo dpkg -i $DOWNLOADS/*.deb
cleanup
