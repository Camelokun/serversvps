#!/bin/bash

# Definir la ruta del archivo JSON
config_file="/root/udp/config.json"

# Colores para imprimir texto en la consola
RED='\033[0;31m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Función para agregar una contraseña
function add_password() {
  # Leer las nuevas contraseñas desde el usuario
  echo -e "${BLUE}Ingrese las nuevas contraseñas separadas por comas: ${NC}"
  read new_passwords

  # Convertir las contraseñas a un array
  IFS=',' read -ra passwords_arr <<< "$new_passwords"

  # Leer las contraseñas existentes desde el archivo JSON
  existing_passwords=$(jq -r '.auth.pass | join(",")' "$config_file")

  # Concatenar las contraseñas existentes con las nuevas
  updated_passwords="$existing_passwords,${passwords_arr[@]}"

  # Actualizar el archivo JSON con las nuevas contraseñas
  jq ".auth.pass = [\"$(echo $updated_passwords | sed 's/,/", "/g')\"]" "$config_file" > tmp.json && mv tmp.json "$config_file"

  # Confirmar que se actualizaron las contraseñas correctamente
  if [ "$?" -eq 0 ]; then
    echo -e "${BLUE}Contraseñas actualizadas correctamente.${NC}"
  else
    echo -e "${RED}No se pudo actualizar las contraseñas.${NC}"
  fi

  # Recargar el daemon de systemd y reiniciar el servicio
  sudo systemctl daemon-reload
  sudo systemctl restart udp-custom
}

# Función para eliminar una contraseña
function delete_password() {
  # Leer las contraseñas existentes desde el archivo JSON
  existing_passwords=$(jq -r '.auth.pass | join(",")' "$config_file")

  # Leer la contraseña que se quiere eliminar desde el usuario
  echo -e "${ORANGE}Ingrese la contraseña que desea eliminar: ${NC}"
  read password_to_delete

  # Eliminar la contraseña del array de contraseñas
  updated_passwords=$(echo "$existing_passwords" | sed "s/$password_to_delete//g;s/,,/,/g;s/^,//;s/,$//")

  # Actualizar el archivo JSON con las nuevas contraseñas
  jq ".auth.pass = [\"$(echo $updated_passwords | sed 's/,/", "/g')\"]" "$config_file" > tmp.json && mv tmp.json "$config_file"

  # Confirmar que se eliminó la contraseña correctamente
  if [ "$?" -eq 0 ]; then
    echo -e "${ORANGE}Contraseña eliminada correctamente.${NC}"
  else
    echo -e "${RED}No se pudo eliminar la contraseña.${NC}"
  fi

  # Recargar el daemon de systemd y reiniciar el servicio
  sudo systemctl daemon-reload
  sudo systemctl restart udp-custom
}
