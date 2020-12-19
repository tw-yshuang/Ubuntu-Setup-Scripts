#!/usr/bin/env bash
sudo apt install zsh
chsh -s $(which zsh)

# oh-my-zsh package install
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" 
# sudo git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
p10k configure
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
# sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" | exit
echo "=======================================done==================================="
# TODO: use sed to edit ~/.zshrc, ~/.p10k.zsh

# terminal theme setting
cp ttf/*ttf ~/.local/share/fonts/
fc-cache -f -v 
dconf load /org/gnome/terminal/ < gnome_terminal_settings_backup.txt


# remove comand
sudo apt remove zsh -y
sudo apt autoremove
sudo rm -rf /home/ys_huang/.oh-my-zsh
sudo rm -rf ~/.zsh*
sudo rm -rf /themes/powerlevel10k
sudo rm -rf /plugins/zsh-autosuggestions
sudo rm -rf /plugins/zsh-syntax-highlighting
