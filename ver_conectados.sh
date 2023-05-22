                                           
#!/bin/bash

while true; do
  echo "BIENVENIDO AL MENÚ PARA VER CONECTADOS"
  echo "Seleccione una opción:"
  echo "1. Ver conectados en el puerto 80"
  echo "2. Ver conectados en el puerto 443"
  echo "3. Salir"

  read -p "Opción: " opcion

  case $opcion in
    1)
      PSIPHON_PORT_80=$(sudo netstat -tn | awk '$4 ~ /:80$/ {print>      echo "CONEXIONES EN EL PUERTO 80 DE PSIPHON: $PSIPHON_PORT_8>      ;;
    2)                                                                   PSIPHON_PORT_443=$(sudo netstat -tn | awk '$4 ~ /:443$/ {pri>      echo "CONEXIONES EN EL PUERTO 443 DE PSIPHON: $PSIPHON_PORT_>      ;;
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
