#!/usr/bin/env bash
sudo apt install zsh
chsh -s $(which zsh)

# oh-my-zsh package install
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" 
sudo git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
# sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" | exit
echo "=======================================done==================================="

# TODO: use sed to edit ~/.zshrc, ~/.p10k.zsh
sed -ie 's/ZSH_THEME=*/ZSH_THEME="powerlevel10k/powerlevel10k"/' -ie 's/^plugins/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
printf "# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.\n[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc


# terminal theme setting
cp ttf/*ttf ~/.local/share/fonts/
fc-cache -f -v 
dconf load /org/gnome/terminal/ < gnome_terminal_settings_backup.txt


# remove command
sudo apt remove zsh -y
sudo apt autoremove
sudo rm -rf /home/ys_huang/.oh-my-zsh
sudo rm -rf ~/.zsh*
sudo rm -rf /themes/powerlevel10k
sudo rm -rf /plugins/zsh-autosuggestions
sudo rm -rf /plugins/zsh-syntax-highlighting
