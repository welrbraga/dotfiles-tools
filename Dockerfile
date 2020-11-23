FROM debian

RUN apt-get update && apt-get install git curl unzip -y

COPY home-teste /root
COPY dotfiles-tools /root/dotfiles-tools

WORKDIR /root
RUN chmod 700 .ssh && chmod 600 .ssh/* && chmod +x teste-install.sh
