#!/bin/bash
# Launch script para Debian 8 - Jessie
# Criado pela Estabillis por Daniel Ginês
#
sudo apt-get update
sudo apt-get dist-upgrade -y
echo "copiando o projeto"
sudo git clone https://github.com/Estabilis/aws-launch-debian8.git
echo "atualizando o repositorio do Debian 8 - Jessie"
sudo rm /etc/apt/sources.list.d/backports.list
sudo rm /etc/apt/sources.list
sudo cp aws-launch-debian8/unix-conf/sources-list.conf /etc/apt/sources.list 
sudo apt-get update
echo "atualizando o sistema"
sudo apt-get dist-upgrade -y
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
echo "atualizar o arquivo de configuracoes do zabbix-agent"
sudo cat aws-launch-debian8/zabbix-conf/zabbix_agentd.conf >> /etc/zabbix/zabbix_agentd.conf
echo "ajustes no .bashrc - history"
sudo cat aws-launch-debian8/unix-conf/bashrc.conf >> /root/.bashrc
sudo cat aws-launch-debian8/unix-conf/bashrc.conf >> /home/admin/.bashrc
sudo cat aws-launch-debian8/unix-conf/bashrc.conf >> /etc/skel/.bashrc
echo "alterando o timezone para America/Sao_Paulo"
# fonte - https://www.illucit.com/en/linux/timezone-in-debian-9-stretch/
sudo echo "America/Sao_Paulo" > /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata