#!/bin/bash

# Verificar si el usuario tiene permisos de sudo
if [[ $(sudo -n true 2>&1) ]]; then
    echo "Este script debe ejecutarse con permisos de sudo."
    exit 1
fi

# Verificar si la configuración de ssh ya existe antes de modificarla
if grep -q 'prohibir-contraseña' /etc/ssh/sshd_config; then
    sudo sed -i 's/prohibir-contraseña/sí/g' /etc/ssh/sshd_config
fi

if grep -q 'sin-contraseña' /etc/ssh/sshd_config; then
    sudo sed -i 's/sin-contraseña/sí/g' /etc/ssh/sshd_config
fi

if grep -q '#PermitRootLogin' /etc/ssh/sshd_config; then
    sudo sed -i 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
fi

if ! grep -q 'Autenticación de contraseña' /etc/ssh/sshd_config; then
    echo 'Autenticación de contraseña sí' | sudo tee -a /etc/ssh/sshd_config > /dev/null
fi

if grep -q 'PasswordAuthentication no' /etc/ssh/sshd_config || grep -q '#PasswordAuthentication no' /etc/ssh/sshd_config; then
    sudo sed -i 's/#\{0,1\}PasswordAuthentication no/PasswordAuthentication sí/g' /etc/ssh/sshd_config
fi

# Reiniciar el servicio ssh
sudo service ssh restart

# Configurar el firewall
sudo iptables -F
sudo iptables -A INPUT -p tcp --dport 81 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -P INPUT DROP

# Guardar la configuración del firewall
sudo apt-get install iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload
