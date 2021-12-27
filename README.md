# dotfiles-tools

Conjunto de ferramentas essenciais para gerenciar dotfiles.

## O que são dotfiles

dotfiles são todos aqueles arquivos ocultos em seu $HOME e que são usados
para configurar suas ferramentas de trabalho.

Os arquivos abaixo são exemplos de dotfiles:

    .bashrc
    .profiles
    .vimrc
    .gitconfig

Sem uma ferramenta de gerência você terá arquivos independentes em todas as
máquinas e terá que gerência-los individualmente. Para maioria das pessoas isso
pode ser desejável ou não fazer diferença, mas para um nicho de pessoas este
controle é importante.

Se em algum momento no seu trabalho com o desktop, por exemplo, você sentiu falta
de um alias ou função que criou no notebook e vice-versa, ou se você  lida com
dezenas ou centenas de servidores e sentiu a falta daquele seu script especial que
resolve o problema com um comando pequeno mas que foi criado no desktop, então
este tipo de ferramenta (gerenciador de dotfiles) é importante para você.

## Pré-requisitos

(1) As máquinas onde esta ferramenta será usada precisa ter instalado as seguintes ferramentas acessíveis por linha de comandos:

* Git
* Curl
* Unzip

(2) Você deverá criar um repositório PRIVADO e vazio no Github que será onde você manterá sua coleção de dotfiles. É de lá que replicaremos os nossos dotfiles para todas as nossas máquinas.

(3) Este repositório deverá possuir uma chave de deploy (ssh-rsa ou outra) com permissão de escrita, para podermos mantê-lo atualizado. Você precisará gerar uma chave destas para cada máquina que desejar manter contato com este repositório (recomendável - consulte a seção **CHAVE DE DEPLOY NO GITHUB** para obter instruções de como proceder); ou copiar uma única chave privada para todas as máquinas (é melhor ter cuidado com esta abordagem).

Caso não queira usar o Github em favor de outro sistema remoto você pode editá-lo no arquivo ".dotfiles.conf", porém eu ainda não testei esta possibilidade, se quiser arriscar, por sua conta e risco me dê um retorno sobre os testes.

## Aviso 1: Um repositório várias máquinas

Você pode criar um único repositório de onde irá clonar em todas as suas estações
e servidores, de forma a compartilhar seus arquivos em todos os seus ambientes
de trabalho, no entanto eu ainda não implementei nenhum recurso para gerencia de
arquivos que precisem ser personalizado por máquina.

Como todos os arquivos não passa de lotes de comando shell, uma possibilidade é usar
comandos especificos em estruturas "if/then/fi. Como no exemplo abaixo em que um novo
diretório será adicionado ao PATH apenas na máquina "myserver".

    ```bash

    if [ "$HOSTNAME" == "myserver" ]; then
        PATH=$PATH:/opt/adminscripts
    fi

    ```

## Aviso 2: Arquivos com senhas

Ainda não implementei nenhum recurso para lidar com arquivos contendo "segredos",
chaves ssh, senhas etc, portanto não versione estes arquivos a menos que seu
repositório seja realmente privado e você tenha consciência dos riscos disto.

## CHAVE DE DEPLOY NO GITHUB

A forma mais segura de usar um repositório privado no Github é manter um par de chaves pub/priv para cada máquina que precisará acessa-lo. Isso permite que em caso de violação da credencial, você possa excluir a chave do repositório bloqueando apenas a a máquina comprometida.

(1) A partir da linha de comandos da máquina cliente use comando a seguir:

    ```bash
    ssh-keygen -t rsa
    ```

**OBS**: Informe um nome para o arquivo que identifique este repositório, isso evitará problemas de acesso a outros repositórios que você precise usar no futuro. ex: ~/.ssh/meusdotfiles

(2) Altere as permissões de acesso do arquivo de chaves criado

    ```bash
    chmod 0600 ~/.ssh/meusdotfiles
    ```

(3) Crie um arquivo ~/.ssh/config e adicione a seção abaixo:

    ```txt
    Host github.com-meusdotfiles
        Hostname github.com
        IdentityFile=~/.ssh/meusdotfiles

    ```

**OBS**: Altere as linhas acima conforme o nome do seu repositório e nome do arquivo de chave privada.

(4) Copie o conteúdo da sua chave pública (isso será usado no próximo passo)

    ```bash
    cat ~/.ssh/meusdotfiles.pub
    [SELECIONE E COPIE O CONTEUDO COMPLETO EXIBIDO]
    ```

(5) Adicione a chave a sessão "deploy Key" do seu repositório

O processo é detalhado na página oficial do Github <https://docs.github.com/pt/developers/overview/managing-deploy-keys#deploy-keys>. Consulte-o como referência absoluta sobre o procedimento, pois ele pode ter sido alterado e o passo a passo aqui descrito não refletir a verdade atual.

1 - Abra a seção "Settings" do seu repositório de dotfiles.
2 - Clique na aba "Deploy Keys"
3 - Clique no botão "Add deploy key"
4 - Defina um "title" (título) para a chave: Ex.: "Acesso via notebook velho"
5 - Cole a sua chave pública na caixa "Key"
6 - Marque a opção "Allow write access" para que esta máquina enviar atualizações
7 - Clique no botão "Add key"

(6) Valide o acesso e aceite a troca de chaves

    ```bash
    ssh git@github.com-meusdotfiles

    ```

**Obs:** Você verá uma mensagem como a mostrada abaixo após aceitar a troca de chaves:

    PTY allocation request failed on channel 0
    Hi seuusuario/meusdotfiles! You've successfully authenticated, but GitHub does not provide shell access.
    Connection to github.com closed.

## Instalação

Este processo considera que você já tem um repositório de dotfiles configurado
e você tenha criado um arquivo de configuração .dotfiles.conf (Copie dotfiles.template.conf e altere-o para refletir suas configurações)

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
