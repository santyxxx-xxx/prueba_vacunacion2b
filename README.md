# 🐾 Sistema de Gestión de Vacunación Animal

Aplicación móvil desarrollada con **Flutter** y **Supabase** para la gestión de campañas de vacunación animal.

El sistema permite administrar usuarios según su rol, registrar vacunaciones con evidencia fotográfica y ubicación GPS, gestionar sectores y visualizar información básica de la campaña.

---

## 🚀 Tecnologías utilizadas

- Flutter
- Dart
- Supabase
- PostgreSQL
- Image Picker
- Geolocator

---

## ✨ Funcionalidades

### 🔐 Autenticación
- Inicio de sesión mediante Supabase Auth.
- Acceso según el rol del usuario.

### 👤 Gestión de usuarios
- Crear usuarios.
- Roles disponibles:
  - Coordinador
  - Coordinador de brigada
  - Vacunador

### 📍 Gestión de sectores
- Crear sectores.
- Listar sectores.
- Asignar sectores a los usuarios.

### 💉 Registro de vacunaciones
- Registro de información del propietario.
- Registro de datos de la mascota.
- Selección del tipo de mascota.
- Registro de vacuna aplicada.
- Observaciones.
- Captura de fotografía desde la cámara.
- Obtención automática de la ubicación GPS.
- Almacenamiento de imágenes en Supabase Storage.
- Guardado de la información en Supabase.

### 📋 Consulta de vacunaciones
- Visualización de vacunaciones registradas.
- Edición de observaciones.

### 📊 Dashboard
El coordinador puede visualizar:
- Total de vacunaciones.
- Total de perros vacunados.
- Total de gatos vacunados.

---
## Confirmacion de correos
<img width="936" height="899" alt="image" src="https://github.com/user-attachments/assets/1517d47f-7869-4ba1-b7bd-e2ddb0509423" />
<img width="950" height="920" alt="image" src="https://github.com/user-attachments/assets/4792d376-7eec-47d5-983d-0e319e377ccb" />

## 🗄️ Base de datos

El proyecto utiliza Supabase con las siguientes tablas principales:

- usuarios
- sectores
- vacunaciones
<img width="1139" height="690" alt="image" src="https://github.com/user-attachments/assets/0e773e23-aff7-44fa-a01e-2a9b63e27184" />

Además utiliza un bucket de almacenamiento llamado:

- fotos
<img width="1920" height="1011" alt="image" src="https://github.com/user-attachments/assets/fb1e5471-618a-41f6-8162-4a4a66a39dd4" />

---
## Permisos
<img width="746" height="1600" alt="image" src="https://github.com/user-attachments/assets/10206a7c-5092-42a2-94a7-048af93aa4b9" />
<img width="746" height="1600" alt="image" src="https://github.com/user-attachments/assets/7a2aed18-91ad-4f7c-9eef-c5563c0fd0cd" />

## 📱 Pantallas principales

- Login
- <img width="1080" height="2202" alt="image" src="https://github.com/user-attachments/assets/7458e94a-e49f-4f7c-a28b-35f00f10ad74" />

- Dashboard Coordinador
- <img width="746" height="1600" alt="image" src="https://github.com/user-attachments/assets/d620f76d-bf5d-420c-8210-16be47863772" />

- Dashboard Brigada
- <img width="746" height="1600" alt="image" src="https://github.com/user-attachments/assets/4cc149d7-2bba-4267-a62e-39054016fedc" />

- Dashboard Vacunador
- <img width="746" height="1600" alt="image" src="https://github.com/user-attachments/assets/4311c266-328a-4667-9475-79723e440886" />

- Gestión de Sectores
- <img width="746" height="1600" alt="image" src="https://github.com/user-attachments/assets/f2ffdddd-eeb8-4a0c-9caa-16e40a48889e" />

- Creación de Usuarios
- <img width="746" height="1600" alt="image" src="https://github.com/user-attachments/assets/b3153c2c-f5de-4f2e-9ddf-fa78462be846" />
<img width="746" height="1600" alt="image" src="https://github.com/user-attachments/assets/848bb506-4dd3-425e-b9e3-9fd3b52550a6" />

- Asignación de Sectores
- <img width="746" height="1600" alt="image" src="https://github.com/user-attachments/assets/6622ca1e-23e5-433c-8c5d-fb615b64eb1e" />

- Registro de Vacunación
- <img width="1080" height="2316" alt="image" src="https://github.com/user-attachments/assets/8189bd4b-794d-49fa-ad5e-70d8a0ca4aa7" />

- Lista de Vacunaciones
<img width="746" height="1600" alt="image" src="https://github.com/user-attachments/assets/9189143b-0cd7-48d7-ae35-7d2942ac0497" />

---

## 📂 Estructura del proyecto

```
lib/
│
├── screens/
│   ├── login/
│   ├── coordinador/
│   ├── brigada/
│   ├── vacunador/
│
├── widgets/
│
├── services/
│
└── main.dart
```

---

## ▶️ Instalación

Clonar el repositorio:

```bash
git clone https://github.com/santyxxx-xxx/prueba_vacunacion2b.git
```

Entrar al proyecto:

```bash
cd prueba_vacunacion2b
```

Instalar dependencias:

```bash
flutter pub get
```

Ejecutar la aplicación:

```bash
flutter run
```

---

## ⚙️ Configuración

Antes de ejecutar el proyecto es necesario:

- Crear un proyecto en Supabase.
- Configurar la URL y la API Key en `main.dart`.
- Crear las tablas correspondientes.
- Crear el bucket `fotos` para almacenar las imágenes.

---

## 👨‍💻 Autor

**Santiago Vargas**

Proyecto académico desarrollado con Flutter y Supabase para la gestión de campañas de vacunación animal.
