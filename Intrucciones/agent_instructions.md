# AuraTech Mobile – Agent Development Instructions & Frontend System Guidelines

## 1. Contexto General y Contrato Operativo
- **Proyecto:** AuraTech – Gestión móvil de servicios TI.
- **Contrato Backend:** REST API v1.1 (`/api/v1`) implementado en FastAPI con persistencia en PostgreSQL Supabase.
- **Frontend:** Flutter Móvil (Android First).
- **Moneda Estricta:** Siempre `"PEN"` (`S/`). Los importes viajan y se muestran como strings de dos decimales (ej. `"90.00"`). Prohibido usar double para acumular importes.
- **Identificadores (IDs):** Enteros positivos `int64`. En peticiones JSON enviar `105`, nunca strings (`"105"`) ni booleanos.
- **Manejo de Respuestas Nulas:** Todos los modelos deben recibir las claves aunque tengan valor `null`. Prohibido convertir a string `"null"`.
- **Paginación Convencional:** Todas las listas vienen envueltas en `{ items: [...], paginacion: { limit, offset, total, has_more } }`. En chat se utiliza cursor con `{ orden, has_more, siguiente_antes_de, siguiente_despues_de }`.

---

## 2. Sistema de Diseño Visual (Estilo SaaS / Shadcn UI)
Queda estrictamente prohibido generar interfaces tradicionales de Material Design tosco (sin botones flotantes gigantes, sin elevaciones pesadas, sin colores primarios saturados)[cite: 5]. Debe replicar la interfaz minimalista tipo panel SaaS de la captura de referencia[cite: 5]:

1. **Tokens de Color:**
   - **Fondo General:** Gris neutro claro `#F8FAFC` o `#F1F5F9`[cite: 5].
   - **Superficie / Contenedores:** Blanco `#FFFFFF` con borde sutil de 1px en `#E2E8F0` y radio de 12px a 16px[cite: 5].
   - **Sombras:** Prácticamente planas (`Colors.black.withOpacity(0.02)` a `0.04`, `blurRadius: 8` a `10`)[cite: 5].
   - **Tipografía:** Exclusivamente `GoogleFonts.inter()`[cite: 5].
   - **Iconos:** Exclusivamente `lucide_icons` (trazo moderno y fino)[cite: 5].

2. **Badges y Chips Pasteles Obligatorios:**
   - **Verde (Disponible / Finalizado / Verificado):** Fondo `#ECFDF5`, borde `#A7F3D0`, texto `#059669`[cite: 5].
   - **Azul (En Proceso / Primario / Aceptado):** Fondo `#EFF6FF`, borde `#BFDBFE`, texto `#2563EB`[cite: 5].
   - **Ámbar (Pendiente / Advertencia / En Revisión):** Fondo `#FFFBEB`, borde `#FDE68A`, texto `#D97706`[cite: 5].
   - **Rojo (Rechazado / Cancelado / Inactivo):** Fondo `#FEF2F2`, borde `#FECACA`, texto `#DC2626`[cite: 5].

---

## 3. Principio de Componentes Centralizados (DRY)
**Regla Estricta:** Ningún módulo de feature (solicitudes, cotizaciones, pagos, etc.) debe implementar sus propios modales, diálogos o bottom sheets desde cero creando duplicados con estilos distintos.
Todo componente interactivo debe residir en `lib/core/widgets/overlays/` y ser invocado a través de métodos helper estáticos.

### Catálogo de Componentes Centralizados Obligatorios:
1. **`AuraConfirmationDialog`:** Diálogo modal limpio para confirmar acciones críticas (Aceptar cotización, Retirar cotización, Iniciar trabajo, Confirmar/Rechazar abono). Con variantes `default`, `warning` y `destructive`.
2. **`AuraBottomSheet`:** Envoltorio base para hojas inferiores con tirador superior (grab handle), bordes redondeados (16px) y título con subtítulo integrados.
3. **`AuraInputDialog` / `AuraActionModal`:** Modal o sheet para entrada de texto con validación (utilizado en la cancelación de servicio con `motivo_cancelacion` y en finalización con `observacion_final`).
4. **`AuraErrorFeedback`:** Handler global de errores visuales para BottomSheet / SnackBar que parsea automáticamente el cuerpo de error unificado de la API (`detail`, `codigo_error`, `errores[]`).
5. **`AuraFilePickerModal`:** Selector reutilizable para cámara/galería que integra la compresión obligatoria menor a 1 MiB antes de emitir el binario.

---

## 4. Estructura de Proyecto (Feature-First)

```text
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart          # API_BASE_URL ([http://10.0.2.2:8000/api/v1](http://10.0.2.2:8000/api/v1)) y timeout 10s
│   ├── constants/
│   │   ├── api_endpoints.dart       # Códigos de contrato (AUTH-01, SOL-01, etc.)
│   │   └── app_colors.dart          # Tokens de paleta pastel y neutral
│   ├── network/
│   │   ├── api_client.dart          # Instancia Dio con interceptor Bearer JWT
│   │   ├── api_error.dart           # Modelo ApiResponseError (detail, codigo_error, errores[])
│   │   └── token_storage.dart       # Manejo en FlutterSecureStorage (access_token, expires_at)
│   ├── theme/
│   │   └── app_theme.dart           # ThemeData con GoogleFonts.inter() y tokens
│   ├── utils/
│   │   └── image_compressor.dart    # Compresión < 1 MiB obligatoria (RNF10)
│   └── widgets/
│       ├── badges/
│       │   └── aura_badge.dart      # Pill de estados pasteles
│       ├── buttons/
│       │   ├── aura_button.dart     # Primary, outline, ghost, destructive
│       │   └── aura_icon_button.dart
│       ├── cards/
│       │   ├── aura_card.dart       # Contenedor blanco con borde sutil
│       │   └── metric_kpi_card.dart # Métricas tipo pasteles (Disponibles, Ocupadas, etc.)
│       ├── inputs/
│       │   ├── aura_text_field.dart # Borde gris suave y foco azul
│       │   └── aura_search_bar.dart # Input con icono de lupa gris
│       └── overlays/                # << COMPONENTES GLOBALES REUTILIZABLES >>
│           ├── aura_bottom_sheet.dart       # Base modal deslizante
│           ├── aura_confirmation_modal.dart # Diálogos de advertencia/aprobación
│           ├── aura_input_modal.dart        # Modales con campo de texto (motivos/observaciones)
│           ├── aura_file_picker_modal.dart  # Modal de carga de fotos con compresión
│           └── aura_snackbar.dart           # Alertas de error con parsing de codigo_error
│
├── features/
│   ├── auth/                        # [AUTH-01 a AUTH-08] Registro, login, me, recuperación
│   ├── technicians/                 # [TEC-01 a TEC-08] Perfil técnico, especialidades, documentos
│   ├── catalog/                     # [CAT-01 a CAT-04] Categorías, tipos y sugerencias
│   ├── requests/                    # [SOL-01 a SOL-11] Creación, disponibles, mis-solicitudes, estados
│   ├── quotes/                      # [COT-01 a COT-06] Cotizar, propuestas recibidas, adjudicación
│   ├── chat/                        # [CHAT-01 a CHAT-04] Mensajería por cotización con cursor
│   ├── payments/                    # [PAG-01 a PAG-05] Registro de abonos, saldo y confirmación doble
│   ├── reviews/                     # [CAL-01 a CAL-02] Calificación y cierre formal
│   └── notifications/               # [NOT-01 a NOT-02] Alertas del sistema
└── main.dart