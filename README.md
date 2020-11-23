# dotfiles-tools

Conjunto de ferramentas essenciais para gerenciar dotfiles.

# O que são dotfiles

dotfiles são todos aqueles arquivos ocultos em sem $HOME e que são usados
para configurar suas ferramentas de trabalho.

Os arquvios abaixo são exemplos de dotfiles:

    .bashrc
    .vimrc
    .gitconfig

Sem uma ferramenta de gerência você terá arquivos independentes em todas as
máquinas e terá que gerência-los individualmente. Para maioria das pessoas isso
pode ser desejável, ou não fazer diferença mas para um nicho de pessoas este
controle é importante.

Se em algum momento no seu trabalho com o desktop, por exemplo, você sentiu falta
de um alias ou função que criou no notebook e vice-versa, ou se você  lida com
dezenas ou centenas de servidores e sentiu a falta daquele seu script especial que
resolve o problema com um comando pequeno mas que foi criado no desktop, então
este tipo de ferramenta (gerenciador de dotfiles) é importante para você.

## Pré-requisitos

Você deverá criar um repositório PRIVADO e vazio no Github que será onde você manterá sua coleção de dotfiles. É de lá que replicaremos os nossos dotfiles para todas as nossas máquinas.

Este repositório deverá possuir uma chave de deploy (ssh-rsa ou outra) com permissão de escrita, para podermos mante-lo atualizado. Você precisará gerar uma chave destas para cada máquian que desejar manter contato com este repositório (sorry, é assim que o Git funciona).

Caso não queira usar o Github em favor de outro sistema remoto você pode editá-lo no arquivo ".dotfiles.conf"

Em um futuro não muito distante eu prometo arrumar isso. ;-)

## Aviso 1: Um repositório várias máquinas

Você pode criar um único repositório de onde irá clonar em todas as suas estações
e servidores, de forma a compartilhar seus arquivos em todos os seus ambientes
de trabalho, no entanto eu ainda não implementei nenhum recurso para gerencia de
arquivos que precisem ser personalizado por máquina.

## Aviso 2: Arquivos com senhas

Ainda não implementei nenhum recurso para lidar com arquivos contendo "segredos",
chaves ssh, senhas etc, portanto não versione estes arquivos a menos que seu
repositório seja realmente privado e você tenha consciência dos riscos disto.

## Instalação

Este processo considera que você já tem um repositório de dotfiles configurado
e você tenha criado um arquivo de configuração .dotfiles.conf (Copie dotfiles.template.conf e altere-o para refletir suas configurações)

curl --silent 'https://raw.githubusercontent.com/welrbraga/dotfiles-tools/master/dot-install.sh'|bash

(1) Após o processo, arquivos dotfiles que não existiam nesta máquina, mas que estão no repositório, serão copiados.

(2) As funções passam a ser válidas a partir da sua próxima sessão de terminal, ou se você recarregar o seu .bashrc

  source .bashrc

(3) Liste a situação atual do seu repositório de dotfiles

  dot-status

(4) Caso haja arquivos equivalentes no repositório e em sua máquina, eles serão exibidos como "M" (modified).

Você pode desfazer a modificação local e usar a versão do repositório usando o comando dot-undo. Por exemplo para usar a versão do arquivo .bash_logout que está no repositório:

  dot-undo .bash_logout

Ou para preservar e usar a versão que está nesta máquina, use o comando dot-track para que o arquivo seja versionado e passe a ser a versão oficial que será replicada em todas as suas outras máquinas. Por exemplo para manter o arquivo .vimrc desta máquina:

  dot-track .vimrc "Versão do vimrc instalada no notebook"


## Teste em container

docker build --tag dotfiles . && docker run -ti --rm dotfiles /bin/bash ./teste-install.sh
