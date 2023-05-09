#!/bin/bash

# Pedir una contraseña para instalar el script
echo -n -e "\e[6;30;42mIngrese la contraseña para abrir el scrip: \e[0m"
read password

# Verificar si la contraseña es correcta
if [ "$password" != "JESUS" ]; then
  echo -e "\e[1m\e[31mLa contraseña es incorrecta. Valiste verga perro.\e[0m"
  exit 1
fi

# Definir la ruta del archivo JSON
config_file="/root/udp/config.json"

# Función para mostrar las contraseñas existentes
function show_passwords() {
  # Leer las contraseñas desde el archivo JSON
  passwords=$(jq -r '.auth.pass | join(", ")' "$config_file")

  # Mostrar las contraseñas al usuario
  echo -e "\n\e[6;30;42mContraseñas existentes:\e[0m"
  echo -e "\e[1m$passwords\e[0m"
}

# Función para agregar una contraseña
function add_password() {
  # Leer las nuevas contraseñas desde el usuario
  echo -e "\n\e[6;30;42mIngrese las nuevas contraseñas separadas por comas: \e[0m"
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
    echo -e "\n\e[6;30;42mContraseñas actualizadas correctamente.\e[0m"
  else
    echo -e "\n\e[1m\e[31mNo se pudo actualizar las contraseñas.\e[0m"
  fi

  # Recargar el daemon de systemd y reiniciar el servicio
  sudo systemctl daemon-reload
  sudo systemctl restart udp-custom
}

function delete_password() {
  # Leer las contraseñas existentes desde el archivo JSON
  existing_passwords=$(jq -r '.auth.pass | join(",")' "$config_file")

  # Leer la contraseña que se quiere eliminar desde el usuario
  echo -e "\n\e[6;30;42mIngrese la contraseña que desea eliminar:\e[0m"
  read password_to_delete

  # Eliminar la contraseña del array de contraseñas
  updated_passwords=$(echo "$existing_passwords" | sed "s/$password_to_delete//g;s/,,/,/g;s/^,//;s/,$//")

  # Actualizar el archivo JSON con las nuevas contraseñas
  jq ".auth.pass = [\"$(echo $updated_passwords | sed 's/,/", "/g')\"]" "$config_file" > tmp.json && mv tmp.json "$config_file"

  # Confirmar que se eliminó la contraseña correctamente
  if [ "$?" -eq 0 ]; then
    echo -e "\e[1m\e[32mContraseña eliminada correctamente.\e[0m"
  else
    echo -e "\e[1m\e[31mNo se pudo eliminar la contraseña.\e[0m"
  fi

  # Recargar el daemon de systemd y reiniciar el servicio
  sudo systemctl daemon-reload
  sudo systemctl restart udp-custom
}

# Mostrar el menú de opciones al usuario

while true; do

  echo -e "\n\e[5m\033[1;100m𝗠𝗲𝗻ú 𝗱𝗲 𝗼𝗽𝗰𝗶𝗼𝗻𝗲𝘀:\033[0m"

  echo -e "\e[1m1. 𝗠𝗼𝘀𝘁𝗿𝗮𝗿 𝗰𝗼𝗻𝘁𝗿𝗮𝘀𝗲ñ𝗮𝘀 𝗲𝘅𝗶𝘀𝘁𝗲𝗻𝘁𝗲𝘀\e[0m"

  echo -e "\e[1m2. 𝗔𝗴𝗿𝗲𝗴𝗮𝗿 𝘂𝗻𝗮 𝗰𝗼𝗻𝘁𝗿𝗮𝘀𝗲ñ𝗮\e[0m"

  echo -e "\e[1m3. 𝗘𝗹𝗶𝗺𝗶𝗻𝗮𝗿 𝘂𝗻𝗮 𝗰𝗼𝗻𝘁𝗿𝗮𝘀𝗲ñ𝗮\e[0m"

  echo -e "\e[1m4. 𝗦𝗮𝗹𝗶𝗿\e[0m"

  # Leer la opción del usuario

  read -p "Ingrese una opción: " option

  case $option in

    1) show_passwords;;

    2) add_password;;

    3) delete_password;;

    4) exit;;

    *) echo -e "\e[1m\e[31mOpción inválida.\e[0m";;

  esac

done


 
