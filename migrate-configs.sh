#!/bin/bash

# Ruta al directorio de los microservicios
SERVICES_DIR="../ecommerce-microservice-backend-app"

# Ruta destino (donde estás parado)
CONFIG_REPO="."

# Iterar sobre cada carpeta de servicio
for SERVICE in api-gateway order-service product-service shipping-service user-service payment-service favourite-service proxy-client; do
  RESOURCE_DIR="$SERVICES_DIR/$SERVICE/src/main/resources"

  if [ ! -d "$RESOURCE_DIR" ]; then
    echo " No existe $RESOURCE_DIR, se omite $SERVICE"
    continue
  fi

  echo " Procesando $SERVICE..."

  declare -A FILE_MAP=(
    ["application.yml"]="$SERVICE.yml"
    ["application-dev.yml"]="$SERVICE-dev.yml"
    ["application-prod.yml"]="$SERVICE-prod.yml"
    ["application-stage.yml"]="$SERVICE-stage.yml"
  )

  for ORIG in "${!FILE_MAP[@]}"; do
    SRC="$RESOURCE_DIR/$ORIG"
    DEST="$CONFIG_REPO/${FILE_MAP[$ORIG]}"

    if [ -f "$SRC" ]; then
      cp "$SRC" "$DEST"
      echo "   Copiado: $SRC → $DEST"
    else
      echo "   No encontrado: $SRC"
    fi
  done
done

echo -e "\n Todos los archivos encontrados fueron copiados a $CONFIG_REPO"
