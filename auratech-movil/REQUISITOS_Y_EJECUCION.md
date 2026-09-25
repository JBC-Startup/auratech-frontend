# Requisitos y ejecución de AuraTech Mobile

Esta guía prepara una instalación nueva del proyecto Android. La combinación siguiente compiló y abrió la pantalla de acceso en un emulador:

| Herramienta | Versión comprobada |
| --- | --- |
| Flutter estable | 3.47.5 (Dart 3.13.4) |
| JDK | 17 |
| Gradle | 8.14.4, incluido en el wrapper del proyecto |
| Android Gradle Plugin | 8.11.1 |
| Kotlin Gradle Plugin | 2.2.21 |
| Android SDK Platform | API 36 |
| Emulador probado | Android API 37.1, x86_64 |

Usa Flutter 3.47.5 para reproducir el entorno comprobado. Las versiones de Gradle, Android Gradle Plugin y Kotlin ya están fijadas en el proyecto. No hace falta instalar Gradle globalmente.

## 1. Instalar herramientas

1. Instala [Flutter 3.47.5](https://docs.flutter.dev/install/archive) y agrega su carpeta `bin` al `PATH`.
2. Instala un **JDK 17**. Si Android Studio incluye Java 25, indica a Flutter dónde está el JDK 17:

   ```powershell
   flutter config --jdk-dir "<RUTA_DEL_JDK_17>"
   ```

   Pasa la carpeta raíz del JDK, la que contiene `bin/java`, y comprueba la ruta con `flutter doctor -v`. Esta configuración es local a cada computadora; no se guarda en Git.
3. Instala [Android Studio](https://developer.android.com/studio). En **SDK Manager**, instala Android SDK Platform 36, Android SDK Build-Tools 35.0.0, Android SDK Command-line Tools (latest), Android Emulator, NDK 28.2.13676358 y CMake 3.22.1. Gradle puede descargar algunos componentes automáticamente si las licencias ya fueron aceptadas.
4. Acepta las licencias y revisa la sección **Android toolchain**:

   ```powershell
   flutter doctor --android-licenses
   flutter doctor -v
   ```

5. En **Device Manager**, crea un dispositivo virtual Android x86_64 (por ejemplo, Pixel con API 36 o 37). Activa la virtualización del equipo si el emulador no inicia.

## 2. Obtener y ejecutar la app

Desde una terminal abierta en la carpeta raíz de este proyecto:

```powershell
flutter pub get
flutter emulators
flutter emulators --launch <ID_DEL_EMULADOR>
flutter devices
flutter run -d <ID_DEL_DISPOSITIVO>
```

Sustituye los valores entre `< >` por los identificadores mostrados por Flutter. También puedes iniciar el emulador desde Android Studio y ejecutar `flutter run` después. El primer build necesita acceso a pub.dev, Google Maven y los servidores de Gradle, y puede tardar varios minutos.

No subas a Git `android/local.properties`, `.dart_tool/`, `build/`, `.idea/`, archivos `.env` ni claves de firma. Ya están excluidos por los archivos `.gitignore`. Sí deben subirse `pubspec.lock`, `android/gradlew`, `android/gradlew.bat` y `android/gradle/wrapper/gradle-wrapper.jar`.

## 3. Backend e inicio de sesión

El backend **no está incluido** en este repositorio. El registro, el login y los datos de la app requieren la API FastAPI de AuraTech y su base de datos. Este frontend no contiene cuentas ni contraseñas de prueba; `correo@ejemplo.com` es solo un texto de ejemplo.

Para un emulador Android, inicia el backend en la computadora anfitriona en el puerto **8000**. La URL por defecto de la app es:

```text
http://10.0.2.2:8000/api/v1
```

`10.0.2.2` apunta desde el emulador al `127.0.0.1` de la computadora. Antes de intentar registrarte, verifica que el backend esté escuchando. En Windows:

```powershell
Test-NetConnection 127.0.0.1 -Port 8000
```

Cuando el backend funcione, toca **Regístrate**, elige **Cliente** o **Técnico**, crea una cuenta e inicia sesión. Si el equipo del backend proporciona usuarios de prueba, usa las credenciales que te entreguen por un canal privado.

Para otra dirección de API, pasa la URL completa (incluido `/api/v1`) al ejecutar:

```powershell
flutter run -d <ID_DEL_DISPOSITIVO> --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

En un teléfono físico, cambia `10.0.2.2` por la IP de la computadora en la red local y asegúrate de que el backend escuche en esa interfaz y que el firewall permita el puerto. Para una compilación de producción, configura una URL **HTTPS**. El permiso de tráfico HTTP sin cifrar está habilitado solo en la variante Android de depuración.

## Problemas frecuentes

| Síntoma | Qué comprobar |
| --- | --- |
| Java 25 o error de compatibilidad con Gradle | Instala JDK 17 y ejecuta `flutter config --jdk-dir "<RUTA_DEL_JDK_17>"`. |
| Flutter indica que falta el wrapper de Gradle | Confirma que `android/gradlew`, `android/gradlew.bat` y `android/gradle/wrapper/gradle-wrapper.jar` están en el clon. |
| `cmdline-tools component is missing` o licencias desconocidas | Instala Android SDK Command-line Tools desde SDK Manager y ejecuta `flutter doctor --android-licenses`. |
| El emulador no abre o figura como `offline` | Reinícialo con **Cold Boot Now** desde Device Manager. Si se cierra, cambia **Graphics** a **Software** en la configuración del AVD. |
| Falla una descarga de `dl.google.com` | Comprueba DNS/conexión a Internet y reintenta `flutter run`. |
| Abre el login, pero registrar o ingresar falla por conexión | Verifica el backend en el puerto 8000 y la `API_BASE_URL` elegida. |

Consulta [la guía oficial de Android para Flutter](https://docs.flutter.dev/platform-integration/android/setup), [el acceso del emulador a la máquina anfitriona](https://developer.android.com/studio/run/emulator-networking-address) y [las licencias y herramientas Android](https://docs.flutter.dev/install/troubleshoot) para más detalles.
