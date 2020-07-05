
#Ref. https://www.atlassian.com/git/tutorials/dotfiles

#Nao executar
#Carregar com source

#MAILADDRESS="welrbraga@yahoo.com"
#FULLNAME="Welington R Braga"
#GITHUB_LOGIN="welrbraga"
#GITHUB_REPO="dotfiles"

source $HOME/dotfiles-tools/dotfiles.conf

alias dotfile='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

dot_install() {
    #Antes de usar esta função você já deve ter um repositório vazio
    #Criado no Github para que os seus novos commits sejam enviados

    #Cria o repo local
    git init --bare $HOME/.dotfiles

    #Personaliza o repositório
    echo "Dotfiles de $FULLNAME">$HOME/.dotfiles/description
    dotfile config --local status.showUntrackedFiles no
    dotfile config --local user.email "$MAILADDRESS"
    dotfile config --local user.name "$FULLNAME"
    dotfile config --local core.hooksPath $HOME/dotfiles-tools/hooks

    #Cria um link simbólico para o arquivo com funções de gerencia de dotfiles
    ln -fs "$PWD/dotfiles_manager.bash" "$HOME/.dotfiles_manager.bash"

    #Configura a inicialização automatica da gerencia dos dotfiles
    echo "source $HOME/.dotfiles_manager.bash" >> $HOME/.bashrc

    #Realiza um commit inicial para permitir o push para o servidor remoto
    echo "# dotfiles" >> README.md
    dotfile add README.md
    dotfile commit -m "Primeiro commit"

    #Configura o repositório remoto e realiza o primeiro push
    cd $HOME/.dotfiles
    dotfile remote add origin git@github.com:${GITHUB_LOGIN}/${GITHUB_REPO}.git
    dotfile push --mirror git@github.com:${GITHUB_LOGIN}/${GITHUB_REPO}.git
    dotfile push --set-upstream origin master

    #Carrega as funções de gerência
    source $HOME/.dotfiles_manager.bash
}


dot_replicate() {

    #Clone do repo no local
    git clone --bare git@github.com:${GITHUB_LOGIN}/${GITHUB_REPO}.git $HOME/.dotfiles

    #Personaliza o repositório
    echo "Dotfiles de $FULLNAME">$HOME/.dotfiles/description
    dotfile config --local status.showUntrackedFiles no
    dotfile config --local user.email "$MAILADDRESS"
    dotfile config --local user.name "$FULLNAME"
    dotfile config --local core.hooksPath $HOME/dotfiles-tools/hooks

    #Pega do repositorio somente os arquivos de gerencia
    dotfile reset HEAD
    dotfile checkout -- dotfiles/**
    dotfile push --set-upstream origin master

    #Cria um link simbólico para o arquivo com funções de gerencia de dotfiles
    ln -fs "$PWD/dotfiles_manager.bash" "$HOME/.dotfiles_manager.bash"

    #Configura a inicialização automatica da gerencia dos dotfiles
    echo "source $HOME/.dotfiles_manager.bash" >> $HOME/.bashrc

    #Carrega as funções de gerência
    source $HOME/.dotfiles_manager.bash
}
