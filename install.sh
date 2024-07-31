CONFIG_DIR="${HOME}/dotfiles"
EZA_REPO_DIR="${CONFIG_DIR}/eza"
ZSH_FUNCTION_DIR="${CONFIG_DIR}/zsh/functions"

# Install zoxide and eza
sudo apt update
sudo apt install -y gpg

sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza fzf

# Setup eza completions
git clone https://github.com/eza-community/eza.git ${EZA_REPO_DIR}
echo 'export FPATH="${EZA_REPO_DIR}/completions/zsh:$FPATH"' >> "${CONFIG_DIR}/zsh/.zshenv"

# Setup taskfiile.dev completions
mkdir ${ZSH_FUNCTION_DIR}
sudo wget -O ${ZSH_FUNCTION_DIR}/_task https://raw.githubusercontent.com/go-task/task/main/completion/zsh/_task
echo 'export FPATH="${ZSH_FUNCTION_DIR}:$FPATH"' >> "${CONFIG_DIR}/zsh/.zshenv"

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
