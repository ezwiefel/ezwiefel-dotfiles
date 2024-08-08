CONFIG_DIR="${HOME}/dotfiles"
EZA_REPO_DIR="${CONFIG_DIR}/eza"
ZSH_FUNCTION_DIR="${CONFIG_DIR}/zsh/functions"

# Check if this is running in MacOS and if so, install Task, eza, and fzf using
# brew
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Install eza
    brew install eza fzf go-task
    echo $'export PATH="${HOME}/.local/bin:${HOME}/homebrew/bin:$PATH' >> "${CONFIG_DIR}/zsh/.zshenv"

else  # If not running in MacOS, it's likely running in Linux
    ## Install zoxide and eza
    sudo apt update
    sudo apt install -y gpg

    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza fzf

    # Set PATH
    echo $'export PATH="${HOME}/.local/bin:$PATH\n' >> "${CONFIG_DIR}/zsh/.zshenv"

    ## Install nodejs, npm, and go-task

    # Check if npm is installed and if not, intall it
    if ! command -v npm &> /dev/null
    then
        sudo apt install -y nodejs npm
    fi

    # Install task
    npm install -g @go-task/cli

fi

# Setup eza completions
git clone https://github.com/eza-community/eza.git ${EZA_REPO_DIR}


# Setup taskfiile.dev completions
mkdir ${ZSH_FUNCTION_DIR}
sudo wget -O ${ZSH_FUNCTION_DIR}/_task https://raw.githubusercontent.com/go-task/task/main/completion/zsh/_task

# Create a FPATH variable in .zshenv
echo $'export FPATH="${EZA_REPO_DIR}/completions/zsh:${ZSH_FUNCTION_DIR}:$FPATH"\n' >> "${CONFIG_DIR}/zsh/.zshenv"

if ! command -v zoxide &> /dev/null
then
    # Install zoxide
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Create Symlinks - renaming the files that already exist, if there.

if [ -e ${HOME}/.zshenv ]
then
    mv ${HOME}/.zshenv ${HOME}/.zshenv.old
fi

cp -s ${CONFIG_DIR}/zsh/.zshenv ${HOME}/.zshenv

if [ -e ${HOME}/.zshrc ]
then
    mv ${HOME}/.zshrc ${HOME}/.zshrc.old
fi

if [ -e ${HOME}/.gitconfig ]
then
    mv ${HOME}/.gitconfig ${HOME}/.gitconfig.old
fi

cp ${CONFIG_DIR}/git/.gitconfig ${HOME}/.gitconfig
