#!/bin/bash

echo "🚀 Configurando Axafone CRM Flutter Web..."

# Instalar dependencias
echo "📦 Instalando dependencias..."
flutter pub get

# Generar archivos de código
echo "🔨 Generando archivos de código..."
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "✅ Configuración completada!"
echo ""
echo "Para ejecutar la aplicación:"
echo "flutter run -d chrome"
echo ""
echo "Para abrir en VS Code:"
echo "code ."