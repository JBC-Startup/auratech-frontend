Al construir los mocks y proveedores locales de prueba (mientras se consumen o completan los endpoints de FastAPI), el agente debe validar los 9 escenarios exactos estipulados en la Sección 7 del contrato[cite: 6]:

Escenario de Estados Vacíos e Identidades Parciales:

Listas vacías con paginacion.total == 0 y items: [][cite: 6].

Perfil de técnico sin foto (foto_perfil_url: null), sin experiencia declarada (anios_experiencia: null) y sin reseñas previas (calificacion_promedio: null, total_calificaciones: 0)[cite: 6].

Modalidad Presencial vs Remota:

Caso REMOTO: Campos direccion: null, ubigeo_distrito: null, latitud: null, longitud: null[cite: 6].

Caso PRESENCIAL: direccion con texto válido y ubigeo_distrito obligatorio de 6 dígitos numéricos[cite: 6].

Simulación de Privacidad (Vista Previa vs Vista Privada):

Para un técnico que navega en la bandeja disponible, la solicitud se entrega como vista: "PREVIA", con cliente_telefono: null, ubicación nula y evidencias: [][cite: 6].

Al adjudicarse, pasa a vista: "PRIVADA" exponiendo contacto y la URL temporal de evidencia[cite: 6].

Resumen de Pago Sin Ganadora:

total_acordado: null, total_pagado: "0.00", saldo_pendiente: null, estado_pago: "SIN_COTIZACION_ACEPTADA" y permite_registrar_pago: false[cite: 6].

Servicio sin Costo Económico (S/ 0.00):

total_acordado: "0.00", total_pagado: "0.00", saldo_pendiente: "0.00", estado_pago: "SIN_CARGO", permite_registrar_pago: false[cite: 6].

Casuística de Estados de Doble Confirmación de Abonos:

Pago creado por Cliente: confirmado_cliente = true, confirmado_tecnico = false, estado = "PENDIENTE", fecha_confirmacion = null[cite: 6].

Pago creado por Técnico: confirmado_cliente = false, confirmado_tecnico = true, estado = "PENDIENTE", fecha_confirmacion = null[cite: 6].

Pago Confirmado: confirmado_cliente = true, confirmado_tecnico = true, estado = "CONFIRMADO", fecha_confirmacion presente[cite: 6].

Pago Rechazado: confirmado_cliente = false, confirmado_tecnico = false, estado = "RECHAZADO"[cite: 6].

Conflictos de Concurrencia (HTTP 409):

Simular intento de registrar un pago mayor al saldo restante (SALDO_INSUFICIENTE)[cite: 6].

Simular intento de enviar una segunda propuesta para la misma solicitud (COTIZACION_DUPLICADA)[cite: 6].

Simular intento de calificación sobre una solicitud no finalizada (ESTADO_NO_PERMITIDO)[cite: 6].

Manejo de Expiración y Fallos de Red:

Expiración de token JWT tras 900s: disparar interceptor con redirección a login[cite: 6].

Vencimiento de URL temporal de archivo tras 300 segundos: obligar a la UI a consultar nuevamente el recurso[cite: 6].

Estados Terminales y Saldo Histórico:

Solicitud FINALIZADO con deuda pendiente: el botón de calificar se habilita y el botón de registrar pago se conserva según permite_registrar_pago[cite: 6].

Solicitud CANCELADO: muestra el motivo de cancelación histórico y los botones de acción operativa deshabilitados[cite: 6].