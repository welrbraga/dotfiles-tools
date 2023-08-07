# dotfiles-tools

Conjunto de ferramentas básicas para gerenciar dotfiles.

## O que são dotfiles

dotfiles são todos aqueles arquivos ocultos em seu $HOME e que são usados para configurar suas ferramentas de trabalho.

Os arquivos abaixo são exemplos de dotfiles:

* .bashrc
* .profiles
* .vimrc
* .gitconfig

Sem uma ferramenta de gerência, você terá arquivos independentes em todas as máquinas e terá que gerência-los individualmente. Para maioria das pessoas isso pode ser desejável ou não fazer diferença, mas para pessoas que criam muitas funções e scripts personalizados para agilizar suas tarefas no terminal, este controle é importante.

Se, por exmplo, em algum momento no seu trabalho com o desktop, você sentiu falta de um alias ou função que criou no notebook e vice-versa, ou se você lida com dezenas ou centenas de servidores e sentiu a falta daquele seu script especial que resolve o problema com um comando pequeno mas que foi criado no desktop, então talvez você esteja precisando de um "gerenciador de dotfiles".

## Pré-requisitos

(1) As máquinas onde esta ferramenta será usada precisam as seguintes ferramentas já instaladas e acessíveis por linha de comandos:

* Git
* Curl
* Unzip

(2) Você deverá criar um repositório PRIVADO e vazio no Github que será onde você manterá sua coleção de dotfiles.

(3) O seu repositório de dotfiles deverá ser acessível da sua máquina e para isso você precisará exportar uma chave de deploy (ssh-rsa ou outra) com permissão de escrita para este repositório, ou ter uma chave ssh-rsa com acesso completo a sua conta Github.

### Aviso 1: Chave na conta ou chave de deploy no repositório

Normalmente acessamos o github por linha de comandos após o envio da parte "pública" de um par de chaves publicas no padrão RSA.

Há duas formas de se disponiblizar a sua chave pública para acesso aos repositórios no Github:

(1) Acesso total

A chave pode estar configurada na conta (Foto de Perfil > Settings > SSH and GPG keys > SSH keys > Add key) permitindo acesso a todos os seus repositórios.

Esta opção permite acesso total a seus repositórios, então utilize-a apenas se você for o único usuário da máquina, ou se confiar cegamente nos demais usuários.

(2) Acesso apenas a um repositório

A chave pode ser configurada para acesso exclusivo a um único repositório ({{Repositório}} > Settings > Deploy keys > Add deploy key).

Como esta opção permite acesso apenas ao repositório onde ela foi definida, é uma boa recomendação usa-la em máquinas compartilhadas por várias pessoas. Desta forma se alguém fizer algo de errado não destruirá a sua conta no Github e como você terá réplicas deste repositório em outras máquinas será fácil restaurá-lo novamente caso isso ocorra.

Consulte a seção **CHAVE DE DEPLOY NO GITHUB** para obter instruções de como criar sua chave.

### Aviso 2: Mas o Github... Pode ser outro!?

Caso não queira usar o Github para armazenar o seu repositório de dotfiles, você pode alterar isso no arquivo ".dotfiles.conf", porém eu ainda não testei esta possibilidade, se quiser arriscar, por sua conta e risco, me dê um retorno sobre os testes.

### Aviso 3: Um repositório, várias máquinas

O objetivo desta ferramenta é compartilhar arquivos dotfiles entre diversas máquinas, então, não há qualquer meio iplementado (ainda) para que determinado arquivo possa ser exclusivo em alguma máquina ou de um grupo.

Isso quer dizer que se você tem um arquivo com uma determinada configuração que deverá ser diferente das demais, este arquivo não deve ser versionado.

Ainda assim, na maioria dos casos este tipo de problema é contornável. Duas possibilidades que sugiro são:

#### Blocos condicionais

Como a maioria dos arquivos não passam de lotes de comando shell, uma possibilidade é usar comandos especificos em estruturas condicionais "if/then/fi". Como no exemplo abaixo em que um novo diretório será adicionado ao PATH apenas na máquina "myserver".

```bash
if [ "$HOSTNAME" == "myserver" ]; then
    PATH=$PATH:/opt/adminscripts
fi
```

#### Variáveis de ambiente

Uma alternativa mais simples que o uso de condicionais, viável em muitos casos, é o uso de variáveis de ambiente que retornem, por exemplo o nome da máquina.

Um exemplo disso é o arquivo de configuração SSH, se precisarmos de uma chave especifica de cada máquina usada para acesso. Neste caso a variável "%L" é convertida para o hostname da máquina antes de passar o parâmetro para a conexão.

```config
Host *.minhaempresa.com
  IdentityFile=~/.ssh/%L-minhaempresa_key
```

#### Links simbólicos

Quando isso não for possível, mas você ainda sim quiser manter uma versão do arquivo, talvez renomear o arquivo para algo personalizado e então criar um link simbólico com o nome original.

### Aviso 4: Arquivos com senhas

Não há nenhum recurso para lidar com arquivos contendo "segredos", chaves ssh, senhas etc, portanto - para sua segurança - não versione estes arquivos a menos que você saiba exatamente o que está fazendo e tenha consciência dos riscos disto.

## CHAVE DE DEPLOY NO GITHUB

Talvez você já tenha um par no seu diretório $HOME/.ssh e que provavelmente é usada para toda a sua conta Github, mas como já disse antes (vide a opção 2 do [Aviso 1: Chave na conta ou chave de deploy no repositório](#aviso-1-chave-na-conta-ou-chave-de-deploy-no-repositório)), a forma mais segura de usar um repositório privado no Github é manter um par de chaves pub/priv para cada repositório e para cada máquina que precisará acessá-lo.

Isso permite que em caso de violação da credencial, você possa excluir a chave do repositório bloqueando apenas aquela máquina comprometida, e que só tinha acesso ao repositório de dotfiles e não toda a sua conta. 

Vamos então criar uma chave exclusiva para acesso apenas ao repositório de dotfiles, em uma máquina que não seja a sua principal.

Lembrando que no Windows o procedimento a ser realizado é o mesmo, desde que você instale o Putty na máquina.

### Criando uma chave RSA

(1) A partir da linha de comandos da máquina cliente use os comandos a seguir:

```bash
ssh-keygen -t rsa -f $HOSTNAME-dotfiles
```

**OBS 1**: Por padrão uma chave RSA com 3072bits será criada, o que é suficiente para o nosso propósito.

**OBS 2**: Será pedido que você defina uma senha para este certificado, o que deve ser ignorado. Apenas tecle ENTER duas vezes para ignorar o pedido.

**OBS 3**: O nome do arquivo (neste exemplo "$HOSTNAME-dotfiles") pode ser qualquer coisa, mas eu sugiro que ele seja exclusivo e identifique a máquina onde você está (por isso a variável $HOSTNAME) e o repositório a ser acessado. Isso evitará problemas futuros, caso você necessite descredenciar alguma máquina.

(2) Se você não estiver no diretório "$HOME/.ssh", será necessário mover os arquivos gerados para lá.

(3) Se estiver no Linux, altere as permissões de acesso do arquivo de chaves criado

```bash
chmod 0600 ~/.ssh/$HOSTNAME-dotfiles
```

(3) Crie um arquivo ~/.ssh/config (caso não tenha) e adicione a seção abaixo:

```code
Host github.com-meusdotfiles
    Hostname github.com
    IdentityFile=~/.ssh/%L-dotfiles
```

**OBS**: Altere nas linhas acima o uso da variável "%L" e que será convertida no hostname da sua máquina, o que será útil, quando você versionar este arquivo para publicação em suas várias máquinas.

(4) Copie o conteúdo da sua chave pública (isso será usado no próximo passo)

```bash
cat ~/.ssh/$HOSTNAME-dotfiles.pub
[SELECIONE E COPIE O CONTEUDO COMPLETO EXIBIDO]
```

(5) Adicione a chave a sessão "deploy Key" do seu repositório

O processo é detalhado na página oficial do Github <https://docs.github.com/pt/developers/overview/managing-deploy-keys#deploy-keys>. Consulte-o como referência absoluta sobre o procedimento, pois ele pode ter sido alterado e o passo a passo aqui descrito não refletir a versão atual do Github.

1 - Abra a seção "Settings" do seu repositório de dotfiles.
2 - Clique na aba "Deploy Keys"
3 - Clique no botão "Add deploy key"
4 - Defina um "title" (título) para a chave: Ex.: "Acesso via notebook velho"
5 - Cole a sua chave pública na caixa "Key"
6 - Marque a opção "Allow write access" para que esta máquina enviar atualizações
7 - Clique no botão "Add key"

(6) Valide o acesso e aceite a troca de chaves

```bash
ssh -T git@github.com-meusdotfiles

```

Perceba que eu usei o nome definido no atributo "Host" do .ssh/config, ao invés do nome real do Github. Isso permitirá a conexão usando as configurações daquela seção.

**Obs:** Você verá uma mensagem como a mostrada abaixo após aceitar a troca de chaves:

```code
Hi seuusuario/meusdotfiles!
You've successfully authenticated, but GitHub does not provide shell access.
Connection to github.com closed.
```

## Atualização quando o ~/.ssh/config estiver corrompido

```config
# Configuração usada apenas para obter dotfiles
# em situações que a configuração do SSH esteja corrompida
# WBRAGA - 2023-08-07
#
# Use:
# GIT_SSH_COMMAND="ssh -F ~/.ssh/config-dotfiles" dotfile pull
#
Host github.com-dotfiles
      Hostname github.com
      IdentityFile=~/.ssh/%l-dotfiles_key
```

Baixe as atualizações e corrija o que causa o conflito para que o SSH volte a ser funcional.

## Instalação

Este processo considera que você já tem um repositório de dotfiles configurado
e você tenha criado um arquivo de configuração .dotfiles.conf (Copie dotfiles.template.conf e altere-o para refletir suas configurações)

Crie o arquivo de configuração

```bash
[ -f .dotfiles.conf ] || curl 'https://raw.githubusercontent.com/welrbraga/dotfiles-tools/master/dotfiles-tools/dotfiles.template.conf' --output .dotfiles.conf
```

**ATENÇÃO** Antes de prosseguir, edite o arquivo criado acima.

Execute o script de instalação

```bash
curl --silent 'https://raw.githubusercontent.com/welrbraga/dotfiles-tools/master/dot-install.sh'|bash
```

(1) Após o processo, arquivos dotfiles que não existiam nesta máquina, mas que estão no repositório, serão copiados.

(2) As funções passam a ser válidas a partir da sua próxima sessão de terminal, ou se você recarregar o seu .bashrc

```bash
source .bashrc
```

(3) Liste a situação atual do seu repositório de dotfiles

```bash
dot-status
```

(4) Caso haja arquivos equivalentes no repositório e em sua máquina, eles serão exibidos como "M" (modified).

Você pode desfazer a modificação local e usar a versão do repositório usando o comando dot-undo. Por exemplo para usar a versão do arquivo .bash_logout que está no repositório:

```bash
dot-undo .bash_logout
```

Ou para preservar e usar a versão que está nesta máquina, use o comando dot-track para que o arquivo seja versionado e passe a ser a versão oficial que será replicada em todas as suas outras máquinas. Por exemplo para manter o arquivo .vimrc desta máquina:

```bash
dot-track .vimrc "Versão do vimrc instalada no notebook"
```

## Teste em container

Isso não é necessário para nenhum usuário final. Este é apenas um container de teste com uma distribuição Linux simples usada para testes da ferramenta.

```bash
docker build --tag dotfiles . && docker run -ti --rm dotfiles /bin/bash
```
