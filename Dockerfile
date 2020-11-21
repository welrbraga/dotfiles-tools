FROM debian

RUN apt-get update && apt-get install git -y

COPY dotfiles-tools /root/dotfiles-tools

WORKDIR /root
COPY teste-install.sh .
RUN chmod +x teste-install.sh
