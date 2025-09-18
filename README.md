# Axafone CRM - Flutter Web





## 🚀 Características Principales

### ✨ Diseño Elegante y Sobrio
- **Tipografía**: Ubuntu Sans en toda la aplicación
- **Colores**: Paleta neutra con grises elegantes y toques sutiles de rojo
- 
- **UI**: Diseño minimalista con cards, bordes suaves y elementos limpios
- **Responsive**: Optimizado para web, tablets y dispositivos móviles

### 🔐 Sistema de Autenticación
- Login seguro con validación de credenciales
- Splash screen con animaciones suaves
- Gestión de sesiones persistente con SharedPreferences
- Navegación automática basada en roles de usuario

### 👥 Gestión de Roles
- **COMERCIAL**: Acceso a formularios y búsqueda de clientes
- **JEFE_EQUIPO**: Funciones de comercial + gestión de equipo y reportes
- **ADMINISTRADOR**: Acceso completo al sistema + gestión global

### 📋 Funcionalidades Comerciales
- Formularios comerciales paso a paso para captación y fidelización
- Búsqueda avanzada de clientes por CIF y nombre de empresa
- Edición de información existente de clientes
- Campos específicos según el tipo de comercial (captación/fidelización)

### 📊 Sistema de Reportes
- Generación de reportes por rango de fechas
- Estadísticas visuales con gráficos
- Exportación de datos en diferentes formatos
- Reportes globales para administradores

### 👨‍💼 Gestión de Usuarios
- Creación de nuevos comerciales
- Asignación de equipos y roles
- Cambio de contraseñas
- Gestión jerárquica de equipos

## 🏗️ Arquitectura Técnica

### Estructura del Proyecto
```
lib/
├── core/
│   ├── constants/         # Colores, temas y constantes
│   └── services/          # Servicios API y sesiones
├── features/
│   ├── auth/             # Autenticación y sesiones
│   ├── commercial/       # Menú comercial
│   ├── jefe/            # Menú jefe de equipo
│   ├── admin/           # Panel de administración
│   ├── forms/           # Formularios comerciales
│   ├── clients/         # Búsqueda de clientes
│   └── reports/         # Sistema de reportes
└── shared/
    ├── models/          # Modelos de datos
    └── widgets/         # Widgets reutilizables
```

### Tecnologías Utilizadas
- **Flutter Web**: Framework principal
- **Provider**: Gestión de estado
- **HTTP**: Cliente para API REST
- **SharedPreferences**: Almacenamiento local
- **Google Fonts**: Tipografía Ubuntu Sans
- **JSON Serialization**: Modelos de datos
- **Flutter ScreenUtil**: Diseño responsive

### Conexión API
- **Backend**: `https://axafonecrm.vercel.app/api`
- **Base de datos**: MariaDB
- **Autenticación**: Login con email/contraseña
- **Endpoints principales**:
  - `/login` - Autenticación
  - `/users` - Gestión de usuarios
  - `/forms` - Formularios comerciales
  - `/reports` - Reportes

## 🎨 Guía de Diseño

### Paleta de Colores
- **Primary**: `#2C2C2E` (Gris muy oscuro)
- **Secondary**: `#48484A` (Gris medio)
- **Background**: `#FFFFFF` (Blanco puro)
- **Surface**: `#FAFAFA` (Gris muy claro)
- **Accent**: `#DC3545` (Rojo elegante - usado con moderación)

### Principios de Diseño
1. **Simplicidad**: Interfaces limpias sin elementos innecesarios
2. **Legibilidad**: Tipografía clara con jerarquía visual
3. **Accesibilidad**: Contrastes adecuados y navegación intuitiva
4. **Consistencia**: Elementos UI uniformes en toda la app

## 📱 Pantallas Implementadas

### Autenticación
- **Splash Screen**: Pantalla de carga con animaciones
- **Login**: Formulario de acceso con validaciones
- **Change Password**: Cambio seguro de contraseñas

### Menús por Rol
- **Comercial Menu**: Acceso a formularios y búsqueda
- **Jefe Menu**: Gestión de equipo y reportes
- **Admin Menu**: Panel completo de administración

### Formularios
- **Form Screen**: Formulario multi-paso para datos comerciales
- **Search Client**: Búsqueda avanzada de clientes
- **Add Comercial**: Creación de nuevos usuarios

### Reportes
- **Reports Screen**: Generación y visualización de reportes
- **Global Reports**: Reportes para administradores

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK 3.9.2+
- Dart SDK 3.0+
- Navegador web moderno

### Instalación
1. Clonar el repositorio
2. Instalar dependencias:
   ```bash
   flutter pub get
   ```
3. Generar archivos de código:
   ```bash
   flutter packages pub run build_runner build
   ```
4. Ejecutar en web:
   ```bash
   flutter run -d chrome
   ```

### Configuración
La aplicación se conecta automáticamente a la API en `axafonecrm.vercel.app`. No se requiere configuración adicional.

## 🔧 Dependencias Principales

```yaml
dependencies:
  flutter: sdk
  http: ^1.1.0              # Cliente HTTP
  provider: ^6.1.1          # Gestión de estado
  shared_preferences: ^2.2.2 # Almacenamiento local
  google_fonts: ^6.1.0      # Tipografía Ubuntu Sans
  json_annotation: ^4.8.1   # Serialización JSON
  flutter_screenutil: ^5.9.0 # Diseño responsive

dev_dependencies:
  build_runner: ^2.4.7      # Generación de código
  json_serializable: ^6.7.1 # Serialización JSON
  flutter_lints: ^5.0.0     # Linting
```

## 📋 Funcionalidades Completadas

### ✅ Autenticación
- [x] Splash screen con animaciones
- [x] Login con validación
- [x] Gestión de sesiones
- [x] Cambio de contraseñas
- [x] Navegación por roles

### ✅ Formularios Comerciales
- [x] Formulario multi-paso
- [x] Validaciones en tiempo real
- [x] Campos específicos por tipo
- [x] Guardado en API

### ✅ Búsqueda de Clientes
- [x] Búsqueda por CIF y nombre
- [x] Listado de resultados
- [x] Edición de clientes existentes

### ✅ Gestión de Usuarios
- [x] Menús específicos por rol
- [x] Creación de comerciales
- [x] Asignación de equipos

### ✅ Sistema de Reportes
- [x] Reportes por fecha
- [x] Estadísticas visuales
- [x] Reportes globales

## 🌟 Características Destacadas

1. **Diseño Profesional**: UI limpia y moderna inspirada en aplicaciones empresariales
2. **Arquitectura Escalable**: Estructura modular fácil de mantener y expandir
3. **Responsive Design**: Funciona perfectamente en cualquier tamaño de pantalla
4. **Tipografía Elegante**: Ubuntu Sans para una experiencia visual superior
5. **Navegación Intuitiva**: Flujos de usuario optimizados para productividad
6. **Validaciones Robustas**: Validación completa de formularios y datos
7. **Gestión de Estados**: Manejo eficiente del estado de la aplicación
8. **Conexión API Estable**: Integración sólida con el backend existente

## 🚀 Próximas Mejoras

- [ ] Notificaciones push
- [ ] Modo offline
- [ ] Exportación avanzada de reportes
- [ ] Dashboard con métricas en tiempo real
- [ ] Sistema de permisos granular
- [ ] Búsqueda con filtros avanzados
- [ ] Integración con mapas para geolocalización

---

**Desarrollado con ❤️ usando Flutter Web**

*Una réplica elegante y moderna de la app Android Kotlin original, optimizada para uso web y multiplataforma.*
