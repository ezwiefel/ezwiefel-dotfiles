CONFIG_DIR = "${HOME}/.config"
EZA_REPO_DIR = "${CONFIG_DIR}/eza"

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
echo 'export FPATH="${EZA_REPO_DIR}/completions/zsh:$FPATH"' >> ${CONFIG_DIR}/zsh/.zshenv

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh


# Create Symlinks
ln -s ${CONFIG_DIR}/zsh/.zshenv ${HOME}/.zshenv
ln -s ${CONFIG_DIR}/git/.gitconfig ${HOME}/.gitconfig