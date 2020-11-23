#!/bin/bash

echo "**Obtem o manager"
curl --silent 'https://raw.githubusercontent.com/welrbraga/dotfiles-tools/master/dotfiles-tools/dotfiles_manager.bash' -o /tmp/dotfiles_manager.bash

echo "** Carrega o manager"
source "/tmp/dotfiles_manager.bash"

echo "** Pega pacote completo"
dot_update

source $HOME/dotfiles-tools/dotfiles_install.bash

#Para usar um repositório de dotfiles já preenchido
dot_replicate

#Restaura os arquivos marcados como "Deleted" pelo Git
#com os seus dotfiles acabaram de ser recuperados do repositório,
#Estes arquivos são na verdade aqueles não existem ainda na sua cópia local
for file in `dotfile status --short | awk '$1=="D" { print $2 }'`; do dot-undo $file; done

#dot_install #Para usar um repositório de dotfiles VAZIO
