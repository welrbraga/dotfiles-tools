#Installer of dotfile manager

#Ref. https://www.atlassian.com/git/tutorials/dotfiles

#This file won't be executed in a terminal
#Load this with source command

####################################################################################
#
# *** NÃO ALTERE ESTE ARQUIVO ***
#
# Alterar este arquivo no seu repositório poderá deixá-lo incoerente com a versão
# oficial disponivel em https://github.com/welrbraga/dotfiles-tools
#
# As suas alterações poderão ser perdidas quando você desejar fazer uma nova
# instalação ou atualizar a partir do repositório oficial
#
#####################################################################################

source $HOME/dotfiles-tools/dotfiles.conf

alias dotfile='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

dot_custom_repo() {
	# Customize your repo info with dotfiles.conf values

	cd "$HOME/.dotfiles"
	#Personaliza o repositório
	echo "Dotfiles de $FULLNAME">$HOME/.dotfiles/description
	dotfile config --local status.showUntrackedFiles no
	dotfile config --local user.email "$MAILADDRESS"
	dotfile config --local user.name "$FULLNAME"
	dotfile config --local core.hooksPath $HOME/dotfiles-tools/hooks
	cd "$HOME"
}

dot_custom_bashrc() {
    #Configure dotfiles_manager autoload on .bashrc file

    cat <<EOF >>$HOME/.bashrc

source $HOME/dotfiles-tools/dotfiles_manager.bash

echo "Recebendo atualizações dos dotfiles, se possível"
dot-autopull
dot-reload .bashrc

EOF

}

dot_install() {
    #Before use this, certify yourself of you have a private repo in Github
    #to keep your dotfiles safe.

    #Cria o repo local
    git init --bare $HOME/.dotfiles
    if [ ! $? ]; then
        echo "Não foi possível clonar seu repositório de dotfiles"
        return
    fi

    dot_custom_repo

    #Realiza um commit inicial para permitir o push para o servidor remoto
    echo "# dotfiles" >> README.md
    dotfile add README.md
    dotfile commit -m "Primeiro commit"

    #Configura o repositório remoto e realiza o primeiro push
    cd $HOME/.dotfiles
    dotfile remote add origin git@github.com:${GITHUB_LOGIN}/${GITHUB_REPO}.git
    dotfile push --mirror git@github.com:${GITHUB_LOGIN}/${GITHUB_REPO}.git
    dotfile push --set-upstream origin master

    dot_custom_bashrc

    #Carrega as funções de gerência
    source $HOME/dotfiles-tools/dotfiles_manager.bash
}


dot_replicate() {

    #Clone do repo no local
    git clone --bare git@github.com:${GITHUB_LOGIN}/${GITHUB_REPO}.git "$HOME/.dotfiles"
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

    #Carrega as funções de gerência
    source $HOME/dotfiles-tools/dotfiles_manager.bash
}
