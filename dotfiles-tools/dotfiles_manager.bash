#Funções para gerencia dos dotfiles

echo "# Carregando funções de controle de dotfiles"

alias dotfile='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

#Registra a mudança em um arquivo dotfile
dot_track() {
    dotfile add "$1"
    dotfile commit -m "$2"
}

#Lista os arquivos modificados no ultimo commit
dot_lastchange() {
    dotfile show --name-status --pretty=""
}

#Submete as mudanças ao repositório
dot_push() {
    dotfile push
}

#Obtem mas atualizações do repositório
dot_pull() {
    dotfile pull
}

#Edita um arquivo e já submete a mudança
dot_edit() {
    ALT="0"
    TEMPFILE=`tempfile`
    ARQ=$1
    [ -L $1 ] && ARQ="`readlink -e $1`"
    md5sum "$ARQ" >"$TEMPFILE" ; #Calcula MD5 antes da edição
    editor "$ARQ" ;                        #Edita o arquivo
    md5sum -c "$TEMPFILE" >/dev/null 2>&1 || ALT="1"
    if [ "$ALT" == "1" ]; then
	MSG=""
	echo "Informe a razão do commit"
	read -p "MSG> " MSG
	[ "$MSG" == "" ] && MSG="Submissao em `date`"
	dot_track "$ARQ" "$MSG"
    fi
    return $ALT
}

#Simplifica a visualização de logs
dot_log() {
    dotfile log
}

#Editor para arquivo de aliases
dot_alias() {
    dot_edit ~/.bash_aliases || source ~/.bash_aliases
}


#Editor para arquivo de funções
dot_functions() {
    dot_edit ~/.bash_functions || source ~/.bash_functions
}

#Carrega as modificações nos principais arquivos de funções
dot_reload() {
    source ~/.bash_aliases
    source ~/.bash_functions
    source ~/dotfiles-tools/dotfiles_manager.bash
}

#Editor para arquivo de gerencia de dotfiles
dot_dot() {
    dot_edit ~/dotfiles-tools/dotfiles_manager.bash || source ~/dotfiles-tools/dotfiles_manager.bash
}

#Lista todos os arquivos sobre a gerencia do dotfile-manager
dot_ls() {
    dotfile ls-files -v
}

#Desfaz um git add ou git rm
dot_unstage() {
    dotfile reset HEAD -- $1
}

#Desfaz alteracoes ainda nao comitadas
dot_undo() {
    dotfile checkout -- $1
}

#Desfaz apenas o ultimo commit
dot_rowback() {
    dotfile revert HEAD
}

#Exibe o status do repositorio
dot_status() {
    dotfile status
}

#Executa um diff
dot_diff() {
    dotfile diff $1
}

#Autopull pode ser executada no login para carregar as novas ferramentas
dot_autopull() {
    ping -c 1 git.github.com >/dev/null 2>&1 && dot_pull
}

#Autopush pode ser executado no logout para enviar as modificações para o server
dot_autopush() {
    ping -c 1 git.github.com >/dev/null 2>&1 && dot_push
}

