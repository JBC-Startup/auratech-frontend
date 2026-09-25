class MensajeChat {
  final int idMensaje;
  final int idCotizacion;
  final String contenido;
  final int idRemitente;
  final String nombreRemitente;
  final String fechaEnvio;
  final bool esMio;

  MensajeChat({
    required this.idMensaje,
    required this.idCotizacion,
    required this.contenido,
    required this.idRemitente,
    required this.nombreRemitente,
    required this.fechaEnvio,
    this.esMio = false,
  });

  factory MensajeChat.fromJson(Map<String, dynamic> json) {
    final esMio = json['es_mio'] as bool? ?? false;
    return MensajeChat(
      idMensaje: json['id_mensaje'] as int,
      idCotizacion: json['id_cotizacion'] as int,
      contenido: json['mensaje'] as String? ?? json['contenido'] as String? ?? '',
      idRemitente: json['id_remitente'] as int? ?? 0,
      nombreRemitente: json['nombre_remitente'] as String? ?? (esMio ? 'Tú' : ''),
      fechaEnvio: json['fecha_envio'] as String? ?? '',
      esMio: esMio,
    );
  }
}

class ChatPaginacion {
  final String orden;
  final bool hasMore;
  final int? siguienteAntesDe;
  final int? siguienteDespuesDe;

  ChatPaginacion({
    required this.orden,
    required this.hasMore,
    this.siguienteAntesDe,
    this.siguienteDespuesDe,
  });

  factory ChatPaginacion.fromJson(Map<String, dynamic> json) {
    return ChatPaginacion(
      orden: json['orden'] as String? ?? 'DESC',
      hasMore: json['has_more'] as bool? ?? false,
      siguienteAntesDe: json['siguiente_antes_de'] as int?,
      siguienteDespuesDe: json['siguiente_despues_de'] as int?,
    );
  }
}

class SendMessageRequest {
  final String contenido;

  SendMessageRequest({required this.contenido});

  Map<String, dynamic> toJson() => {'mensaje': contenido};
}
