#!/usr/bin/env bash
sudo apt install zsh
chsh -s $(which zsh)

# oh-my-zsh package install
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
sudo git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# TODO: use sed to edit ~/.zshrc, ~/.p10k.zsh

# terminal theme setting
cp ttf/*ttf ~/.local/share/fonts/
fc-cache -f -v 
dconf load /org/gnome/terminal/ < gnome_terminal_settings_backup.txt