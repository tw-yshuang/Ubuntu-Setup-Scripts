# Automatic-Installation_basic-Ubuntu-setting

## File Content

| .sh File                 | Installation                                                                    | Config                                                 | $Shell |
| :----------------------- | :------------------------------------------------------------------------------ | :----------------------------------------------------- | ------ |
| **package.sh**           | git, vim, curl, wget, make, extra_packages: openssh-server, screen, python3-pip | git editer, git config --global user.name & user.email | `bash` |
| **zsh_ohmyzsh_setup.sh** | zsh, oh-my-zsh                                                                  |                                                        | `bash` |
| **ohmyzsh_config.sh**    | powerlevel10k, zsh-autosuggestions, zsh-syntax-highlighting                     | `$SHELL profile`, custom `.p10k.zsh`                   | `zsh`  |
| **terminal_config.sh**   |                                                                                 | custom `gnome_terminal`, `$SHELL profile`              | `bash` |
| **application.sh**       | VScode, Google Chrome, VLC                                                      |                                                        | `bash` |
| **pyenv_setup.sh**       | pyenv                                                                           | `$SHELL profile`                                       | `bash` |
| **nvm_setup.sh**         | nvm                                                                             | `$SHELL profile`                                       | `bash` |

Every .sh file can independent work.

If you want to setup all the setting, run:

```shell
chomd +x ./all_setup.sh
./all_setup.sh
```
