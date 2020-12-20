# Automatic-Installation_basic-Ubuntu-setting

## File Content

| .sh File                                 | Installation                                                | Config                                                        | $Shell |
| :--------------------------------------- | :---------------------------------------------------------- | :------------------------------------------------------------ | ------ |
| **package.sh**                           | git, vim, curl                                              | git editer, git config --global user.name & user.email        | `bash` |
| **zsh_ohmyzsh_setup.sh**                 | zsh, oh-my-zsh                                              |                                                               | `bash` |
| **terminal-theme_and_ohmyzsh-config.sh** | powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting | `$SHELL profile`, custom `.p10k.zsh`, custom `gnome_terminal` | `zsh`  |
| **application.sh**                       | VScode, Google Chrome, VLC                                  |                                                               | `bash` |
| **pyenv_setup.sh**                       | pyenv                                                       | `$SHELL profile`                                              | `bash` |

Every .sh file can independent work.

If you want to setup all the setting, run:

```shell
chomd +x ./all_setup.sh
./all_setup.sh
```
