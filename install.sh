#!/bin/bash
# Launch script para Debian 8 - Jessie
# Criado pela Estabillis por Daniel Ginês
#
echo "atualizando o repositorio do Debian 8 - Jessie"
sudo rm /etc/apt/sources.list.d/backports.list
sudo rm /etc/apt/sources.list
sudo -s cat <<EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian jessie main contrib non-free
deb-src http://deb.debian.org/debian jessie main contrib non-free

deb http://deb.debian.org/debian-security/ jessie/updates main contrib non-free
deb-src http://deb.debian.org/debian-security/ jessie/updates main contrib non-free

deb http://deb.debian.org/debian jessie-updates main contrib non-free
deb-src http://deb.debian.org/debian jessie-updates main contrib non-free
EOF
sudo apt-get update
echo "atualizando o sistema"
sudo apt-get upgrade -y
sudo apt-get autoremove -y 
echo "permitir que o apt use https"
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
echo "instalar pacotes adicionais para gestao"
sudo apt-get install -y nmap htop vim dbus sysstat
echo "instalar o zabbix-agent"
wget https://repo.zabbix.com/zabbix/4.0/debian/pool/main/z/zabbix-release/zabbix-release_4.0-3+jessie_all.deb
sudo dpkg -i zabbix-release_4.0-3+jessie_all.deb
sudo apt update
sudo apt -y install zabbix-agent
# fonte - https://stackoverflow.com/questions/4879025/creating-files-with-some-content-with-shell-script
echo "atualizar o arquivo de configuracoes do zabbix-agent"
sudo bash -c cat <<EOF > /etc/zabbix/zabbix_agentd.conf
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
LogRemoteCommands=1
Server=<<IP-SERVIDOR-PROXY>>
ServerActive=<<IP-SERVIDOR-PROXY>>
Hostname=<<HOSTNAME>>
AllowRoot=1
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF
echo "ajustes no .bashrc - history"
# rm /home/admin/.bashrc
# sudo rm /root/.bashrc
sudo bash -c cat <<EOF > /root/.bashrc
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
EOF
# fonte - https://www.illucit.com/en/linux/timezone-in-debian-9-stretch/
sudo echo "America/Sao_Paulo" > /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata