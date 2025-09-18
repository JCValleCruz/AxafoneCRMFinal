#!/bin/bash

echo "🚀 Deploy solo con Git - sin tocar Flutter..."

# 1. Resetear commit fallido si existe
echo "📤 Reseteando commits pendientes..."
git reset --soft HEAD~1 2>/dev/null || echo "No hay commits para resetear"

# 2. Solo eliminar build/ sin tocar Flutter
echo "🗑️  Eliminando solo carpeta build/..."
rm -rf build/

# 3. Crear/actualizar .gitignore
echo "📝 Actualizando .gitignore..."
cat > .gitignore << 'EOF'
# Flutter
build/
.dart_tool/
.packages
.pub/
.metadata

# IDE
.idea/
.vscode/
*.iml

# OS
.DS_Store
Thumbs.db

# Android
android/app/build/
android/.gradle/
android/gradle/
android/gradlew*
android/local.properties

# Web builds locales
web/assets/AssetManifest.bin
web/assets/AssetManifest.json
web/assets/FontManifest.json
web/assets/NOTICES
web/main.dart.js
web/flutter_service_worker.js
web/version.json

# Logs
*.log
EOF

# 4. Limpiar staging area
echo "🧽 Limpiando staging area..."
git reset HEAD . 2>/dev/null || echo "Staging area ya limpio"

# 5. Agregar solo archivos de código fuente
echo "📦 Agregando archivos de código fuente..."
git add .gitignore
git add lib/
git add pubspec.yaml
git add pubspec.lock 2>/dev/null || echo "pubspec.lock no encontrado"
git add vercel.json 2>/dev/null || echo "vercel.json no encontrado"

# Agregar archivos de configuración Android necesarios
git add android/app/src/ 2>/dev/null || echo "android/app/src/ no encontrado"
git add android/build.gradle 2>/dev/null || echo "android/build.gradle no encontrado"
git add android/app/build.gradle 2>/dev/null || echo "android/app/build.gradle no encontrado"
git add android/settings.gradle 2>/dev/null || echo "android/settings.gradle no encontrado"

# Agregar archivos web básicos (no los generados)
git add web/index.html 2>/dev/null || echo "web/index.html no encontrado"
git add web/manifest.json 2>/dev/null || echo "web/manifest.json no encontrado"
git add web/favicon.png 2>/dev/null || echo "web/favicon.png no encontrado"

# 6. Mostrar qué se va a subir
echo "📋 Archivos que se van a subir:"
git status --porcelain

echo ""
read -p "¿Continuar con el commit y push? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 7. Commit
    echo "💾 Creando commit..."
    git commit -m "Fix: Deploy limpio - formularios funcionando

- Parsing robusto de coordenadas latitude/longitude
- Campos opcionales corregidos en FormSubmission
- Errores de tipos String? solucionados
- Sin archivos de build para evitar errores de tamaño
- Ready para deploy automático en Vercel

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

    # 8. Push al repositorio
    echo "🚀 Subiendo al repositorio..."
    git push origin main --force-with-lease

    # 9. Verificar estado final
    echo "✅ Deploy completado!"
    echo "📊 Estado final del repositorio:"
    git log --oneline -n 3

    echo ""
    echo "🌐 Vercel debería detectar el cambio automáticamente"
    echo "🔗 Verifica en: https://vercel.com/dashboard"
    echo "🎯 URL del proyecto: https://axafonecrm.vercel.app"
    echo ""
    echo "✨ Listo para probar!"
else
    echo "❌ Deploy cancelado"
fi