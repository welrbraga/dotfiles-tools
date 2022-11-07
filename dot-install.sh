#!/bin/bash

# Obtem os arquivos do dotfiles-tools a partir do
# repositorio oficial. Isso é uma instalação bem simples
get_file() {
    [ -d "$PATH_INSTALL" ] || mkdir "$PATH_INSTALL"
    curl --silent "https://raw.githubusercontent.com/welrbraga/dotfiles-tools/master/dotfiles-tools/$1" -o "$PATH_INSTALL/$1"
}

# Configura o dotfiles_manager autoload on .bashrc file
dot_custom_bashrc() {

    cat <<EOF >>$HOME/.bashrc

source $HOME/dotfiles-tools/dotfiles_manager.bash
echo "# Recebendo atualizações dos dotfiles, se possível"
dot-autopull && dot-reload .bashrc &

EOF

}

# # Realiza a primeira configuração interativa do sistema
# dot_first_setup() {
#   read -p "Your name: " FULLNAME
#   read -p "Your e-mail: " MAILADDRESS
#   read -p "Github Login: " GITHUB_LOGIN
#   read -p "Github Repo: " GITHUB_REPO

#   sed -e "s|^FULLNAME=.*|FULLNAME=\"${FULLNAME}\"|" \
#       -e "s|^MAILADDRESS=.*|MAILADDRESS=\"${MAILADDRESS}\"|" \
#       -e "s|^GITHUB_LOGIN=.*|GITHUB_LOGIN=\"${GITHUB_LOGIN}\"|" \
#       -e "s|^GITHUB_REPO=.*|GITHUB_REPO=\"${GITHUB_REPO}\"|" \
#       -i "${CONFFILE}"
# }

# Personaliza o repositório com valores do arquivo dotfiles.conf
dot_custom_repo() {

  cd "$HOME/.dotfiles" || exit 2
  #Personaliza o repositório
  echo "Dotfiles de $FULLNAME">$HOME/.dotfiles/description
  dotfile config --local status.showUntrackedFiles no
  dotfile config --local user.email "$MAILADDRESS"
  dotfile config --local user.name "$FULLNAME"
  dotfile config --local core.hooksPath $HOME/dotfiles-tools/hooks
  cd "$HOME" || exit 3
}


# Clona o repositorio privado de dotfiles do usuário
# Este processo ocorre somente uma vez, durante a instalação
dot_replicate() {

    #Clone do repo no local
    git clone --bare "${DOTFILE_GITREMOTE}" "$HOME/.dotfiles"
    if [ ! $? ]; then
        echo "Não foi possível clonar seu repositório de dotfiles"
        return
    fi

    dot_custom_repo

    #Pega do repositorio somente os arquivos de gerencia
    dotfile reset HEAD
    #dotfile checkout -- dotfiles/**
    dotfile push --set-upstream origin master

    dot_custom_bashrc
}


PATH_INSTALL="$HOME/dotfiles-tools"
CONFFILE="$HOME/.dotfiles.conf"

mkdir -p "$PATH_INSTALL/hooks"

echo "# Obtem os arquivos atualizados"
get_file "dotfiles_manager.bash"
get_file "dotfiles.template.conf"
get_file "hooks/post-commit"

if [ ! -f "${CONFFILE}" ]; then
    echo "# Criando arquivo de configuração a ser personalizado"
    cp "$HOME/dotfiles-tools/dotfiles.template.conf" "${CONFFILE}"
    # dot_first_setup
fi

#Carrega o arquivo com as configurações do repositório  do usuário
# shellcheck disable=SC1090
source "${CONFFILE}"

if [ "$GITHUB_REPO" == "mydotfilesrepo" ]; then
    echo "**ERRO** dotfile-tools não configurado."
    echo "**ERRO** Edite o arquivo de configuração ${CONFFILE} e repita o processo de instalação"
    exit 1
else
    echo "Usuario: $GITHUB_LOGIN - $FULLNAME ($MAILADDRESS)"
    echo "URL do Repositório: $DOTFILE_GITREMOTE"
fi

#Carrega as funções de gerência
# shellcheck disable=SC1091
source "$PATH_INSTALL/dotfiles_manager.bash"

#Para usar um repositório de dotfiles já preenchido
dot_replicate

#Restaura os arquivos marcados como "Deleted" pelo Git
#com os seus dotfiles acabaram de ser recuperados do repositório,
#Estes arquivos são na verdade aqueles não existem ainda na sua cópia local
for file in $(dotfile status --short | awk '$1=="D" { print $2 }'); do dot-undo "$file"; done

#dot_install #Para usar um repositório de dotfiles VAZIO
