// quote_models.dart

class CotizacionResumen {
  final int idCotizacion;
  final int idSolicitud;
  final String monto; // PEN (S/) format
  final String tiempoEstimado;
  final String descripcionTrabajo;
  final String estado;
  final String fechaCreacion;
  final String nombreTecnico;
  final String? fotoTecnico;
  final String? calificacionPromedio;
  final String? tituloSolicitud;

  CotizacionResumen({
    required this.idCotizacion,
    required this.idSolicitud,
    required this.monto,
    required this.tiempoEstimado,
    required this.descripcionTrabajo,
    required this.estado,
    required this.fechaCreacion,
    required this.nombreTecnico,
    this.fotoTecnico,
    this.calificacionPromedio,
    this.tituloSolicitud,
  });

  factory CotizacionResumen.fromJson(Map<String, dynamic> rawJson) {
    final json = (rawJson['cotizacion'] is Map<String, dynamic>)
        ? rawJson['cotizacion'] as Map<String, dynamic>
        : rawJson;
    final solicitud = (rawJson['solicitud'] is Map<String, dynamic>)
        ? rawJson['solicitud'] as Map<String, dynamic>
        : null;

    final tecnico = json['tecnico'] as Map<String, dynamic>?;

    final minutos = json['tiempo_estimado_minutos'];
    final tiempoStr = minutos != null
        ? '$minutos min'
        : (json['tiempo_estimado'] as String? ?? 'N/A');

    return CotizacionResumen(
      idCotizacion: json['id_cotizacion'] as int,
      idSolicitud: json['id_solicitud'] as int? ?? (solicitud?['id_solicitud'] as int? ?? 0),
      monto: json['monto'] as String? ?? '0.00',
      tiempoEstimado: tiempoStr,
      descripcionTrabajo: json['descripcion_trabajo'] as String? ?? '',
      estado: json['estado'] as String? ?? 'PENDIENTE',
      fechaCreacion: json['fecha_cotizacion'] as String? ??
          json['fecha_creacion'] as String? ??
          '',
      nombreTecnico: json['nombre_tecnico'] as String? ??
          tecnico?['nombre_completo'] as String? ??
          '',
      fotoTecnico: json['foto_tecnico'] as String? ??
          tecnico?['foto_perfil_url'] as String?,
      calificacionPromedio: json['calificacion_promedio']?.toString() ??
          tecnico?['calificacion_promedio']?.toString(),
      tituloSolicitud: json['titulo_solicitud'] as String? ??
          solicitud?['titulo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_cotizacion': idCotizacion,
      'id_solicitud': idSolicitud,
      'monto': monto,
      'tiempo_estimado': tiempoEstimado,
      'descripcion_trabajo': descripcionTrabajo,
      'estado': estado,
      'fecha_creacion': fechaCreacion,
      'nombre_tecnico': nombreTecnico,
      'foto_tecnico': fotoTecnico,
      'calificacion_promedio': calificacionPromedio,
    };
  }
}

class CotizacionDetalle extends CotizacionResumen {
  final String estadoSolicitud;

  CotizacionDetalle({
    required super.idCotizacion,
    required super.idSolicitud,
    required super.monto,
    required super.tiempoEstimado,
    required super.descripcionTrabajo,
    required super.estado,
    required super.fechaCreacion,
    required super.nombreTecnico,
    super.fotoTecnico,
    super.calificacionPromedio,
    super.tituloSolicitud,
    required this.estadoSolicitud,
  });

  factory CotizacionDetalle.fromJson(Map<String, dynamic> json) {
    final resumen = CotizacionResumen.fromJson(json);
    return CotizacionDetalle(
      idCotizacion: resumen.idCotizacion,
      idSolicitud: resumen.idSolicitud,
      monto: resumen.monto,
      tiempoEstimado: resumen.tiempoEstimado,
      descripcionTrabajo: resumen.descripcionTrabajo,
      estado: resumen.estado,
      fechaCreacion: resumen.fechaCreacion,
      nombreTecnico: resumen.nombreTecnico,
      fotoTecnico: resumen.fotoTecnico,
      calificacionPromedio: resumen.calificacionPromedio,
      tituloSolicitud: resumen.tituloSolicitud,
      estadoSolicitud: json['estado_solicitud'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['titulo_solicitud'] = tituloSolicitud;
    data['estado_solicitud'] = estadoSolicitud;
    return data;
  }
}

class CreateCotizacionRequest {
  final int idSolicitud;
  final String monto; // PEN (S/) format
  final String tiempoEstimado;
  final String descripcionTrabajo;

  CreateCotizacionRequest({
    required this.idSolicitud,
    required this.monto,
    required this.tiempoEstimado,
    required this.descripcionTrabajo,
  });

  Map<String, dynamic> toJson() {
    double parsedMonto = double.tryParse(monto) ?? 0.0;
    int? mins = int.tryParse(tiempoEstimado.replaceAll(RegExp(r'[^0-9]'), ''));
    final map = <String, dynamic>{
      'id_solicitud': idSolicitud,
      'monto': parsedMonto.toStringAsFixed(2),
      'descripcion_trabajo': descripcionTrabajo,
    };
    if (mins != null && mins > 0) {
      map['tiempo_estimado_minutos'] = mins;
    }
    return map;
  }
}
