#Funções para gerencia dos dotfiles

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

echo "# Carregando funções de controle de dotfiles para $USER"

dot_update() {
  echo "Obtendo atualizações de dotfiles-tools"
  REPONAME="dotfiles-tools"
  OFFICIALREPO="https://github.com/welrbraga/${REPONAME}"
  BRANCH="master"
  cd /tmp && (
    tmpzip="$(mktemp).zip" #já inclui o /tmp antes do nome
    curl --silent --location "${OFFICIALREPO}/archive/${BRANCH}.zip" --output "${tmpzip}"
    COMMIT=$(unzip -u "${tmpzip}" | awk '{ nlines++ ; if (nlines==2) {print $0;}; }' )
    INSTALLED=$(cat $HOME/dotfiles-tools/COMMIT 2>/dev/null || echo "Unknown")
    echo $COMMIT > /tmp/${REPONAME}-${BRANCH}/dotfiles-tools/COMMIT
    echo "Instalado: $INSTALLED"
    echo "Obtido:    $COMMIT"
    if [ ! "$COMMIT" == "$INSTALLED" ]; then
        echo "Atualizando";
        cp -r /tmp/${REPONAME}-${BRANCH}/dotfiles-tools "$HOME/";
    else
        echo "Nada alterado";
    fi
    rm -rf /tmp/${REPONAME}-${BRANCH} $tmpzip
  )
}

dotfile() {
  /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

#Registra a mudança em um arquivo dotfile
dot-add() {
    dotfile add "$@"
}

#Registra e "comita" a mudança em um arquivo dotfile
dot-track() {
    dotfile add "$1"
    dotfile commit -m "$2"
}

#Deixa de registrar as mudanças em um arquivo dotfile
dot-untrack() {
    dotfile rm --cached "$@"
}

#Lista os arquivos modificados no ultimo commit
dot-lastchange() {
    dotfile log --max-count=1
    echo ""
    echo "Arquivos alterados:"
    echo ""
    dotfile show --name-status --pretty="" "$@"
}

#Submete as mudanças ao repositório
dot-push() {
    dotfile push "$@"
}

#Obtem mas atualizações do repositório
dot-pull() {
    actualcommit=$(dotfile log --max-count=1 --pretty=format:"%h")
    dotfile pull
    newcommit=$(dotfile log --max-count=1 --pretty=format:"%h")
    dotfile log ${actualcommit}..${newcommit}
}

#Edita um arquivo e já submete a mudança
dot-edit() {
    ALT="0"
    TEMPFILE="$(mktemp)"
    ARQ=$1
    [ -L $1 ] && ARQ="$(readlink -e $1)"
    md5sum "$ARQ" >"$TEMPFILE" ; # Calcula MD5 antes da edição
    editor "$ARQ" ;              # Edita o arquivo
    md5sum -c "$TEMPFILE" >/dev/null 2>&1 || ALT="1"
    if [ "$ALT" == "1" ]; then
      MSG=""
      echo "Informe a razão do commit"
      read -r -p "MSG> " MSG
      [ "$MSG" == "" ] && MSG="Submissao em $(date)"
      dot-track "$ARQ" "$MSG"
    fi
    return $ALT
}

#Simplifica a visualização de logs
dot-log() {
    dotfile log "$@"
}

#Editor para arquivo de aliases
dot-alias() {
    # shellcheck disable=SC1090
    dot-edit ~/.bash_aliases || source ~/.bash_aliases
}

#Editor para arquivo de funções
dot-functions() {
    # shellcheck disable=SC1090
    dot-edit ~/.bash_functions || source ~/.bash_functions
}

#Carrega as modificações nos principais arquivos de funções
dot-reload() {
    # shellcheck disable=SC1090
    [ "$1" == ".bashrc" ] || source ~/dotfiles-tools/dotfiles_manager.bash
    # if [ -f ~/.bash_aliases ]; then
    #     # shellcheck disable=SC1090
    #     . ~/.bash_aliases
    # fi

    # if [ -f ~/.bash_functions ]; then
    #     # shellcheck disable=SC1090
    #     . ~/.bash_functions
    # fi
}

#Editor para arquivo de gerencia de dotfiles
dot-dot() {
    # shellcheck disable=SC1090
    dot-edit ~/dotfiles-tools/dotfiles_manager.bash || source ~/dotfiles-tools/dotfiles_manager.bash
}

#Lista todos os arquivos sobre a gerencia do dotfile-manager
dot-ls() {
    dotfile ls-files -v "$@"
}

#Desfaz um git add ou git rm
dot-unstage() {
    dotfile reset HEAD -- "$@"
}

#Desfaz alteracoes ainda nao comitadas
dot-undo() {
    dotfile checkout -- "$@"
}

#Desfaz apenas o ultimo commit
dot-uncommit() {
    dotfile revert HEAD "$@"
}

#Exibe o status do repositorio
dot-status() {
    dotfile status "$@"
}

#Executa um diff
dot-diff() {
    dotfile diff "$@"
}

#Autopull pode ser executada no login para carregar as novas ferramentas
dot-autopull() {
    #ping -c1 -W1 github.com >/dev/null 2>&1 && dot-pull
    dotfile pull
}

#Autopush pode ser executado no logout para enviar as modificações para o server
dot-autopush() {
    #ping -c1 -W1 github.com >/dev/null 2>&1 && dot-push
    dotfile push
}
