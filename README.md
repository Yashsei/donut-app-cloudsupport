<<<<<<< HEAD
# 🍩 Donut App - Cloud Support (Supabase Edition)

Este repositorio contiene la integración progresiva de servicios en la nube para **Donut App** utilizando **Supabase** como Backend-as-a-Service (BaaS). El proyecto evoluciona desde la conexión inicial hasta la gestión de archivos multimedia, pasando por autenticación nativa y bases de datos en tiempo real.

## 🚀 Tecnologías utilizadas
* **Frontend:** Flutter & Dart
* **Backend:** Supabase (Auth, Database/PostgreSQL, Storage)
* **Autenticación:** Google Sign-In Nativo (`google_sign_in`)

---

## 🗺️ Fases del Proyecto

### 🏗️ Fase 1: Conexión Inicial
- Dashboard de Supabase e inicializar la conexión en la app utilizando el paquete oficial `supabase_flutter` (configurando la `url` y la `anonKey` en el `main.dart`).
- **Criterio de éxito:** La app debe arrancar mostrando un indicador de carga inicial (`CircularProgressIndicator`). Al establecer la conexión con éxito, la UI debe mostrar un indicador visual claro de conexión activa (o un mensaje de error manejado si falla). No se avanza a la siguiente fase sin esta validación.

### 🔐 Fase 2: Identidad y UI (Autenticación nativa con Google)
- **Qué hacer:** Diseñar una pantalla de login atractiva que integre el botón de inicio de sesión con Google usando el paquete `google_sign_in` para obtener el ID Token, y enviarlo a Supabase Auth (`signInWithIdToken`).
- **Criterio de éxito:** El usuario puede autenticarse de forma nativa sin bloqueos del navegador web. La aplicación reconoce el token, mantiene la sesión activa (persistente) y redirige correctamente a la pantalla principal.
- **Nota técnica:** Requiere la configuración estricta de la huella **SHA-1** y el **Package Name** en Google Cloud Console (Credencial Android), y el uso del **Web Client ID** dentro del código de Flutter y en el dashboard de Supabase.

### 💾 Fase 3: Los Datos (Supabase Database - PostgreSQL)
- **Qué hacer:** Conectar la aplicación a una tabla en Supabase y establecer las políticas de seguridad de nivel de fila (RLS - Row Level Security) para proteger la información.
- **Criterio de éxito:** Una vez autenticado, el usuario debe poder registrar un dato simple a través de un formulario (por ejemplo, guardar una reseña o un pedido) y visualizarlo reflejado en tiempo real en la interfaz (utilizando los *Realtime Streams* de Supabase).

### 🏞️ Fase 4: Imágenes en la Nube (Supabase Storage)
- **Qué hacer:** Migrar el catálogo de donas conectando la app a un *Bucket* de Supabase Storage, consumiendo las URLs públicas de las imágenes de los productos en lugar de los *assets* locales.
- **Criterio de éxito:** La interfaz renderiza las imágenes de la nube fluidamente. Se implementa un manejo de errores: si el dispositivo pierde la conexión a internet o la imagen falla al cargar, la app debe mostrar un *placeholder* (imagen por defecto o GIF local) para que la UI no se rompa.
=======
# donut-app-cloudsupport
Aplicación e-comerce desarrollada en Flutter con backend en Supabase. Implementa autenticación nativa con Google, base de datos en tiempo real (PostgreSQL) y gestión de imágenes de productos a través de Supabase Storage.
>>>>>>> b96807db24e60b642da216805a4968cb95423404
