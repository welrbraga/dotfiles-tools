FROM debian

RUN apt-get update && apt-get install git -y

COPY dotfiles-tools /root/dotfiles-tools
COPY teste.dotfiles.conf /root/.dotfiles.conf

WORKDIR /root
COPY teste-install.sh .
RUN chmod +x teste-install.sh
