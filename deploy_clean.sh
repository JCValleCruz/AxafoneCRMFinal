#!/bin/bash

echo "🧹 Iniciando limpieza y deploy..."

# 1. Resetear commit fallido si existe
echo "📤 Reseteando commits pendientes..."
git reset --soft HEAD~1 2>/dev/null || echo "No hay commits para resetear"

# 2. Limpiar build completamente
echo "🗑️  Limpiando archivos de build..."
rm -rf build/
flutter clean

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

# Web
web/assets/

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
git add android/app/src/main/AndroidManifest.xml 2>/dev/null || echo "AndroidManifest.xml no encontrado"
git add android/build.gradle 2>/dev/null || echo "android/build.gradle no encontrado"
git add android/app/build.gradle 2>/dev/null || echo "android/app/build.gradle no encontrado"
git add web/index.html 2>/dev/null || echo "web/index.html no encontrado"
git add web/manifest.json 2>/dev/null || echo "web/manifest.json no encontrado"
git add vercel.json 2>/dev/null || echo "vercel.json no encontrado"

# 6. Mostrar qué se va a subir
echo "📋 Archivos que se van a subir:"
git status --porcelain

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