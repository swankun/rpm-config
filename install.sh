#!/usr/bin/env bash

ROOTDIR=$PWD
BASHRCFILE=$HOME/.bashrc
SRCDIR=$HOME/.local/src

function update {
    sudo dnf check-update
    sudo dnf -y upgrade
}

function install_essentials {
    sudo dnf install -y \
        tmux \
	vim \
	htop \
	git \
	zathura \
	zathura-djvu \
	openssh-server \
	net-tools \
	wget \
	cmake \
	pkg-config \
	curl
    sudo dnf groupinstall -y "Development Tools" "Development Libraries"
}

function gnome_setup {
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    sudo dnf install -y \
        chrome-gnome-shell \
	gnome-extensions-app \
	gnome-tweaks \
	gnome-shell-extension-caffeine \
	gnome-shell-extension-user-theme
}

function install_vscode {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    dnf check-update
    sudo dnf install -y code
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-vscode-remote.remote-ssh
    code --install-extension ms-python.python
    code --install-extension vscode-icons-team.vscode-icons
    code --install-extension dracula-theme.theme-dracula
    code --install-extension stkb.rewrap
}

function install_node {
    export NVM_DIR="$HOME/.local/nvm" && (
        git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
        cd "$NVM_DIR"
        git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    )
    cat <<EOF >> $HOME/.bashrc
export NVM_DIR=$NVM_DIR
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh" # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
}

function install_fzf {
    mkdir -p $SRCDIR && cd $SRCDIR
    git clone --depth 1 https://github.com/junegunn/fzf.git
    ./fzf/install
}

