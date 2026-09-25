# Estructura del Frontend Móvil - AuraTech

Esta es la arquitectura y estructura implementada para la aplicación móvil Flutter de **AuraTech**, diseñada bajo el patrón **Feature-First**, directrices SaaS tipo Shadcn UI, tokens de color pastel, persistencia segura y contrato REST API v1.1.

---

## 1. Stack Tecnológico & Dependencias
- **Flutter SDK:** 3.47.5 / Dart 3.13.4
- **Cliente HTTP:** `dio` con interceptor JWT Bearer y parseo unificado de errores (`ApiResponseError`).
- **Almacenamiento Seguro:** `flutter_secure_storage` para tokens JWT y datos de sesión.
- **Manejo de Estado:** `provider` (arquitectura basada en `ChangeNotifier`).
- **Tipografía & Iconografía:** `google_fonts` (`GoogleFonts.inter`) y `lucide_icons`.
- **Multimedia:** `image_picker`, `flutter_image_compress` (compresión obligatoria menor a 1 MiB según RNF10).
- **Formateo:** `intl`.

---

## 2. Árbol de Directorios (`lib/`)

```text
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart          # URL base del emulador, configurable con API_BASE_URL, y timeouts de 10s
│   ├── constants/
│   │   ├── api_endpoints.dart       # Endpoints oficiales REST v1.1 (AUTH, SOL, COT, PAG, CHAT, CAL)
│   │   ├── app_colors.dart          # Tokens pastel (Verde #ECFDF5, Azul #EFF6FF, Ámbar #FFFBEB, Rojo #FEF2F2, Bordes #E2E8F0)
│   │   └── app_text_styles.dart     # Tipografía Inter unificada
│   ├── network/
│   │   ├── api_client.dart          # Singleton Dio, inyección de Bearer Token y manejo de 401
│   │   ├── api_error.dart           # Modelo normalizado de error (detail, codigo_error, errores[])
│   │   └── token_storage.dart       # Wrapper seguro de credenciales
│   ├── theme/
│   │   └── app_theme.dart           # ThemeData Shadcn/SaaS minimalista sin elevaciones toscas
│   ├── utils/
│   │   └── image_compressor.dart    # Compresión a <1 MiB (RNF10)
│   └── widgets/
│       ├── badges/
│       │   └── aura_badge.dart      # Badges pastel con mapeo automático por estado
│       ├── buttons/
│       │   ├── aura_button.dart     # Botones primarios, destructivos, outlines y ghost
│       │   └── aura_icon_button.dart
│       ├── cards/
│       │   ├── aura_card.dart       # Contenedor blanco con bordes 1px y radio 12-16px
│       │   └── metric_kpi_card.dart # Métricas tipo KPI en colores pastel
│       ├── inputs/
│       │   ├── aura_text_field.dart # Form fields limpios con bordes suaves
│       │   └── aura_search_bar.dart # Barra de búsqueda con icono Lucide
│       └── overlays/
│           ├── aura_bottom_sheet.dart       # Modal deslizante con grab handle
│           ├── aura_confirmation_modal.dart # Diálogo de confirmación para acciones críticas
│           ├── aura_input_modal.dart        # Diálogo para motivos y observaciones con validación
│           ├── aura_file_picker_modal.dart  # Selector de fotos con compresión
│           └── aura_snackbar.dart           # Feedback flotante para éxito, alerta y errores de API
│
├── features/
│   ├── auth/
│   │   ├── models/auth_models.dart          # LoginRequest, LoginResponse, UserModel, RegisterRequest
│   │   ├── providers/auth_provider.dart     # Estado de autenticación y sesión
│   │   └── screens/
│   │       ├── login_screen.dart            # Pantalla de Login SaaS
│   │       ├── register_screen.dart         # Registro diferenciado (Cliente / Técnico)
│   │       └── forgot_password_screen.dart  # Recuperación de contraseña
│   ├── requests/
│   │   ├── models/request_models.dart       # SolicitudResumen, SolicitudDetalle, Permisos, ResumenPago
│   │   ├── providers/requests_provider.dart # Gestión de solicitudes disponibles y propias
│   │   ├── screens/
│   │   │   ├── available_requests_screen.dart # Bandeja de servicios para técnicos
│   │   │   ├── my_requests_screen.dart        # Bandeja clasificada por pestañas
│   │   │   ├── request_detail_screen.dart     # Vista condicional (PREVIA vs PRIVADA) y acciones
│   │   │   └── create_request_screen.dart     # Formulario de creación con validación
│   │   └── widgets/
│   │       └── request_card.dart              # Tarjeta resumen de solicitud
│   ├── quotes/
│   │   ├── models/quote_models.dart         # CotizacionResumen, CreateCotizacionRequest
│   │   ├── providers/quotes_provider.dart   # Envío, listado y retiro de ofertas
│   │   └── screens/
│   │       └── my_quotes_screen.dart        # Historial de cotizaciones del técnico
│   ├── chat/
│   │   ├── models/chat_models.dart          # MensajeChat, paginación por cursores
│   │   ├── providers/chat_provider.dart     # Mensajería con sondeo y cursores antes_de/despues_de
│   │   └── screens/
│   │       └── chat_screen.dart             # Sala de chat asociada a cotización
│   ├── payments/
│   │   ├── models/payment_models.dart       # PagoResumen, CreatePagoRequest, métodos de pago
│   │   ├── providers/payments_provider.dart # Registro y confirmación bilateral
│   │   └── screens/
│   │       └── payments_screen.dart         # Pantalla de abonos con doble visto bueno
│   ├── reviews/
│   │   ├── models/review_models.dart        # ReviewModel, CreateReviewRequest
│   │   ├── providers/reviews_provider.dart  # Calificaciones de 1 a 5 estrellas
│   │   └── screens/
│   │       └── create_review_screen.dart    # Modal de calificación
│   ├── technicians/
│   │   ├── models/technician_models.dart    # Perfil técnico, disponibilidad, documentos
│   │   └── providers/technician_provider.dart
│   └── notifications/
│       ├── models/notification_models.dart
│       └── providers/notifications_provider.dart
└── main.dart                                # Punto de entrada con MultiProvider y RootNavigation
```

---

## 3. Cumplimiento Estricto de Reglas de Negocio
1. **Moneda Fija en PEN (`S/`):** Todos los montos se representan como cadenas de dos decimales (ej. `"90.00"`), sin usar acumulaciones en `double`.
2. **Identificadores (IDs):** Manejo estricto de enteros de 64 bits (`int`).
3. **Privacidad Condicional (RNF09):**
   - **Vista `PREVIA`:** Teléfono, dirección, latitud, longitud y evidencias ocultos en null o listas vacías.
   - **Vista `PRIVADA`:** Solo accesible por el cliente dueño o técnico adjudicado.
4. **Ciclo de Vida:** Transición unidireccional `PENDIENTE` → `ACEPTADO` → `EN_PROCESO` → `FINALIZADO`. Estados terminales inmutables.
5. **Doble Confirmación de Pagos:** Registro con un flag en `true` y estado `CONFIRMADO` alcanzado solo al confirmar ambas partes.
6. **Chat Cursor-Based:** Uso estricto de `antes_de` y `despues_de`.
