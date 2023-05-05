#!/bin/bash

# Definir la ruta del archivo JSON
config_file="/root/udp/config.json"

# Colores para imprimir texto en la consola
RED='\033[0;31m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Verificar que el archivo JSON exista
if [ ! -f "$config_file" ]; then
  echo -e "${RED}El archivo JSON no existe.${NC}"
  exit 1
fi

# Verificar que el comando "jq" esté instalado
if ! command -v jq &> /dev/null; then
  echo -e "${RED}El comando 'jq' no está instalado.${NC}"
  exit 1
fi

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
  if jq ".auth.pass = [\"$(echo $updated_passwords | sed 's/,/", "/g')\"]" "$config_file" > tmp.json && mv tmp.json "$config_file"; then
    echo -e "${BLUE}Contraseñas actualizadas correctamente.${NC}"
  else
    echo -e "${RED}No se pudo actualizar las contraseñas.${NC}"
    exit 1
  fi

  # Recargar el daemon de systemd y reiniciar el servicio
  if sudo systemctl daemon-reload && sudo systemctl restart udp-custom; then
    echo -e "${BLUE}Servicio reiniciado correctamente.${NC}"
  else
    echo -e "${RED}No se pudo reiniciar el servicio.${NC}"
    exit 1
  fi
}

# Func
