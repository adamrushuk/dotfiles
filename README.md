# dotfiles

dotfiles repo - tested with ubuntu 22.04

## Ubuntu 22.04 Installation

1. Open Microsoft Store.
1. Search for `Ubuntu` and select `Ubuntu 22.04 LTS`.
1. Click `Get` to download.
1. Follow the instructions to complete the initial setup.
1. Run `sudo apt update && sudo apt upgrade`.

## Usage

Follow the steps below to configure dotfiles on a fresh Linux system:

1. Clone into `~/dotfiles`:

    ```bash
    cd ~
    git clone https://github.com/adamrushuk/dotfiles.git
    ```

1. Run the install scripts:

    ```bash
    # [OPTIONAL] install zsh
    ~/dotfiles/install-zsh.sh
    
    # main install
    ~/dotfiles/install.sh
    ```

1. Place any secrets, and local overrides into `~/.local.rc` **DO NOT** add this file to the dotfiles repo.
1. Restart the shell session.
1. This [tools-install repo](https://github.com/adamrushuk/tools-install) is also cloned so common tools can be
   installed as required, eg:

    ```bash
    # installs all common tools
    ~/tools/install-common.sh
    
    # install tools individually
    ~/tools/azure-cli.sh
    ~/tools/helm.sh
    ~/tools/kubectl.sh
    ~/tools/kube-tools.sh
    ~/tools/misc.sh
    ~/tools/powershell.sh
    ~/tools/terraform.sh
    ~/tools/velero.sh
    ```

Thanks to BenC for the original dotfiles scripts: https://github.com/benc-uk/dotfiles
