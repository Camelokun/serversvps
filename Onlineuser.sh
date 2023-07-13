#!/bin/bash

while true; do
  echo "SCRIPT PARA VER CONECTADOS ONLINE"
  echo "USUARIOS ONLINE EN PUERTO 80"
  echo "USUARIOS ONLINE EN PUERTO 443"
  echo "Seleccione una opción:"
  echo "1. Ver conectados en el puerto 80"
  echo "2. Ver conectados en el puerto 443"
  echo "3. Salir"

  read -p "Opción: " opcion

  case $opcion in
    1)
      PORT_80_USERS=$(sudo netstat -tn | awk '$4 ~ /:80$/ {print $5}' | cut -d: -f1 | sort | uniq -c | wc -l)
      echo "CONEXIONES EN EL PUERTO 80: $PORT_80_USERS"
      ;;
    2)
      PORT_443_USERS=$(sudo netstat -tn | awk '$4 ~ /:443$/ {print $5}' | cut -d: -f1 | sort | uniq -c | wc -l)
      echo "CONEXIONES EN EL PUERTO 443: $PORT_443_USERS"
      ;;
    3)
      echo "Saliendo del script..."
      break
      ;;
    *)
      echo "Opción inválida"
      ;;
  esac

  echo
done
