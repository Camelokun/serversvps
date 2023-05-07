# Generar una nueva contraseña para root
sudo passwd root

# Modificar la configuración de SSH para habilitar la autenticación por contraseña y permitir el inicio de sesión como root
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Reiniciar el servicio SSH para que se apliquen los cambios
sudo systemctl restart ssh
