#!/bin/bash

echo "**Obtem o manager"
curl --silent 'https://raw.githubusercontent.com/welrbraga/dotfiles-tools/master/dotfiles-tools/dotfiles_manager.bash' -o /tmp/dotfiles_manager.bash

echo "** Carrega o manager"
source "/tmp/dotfiles_manager.bash"

echo "** Pega pacote completo"
dot_update

source $HOME/dotfiles-tools/dotfiles_install.bash

#Choose one action
#dot_replicate #Para usar um repositório de dotfiles já preenchido
#dot_install #Para usar um repositório de dotfiles VAZIO
