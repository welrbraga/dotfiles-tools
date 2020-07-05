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

Você deverá criar um repositório vazio no Github que será onde você manterá
sua coleção de dotfiles, é de lá que replicaremos os nossos dotfiles para todas
as nossas máquinas.

No momento a obrigatoriedade do Github está "hardcoded" então se vc não gostar
disso terá que editar o sistema para definir o seu próprio serviço de repositórios
git (no momento, linhas 42 e 43 do arquivo dotfiles_install.bash).
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

1 - Clone este repositório em algum lugar temporário na sua máquina

    cd /tmp
    git clone https://github.com/welrbraga/dotfiles-tools.git
    cd dotfiles-tools

2 - Copie somente a pasta dotfiles para dentro do seu home

    cp -r dotfiles-tools $HOME

3 - Edite o arquivo dotfiles-tools/dotfiles.conf e altere os valores das
variáveis que façam menção ao seu repositório de dotfiles.

    vim dotfiles-tools/dotfiles.conf

4 - Carregue o arquivo de instalação em seu ambiente atual (você não deve executá-lo).
Observe que você não deve executá-lo, mas carrega-lo com o comando source.

    source dotfiles-tools/dotfiles_install.bash

5 - Caso você não tenh a seu repositório de dotfiles ainda (é a primeira máquina que
vocÊ está instalando), então execute a função de instalação:

    dot-install

5.1 Caso já tenha a função instalada e outras máquinas e está fazendo a replicação
da configuração em uma nova máquina então execute a função de replicação:

    dot-replicate

6 - As funções passam a ser válidas a partir da sua próxima sessão de terminal, ou
se você usar o comando reload

    dot-reload


