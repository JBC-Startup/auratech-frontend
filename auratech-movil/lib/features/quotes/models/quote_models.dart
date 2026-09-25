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

  factory CotizacionResumen.fromJson(Map<String, dynamic> json) {
    return CotizacionResumen(
      idCotizacion: json['id_cotizacion'] as int,
      idSolicitud: json['id_solicitud'] as int,
      monto: json['monto'] as String,
      tiempoEstimado: json['tiempo_estimado'] as String,
      descripcionTrabajo: json['descripcion_trabajo'] as String,
      estado: json['estado'] as String,
      fechaCreacion: json['fecha_creacion'] as String,
      nombreTecnico: json['nombre_tecnico'] as String? ?? '',
      fotoTecnico: json['foto_tecnico'] as String?,
      calificacionPromedio: json['calificacion_promedio']?.toString(),
      tituloSolicitud: json['titulo_solicitud'] as String?,
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
    required int idCotizacion,
    required int idSolicitud,
    required String monto,
    required String tiempoEstimado,
    required String descripcionTrabajo,
    required String estado,
    required String fechaCreacion,
    required String nombreTecnico,
    String? fotoTecnico,
    String? calificacionPromedio,
    String? tituloSolicitud,
    required this.estadoSolicitud,
  }) : super(
          idCotizacion: idCotizacion,
          idSolicitud: idSolicitud,
          monto: monto,
          tiempoEstimado: tiempoEstimado,
          descripcionTrabajo: descripcionTrabajo,
          estado: estado,
          fechaCreacion: fechaCreacion,
          nombreTecnico: nombreTecnico,
          fotoTecnico: fotoTecnico,
          calificacionPromedio: calificacionPromedio,
          tituloSolicitud: tituloSolicitud,
        );

  factory CotizacionDetalle.fromJson(Map<String, dynamic> json) {
    return CotizacionDetalle(
      idCotizacion: json['id_cotizacion'] as int,
      idSolicitud: json['id_solicitud'] as int,
      monto: json['monto'] as String,
      tiempoEstimado: json['tiempo_estimado'] as String,
      descripcionTrabajo: json['descripcion_trabajo'] as String,
      estado: json['estado'] as String,
      fechaCreacion: json['fecha_creacion'] as String,
      nombreTecnico: json['nombre_tecnico'] as String,
      fotoTecnico: json['foto_tecnico'] as String?,
      calificacionPromedio: json['calificacion_promedio']?.toString(),
      tituloSolicitud: json['titulo_solicitud'] as String,
      estadoSolicitud: json['estado_solicitud'] as String,
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
    return {
      'id_solicitud': idSolicitud,
      'monto': monto,
      'tiempo_estimado': tiempoEstimado,
      'descripcion_trabajo': descripcionTrabajo,
    };
  }
}
