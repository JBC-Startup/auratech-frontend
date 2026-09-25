## 5. Reglas de Negocio Estrictas del Contrato API v1.1

### 5.1 Ciclo de Vida y Transiciones de Solicitud (SOL)
- **Flujo Unidireccional Obligatorio:** `PENDIENTE` $\rightarrow$ `ACEPTADO` $\rightarrow$ `EN_PROCESO` $\rightarrow$ `FINALIZADO`.
- **Cancelación Ordinaria (`SOL-09`):** 
  - Solo se permite si la solicitud está en estado `PENDIENTE` o `ACEPTADO` y tiene `total_pagado == "0.00"` sin abonos en `CONFIRMADO`.
  - Si el servicio ya pasó a `EN_PROCESO`, el backend responderá con error HTTP 409 (`CANCELACION_REQUIERE_ACUERDO`).
  - Si existen abonos en estado `CONFIRMADO`, responderá con HTTP 409 (`CANCELACION_CON_PAGOS_CONFIRMADOS`).
- **Finalización del Trabajo (`SOL-11`):** 
  - Exclusivo para el técnico adjudicado cuando el estado es `EN_PROCESO`.
  - Requiere obligatoriamente el campo `observacion_final` (1 a 5000 caracteres).
  - Un servicio puede finalizar con saldo pendiente (`saldo_pendiente > "0.00"`).
- **Inmutabilidad:** Los estados `FINALIZADO` y `CANCELADO` son terminales. Prohibido mostrar acciones de transición sobre ellos.

### 5.2 Reglas de Privacidad y Proyección Condicional (RNF09 / Contrato 1.3)
- La respuesta de `GET /solicitudes/{id_solicitud}` (`SOL-05`) devuelve un objeto envoltorio con discriminador:
  - `vista == "PRIVADA"`: Entregado al cliente dueño o al técnico cuya cotización fue aceptada. Contiene `direccion`, `ubigeo_distrito`, `latitud`, `longitud`, `cliente_telefono` y array de `evidencias`.
  - `vista == "PREVIA"`: Entregado a técnicos postulantes o en búsqueda disponible. En este modo, `direccion`, `latitud`, `longitud` y `cliente_telefono` son forzosamente `null`, y `evidencias` siempre es un array vacío `[]`.
- La interfaz no debe intentar renderizar mapas, botones de llamada o visores de evidencias si `solicitud.permisos.ver_datos_privados == false` o si se encuentra en vista `PREVIA`.

### 5.3 Cotizaciones, Negociación y Adjudicación Atómica (COT)
- **Restricción de Emisión (`COT-01`):** Un técnico solo puede cotizar si su perfil tiene `estado_verificacion == "VERIFICADO"`, `disponible == true` y la solicitud está en `PENDIENTE`.
- **Monto y Tiempo:** El campo `monto` se envía como string de dos decimales (ej. `"90.00"`) y admite `"0.00"`.
- **Adjudicación Concurrente (`COT-05`):** 
  - Al presionar «Aceptar Cotización», el backend adjudica la solicitud de forma atómica a esa propuesta ganadora y marca automáticamente el resto de ofertas en `RECHAZADA`.
  - La UI debe refrescar inmediatamente el estado local a `ACEPTADO`.
- **Retiro de Oferta (`COT-06`):** Solo ejecutable por el técnico emisor mientras su cotización siga en `PENDIENTE`. El estado `RETIRADA` es irreversible.

### 5.4 Pagos Parciales, Regla Anti-Sobrepagos y Doble Conformidad (PAG)
- **Moneda Base:** Exclusivamente Soles (`"PEN"`). Prohibido el uso del tipo nativo `double` para sumatorias y validaciones de dinero.
- **Registro de Abono (`PAG-01`):**
  - Solo habilitado si `resumen_pago.permite_registrar_pago == true`.
  - Métodos permitidos: `EFECTIVO`, `TRANSFERENCIA`, `YAPE`, `PLIN`, `OTRO`[cite: 6].
  - El participante que crea el pago lo deja automáticamente con su confirmación en `true` y la contraparte en `false` (ej. cliente registra $\rightarrow$ `confirmado_cliente = true`, `confirmado_tecnico = false`)[cite: 6].
  - El pago nace en estado `PENDIENTE` con `fecha_confirmacion = null`[cite: 6].
- **Confirmación Bilateral (`PAG-04`):**
  - El participante restante ejecuta el endpoint sin enviar cuerpo JSON[cite: 6].
  - El backend actualiza a `estado = "CONFIRMADO"` y estampa `fecha_confirmacion` única y exclusivamente cuando ambos flags quedan en `true`[cite: 6].
  - Si el monto del abono excede el saldo restante en el momento del registro o confirmación, el servidor rechazará la operación con HTTP 409 (`SALDO_INSUFICIENTE`)[cite: 6].
- **Rechazo de Abono (`PAG-05`):** Solo aplicable a pagos en estado `PENDIENTE`[cite: 6]. Un pago en `CONFIRMADO` es inmutable[cite: 6].

### 5.5 Chat Contextual y Paginación por Cursor (CHAT)
- El chat pertenece a un identificador de cotización (`id_cotizacion`), permitiendo conversaciones independientes previas a la adjudicación[cite: 6].
- **Paginación por Cursors (`CHAT-01`):**
  - Prohibido usar `limit` y `offset` tradicionales[cite: 6].
  - Se utilizan parámetros mutuamente excluyentes: `antes_de` (historial anterior) o `despues_de` (mensajes nuevos)[cite: 6].
  - Para sondeo periódico de nuevos mensajes, conservar el mayor `id_mensaje` local y pasarlo como `?despues_de={id_mensaje}`[cite: 6].

### 5.6 Calificaciones y Cierre (CAL)
- El endpoint `POST /calificaciones` (`CAL-01`) solo se habilita para el cliente si `solicitud.estado == "FINALIZADO"` y no existe calificación previa en `solicitud.calificacion`[cite: 6].
- Puntuación entera estricta de 1 a 5[cite: 6].

---

## 6. Especificación de Componentes Compartidos (Core Overlays)

Todo modal, hoja inferior o diálogo de acción debe residir exclusivamente en `lib/core/widgets/overlays/` para garantizar uniformidad visual tipo Shadcn y evitar código duplicado[cite: 5].

### 6.1 `AuraConfirmationModal`
- **Ubicación:** `lib/core/widgets/overlays/aura_confirmation_modal.dart`
- **Finalidad:** Confirmar acciones con impacto en el estado (Aceptar cotización, Retirar cotización, Iniciar trabajo, Confirmar/Rechazar abono)[cite: 6].
- **Implementación Técnica:**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../constants/app_colors.dart';

enum AuraModalVariant { primary, warning, destructive }

class AuraConfirmationModal extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final AuraModalVariant variant;
  final VoidCallback onConfirm;

  const AuraConfirmationModal({
    super.key,
    required this.title,
    required this.description,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.variant = AuraModalVariant.primary,
    required this.onConfirm,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String description,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    AuraModalVariant variant = AuraModalVariant.primary,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) => AuraConfirmationModal(
        title: title,
        description: description,
        confirmText: confirmText,
        cancelText: cancelText,
        variant: variant,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color confirmBg = AuraColors.primary;
    Color confirmTextCol = Colors.white;
    IconData icon = LucideIcons.helpCircle;
    Color iconCol = AuraColors.primary;
    Color iconBg = AuraColors.primaryLight;

    if (variant == AuraModalVariant.destructive) {
      confirmBg = AuraColors.redText;
      icon = LucideIcons.alertTriangle;
      iconCol = AuraColors.redText;
      iconBg = AuraColors.redBg;
    } else if (variant == AuraModalVariant.warning) {
      confirmBg = AuraColors.amberText;
      icon = LucideIcons.alertCircle;
      iconCol = AuraColors.amberText;
      iconBg = AuraColors.amberBg;
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AuraColors.border, width: 1),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconCol, size: 22),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AuraColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AuraColors.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AuraColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text(
                    cancelText,
                    style: GoogleFonts.inter(color: AuraColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmBg,
                    foregroundColor: confirmTextCol,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text(
                    confirmText,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}