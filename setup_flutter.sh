#!/bin/bash

# Script para instalar Flutter en Vercel
echo "🚀 Configurando Flutter para Vercel..."

# Verificar si Flutter ya está instalado
if command -v flutter &> /dev/null; then
    echo "✅ Flutter ya está instalado"
    flutter --version
    exit 0
fi

# Crear directorio temporal
cd /tmp

# Descargar Flutter
echo "📥 Descargando Flutter..."
wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz

# Extraer Flutter
echo "📦 Extrayendo Flutter..."
tar xf flutter_linux_3.16.0-stable.tar.xz

# Agregar Flutter al PATH
export PATH="$PATH:/tmp/flutter/bin"

# Verificar instalación
echo "🔍 Verificando instalación..."
flutter --version

# Deshabilitar analytics
flutter config --no-analytics

# Pre-descargar dependencies web
flutter precache --web

echo "✅ Flutter configurado correctamente"