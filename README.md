# Ubuntu-Setup-Scripts

## File Content

| .sh File                 | Installation                                                                                                       | Config                                                 | $Shell |
| :----------------------- | :----------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------- | ------ |
| **package.sh**           | git, vim, curl, wget, make, typing_method: ibus, ibus-chewing, extra_packages: openssh-server, tmux, python3-pip | git editor, git config --global user.name & user.email, custom `$HOME/.vimrc` | `bash` |
| **zsh_ohmyzsh_setup.sh** | zsh, oh-my-zsh                                                                                                     |                                                        | `bash` |
| **ohmyzsh_config.sh**    | powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting                                                        | custom `$HOME/.p10k.zsh`, `$SHELL profile`                   | `zsh`  |
| **terminal_config.sh**   |                                                                                                                    | custom `gnome_terminal`, `$SHELL profile`              | `bash` |
| **application.sh**       | VScode, Google Chrome, VLC, GIMP, kolourpaint4, OBS                                                                |                                                        | `bash` |
| **language_package.sh**       | pyenv, pipenv, nvm                                                                                                              | `$SHELL profile`                                       | `bash` |
| **custom_function.sh**       | `nvm()`: for seed up shell. `pipenv_correspond()`: find the correspond venvs & remove                                                                                            it.                   | `$SHELL profile`, `$HOME/.customfunction`                                       | `bash` |

Every .sh file can independent work.

If you want to setup all the setting, run:

```shell
chmod +x ./all_setup.sh
./all_setup.sh
```

## Note

This all_setup.sh need to execute two times, follow the step:

1. Execute the script to complete package.sh and ZSH setup.
2. Relogin.
3. Execute the script to complete others .sh file.
