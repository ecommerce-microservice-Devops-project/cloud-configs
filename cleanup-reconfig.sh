#!/bin/bash

# Rutas relativas desde el directorio actual
BASE_DIR="../ecommerce-microservice-backend-app"
SERVICES=("api-gateway" "order-service" "payment-service" "product-service" "shipping-service" "user-service" "favourite-service" "proxy-client")

for SERVICE in "${SERVICES[@]}"; do
  CONFIG_PATH="$BASE_DIR/$SERVICE/src/main/resources"

  if [ -d "$CONFIG_PATH" ]; then
    echo "Limpiando configuración local en $SERVICE..."

    # Borrar los archivos de configuración por perfil
    rm -f "$CONFIG_PATH/application-dev.yml"
    rm -f "$CONFIG_PATH/application-prod.yml"
    rm -f "$CONFIG_PATH/application-stage.yml"

    # Reescribir application.yml mínimo
    cat > "$CONFIG_PATH/application.yml" <<EOF
spring:
  application:
    name: ${SERVICE,,}
  config:
    import: \${SPRING_CONFIG_IMPORT:optional:configserver:http://cloud-config:9296}
  profiles:
    active: dev
EOF

    echo "Limpieza y reconfiguración completada en $SERVICE"
  else
    echo "Ruta no encontrada: $CONFIG_PATH"
  fi
done
