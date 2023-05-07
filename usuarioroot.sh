#!/bin/bash

echo "Ingrese el nombre del nuevo usuario:"
read username

adduser $username

echo "Ingrese la nueva contraseña para el usuario:"
passwd $username
