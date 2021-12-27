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

dot_install() {
    #Before use this, certify yourself of you have a EMPTY private repo
    #in Github to keep your dotfiles safe.

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
    dotfile remote add origin "${DOTFILE_GITREMOTE}"
    dotfile push --mirror "${DOTFILE_GITREMOTE}"
    dotfile push --set-upstream origin master

    dot_custom_bashrc
}
