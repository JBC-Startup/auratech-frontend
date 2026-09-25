class PagoResumen {
  final int idPago;
  final String monto;
  final String metodoPago;
  final String estado;
  final bool confirmadoCliente;
  final bool confirmadoTecnico;
  final String fechaRegistro;
  final String? fechaConfirmacion;
  final String registradoPor;

  PagoResumen({
    required this.idPago,
    required this.monto,
    required this.metodoPago,
    required this.estado,
    required this.confirmadoCliente,
    required this.confirmadoTecnico,
    required this.fechaRegistro,
    this.fechaConfirmacion,
    required this.registradoPor,
  });

  factory PagoResumen.fromJson(Map<String, dynamic> json) {
    final bool confCliente = json['confirmado_cliente'] as bool? ?? false;
    final bool confTecnico = json['confirmado_tecnico'] as bool? ?? false;
    return PagoResumen(
      idPago: json['id_pago'] as int,
      monto: json['monto'] as String? ?? '0.00',
      metodoPago: json['metodo_pago'] as String? ?? 'OTRO',
      estado: json['estado'] as String? ?? 'PENDIENTE',
      confirmadoCliente: confCliente,
      confirmadoTecnico: confTecnico,
      fechaRegistro: json['fecha_registro'] as String? ?? '',
      fechaConfirmacion: json['fecha_confirmacion'] as String?,
      registradoPor: json['registrado_por'] as String? ??
          (confCliente ? 'Cliente' : 'Técnico'),
    );
  }

  bool get isPending => estado == 'PENDIENTE';
  bool get isConfirmed => estado == 'CONFIRMADO';
  bool get isRejected => estado == 'RECHAZADO';
}

class CreatePagoRequest {
  final String monto;
  final String metodoPago;

  CreatePagoRequest({
    required this.monto,
    required this.metodoPago,
  });

  String get formattedMonto {
    final val = double.tryParse(monto) ?? 0.0;
    return val.toStringAsFixed(2);
  }

  Map<String, dynamic> toJson() => {
        'monto': formattedMonto,
        'metodo_pago': metodoPago,
      };
}

class MetodosPago {
  static const String efectivo = 'EFECTIVO';
  static const String transferencia = 'TRANSFERENCIA';
  static const String yape = 'YAPE';
  static const String plin = 'PLIN';
  static const String otro = 'OTRO';

  static const List<String> all = [
    efectivo,
    transferencia,
    yape,
    plin,
    otro,
  ];

  static String displayName(String metodo) {
    switch (metodo) {
      case efectivo:
        return 'Efectivo';
      case transferencia:
        return 'Transferencia';
      case yape:
        return 'Yape';
      case plin:
        return 'Plin';
      case otro:
        return 'Otro';
      default:
        return metodo;
    }
  }
}
