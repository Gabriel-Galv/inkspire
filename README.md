# 📚 Inkspire

Aplicación mobile para descubrir y gestionar tu experiencia de lectura.

## 🎯 Objetivo

Permitir a los usuarios descubrir nuevos libros, guardarlos en favoritos y mantener un registro de su lista de lectura.

## ✨ Características

- Buscar libros usando Google Books API
- Crear cuenta
- Guardar favoritos
- Gestionar lista de lectura (por leer, leyendo, completados)
- Ver detalles del libro

## 🛠️ Tecnologías

- **Flutter & Dart** - Framework mobile
- **Supabase** - Autenticación y base de datos
- **Google Books API** - Catálogo de libros
- **SQLite** - Almacenamiento local
- **Riverpod** - Gestión de estado

## 📁 Estructura del Proyecto

```
lib/
├── main.dart              # Punto de entrada
├── app/                   # Configuración de la app
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── features/              # Funcionalidades principales
│   ├── auth/             # Autenticación
│   ├── home/             # Pantalla principal
│   ├── search/           # Búsqueda de libros
│   ├── favorites/        # Favoritos
│   ├── reading_list/     # Mi lista de lectura
│   └── book_detail/      # Detalle del libro
└── core/                  # Código compartido
    ├── constants/
    ├── errors/
    └── utils/
```

## 🚀 Instalación

```bash
# Clonar repositorio
git clone <repo-url>

# Instalar dependencias
flutter pub get

# Ejecutar
flutter run
```
