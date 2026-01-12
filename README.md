# dotfiles

dotfiles repo - tested with `Ubuntu 24.04 LTS` on WSL.

## Ubuntu 24.04 Installation

1. Open PowerShell or Command Prompt as Administrator.
1. Run the following commands to install `Ubuntu 24.04 LTS`:

    ```powershell
    # List installed WSL distributions
    wsl --list
    
    # List available WSL distributions
    wsl --list --online
    
     # Install Ubuntu 24.04 LTS
    wsl --install -d Ubuntu-24.04
    ```

1. Follow the instructions to complete the initial setup.
1. Run `sudo apt update && sudo apt upgrade`.

## Usage

Follow the steps below to configure dotfiles on a fresh Linux system:

1. Clone into `~/dotfiles`:

    ```bash
    cd ~
    git clone https://github.com/adamrushuk/dotfiles.git
    ```

1. Run the install script:

    ```bash
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
