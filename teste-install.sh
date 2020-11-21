#!/bin/bash

# Para testes locais não necessitarem download da versão no repositório Git
# echo "**clone"
# git clone http://github.com/welrbraga/dotfiles-tools.git
# echo "**cp"
# cp -r dotfiles-tools/dotfiles-tools $HOME

echo "**source"
source "$HOME/dotfiles-tools/dotfiles_install.bash"

echo "**install"
dot_install
