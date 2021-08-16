#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
sudo apt-add-repository ppa:apt-fast/stable
sudo apt-add-repository ppa:fish-shell/release-3
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install -y apt-fast
sudo /usr/bin/apt-fast install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 fish vim neovim emacs python3-neovim vifm spotify-client rustc cargo libasound2-dev libssl-dev exa bat htop wget neofetch firefox
wget https://dl.discordapp.net/apps/linux/0.0.12/discord-0.0.12.deb
sudo apt install ./discord-0.0.12.deb
cd ~/Downloads/
git clone https://github.com/salman-abedin/devour.git && cd devour && sudo make install
cd ..
git clone https://github.com/alacritty/alacritty
cd alacritty
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
cd $SCRIPT_DIR
rm -r -f $SCRIPT_DIR/alacritty
chsh -s /usr/bin/fish
/usr/bin/fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
/usr/bin/fish -c "fisher install ilancosman/tide"
/usr/bin/fish -c "fisher install franciscolourenco/done"
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | bash
cd
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
