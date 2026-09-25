class LoginRequest {
  final String email;
  final String contrasena;

  LoginRequest({required this.email, required this.contrasena});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': contrasena,
      };
}

class LoginResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final UserModel usuario;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.usuario,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int,
      usuario:
          UserModel.fromJson(json['usuario'] as Map<String, dynamic>),
    );
  }
}

class UserModel {
  final int idUsuario;
  final String email;
  final String nombreCompleto;
  final String rol;
  final String? fotoPerfil;
  final String? telefono;
  final String? estado;
  final bool activo;

  UserModel({
    required this.idUsuario,
    required this.email,
    required this.nombreCompleto,
    required this.rol,
    this.fotoPerfil,
    this.telefono,
    this.estado,
    this.activo = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUsuario: json['id_usuario'] as int,
      email: json['email'] as String,
      nombreCompleto: json['nombre_completo'] as String,
      rol: json['rol'] as String,
      fotoPerfil: json['foto_perfil_url'] as String?,
      telefono: json['telefono'] as String?,
      estado: json['estado'] as String?,
      activo: (json['activo'] as bool?) ?? (json['estado'] == 'ACTIVO'),
    );
  }
}

class RegisterRequest {
  final String email;
  final String contrasena;
  final String nombreCompleto;
  final String rol;
  final String? telefono;

  RegisterRequest({
    required this.email,
    required this.contrasena,
    required this.nombreCompleto,
    required this.rol,
    this.telefono,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'email': email,
      'password': contrasena,
      'nombre_completo': nombreCompleto,
      'rol': rol,
    };
    if (telefono != null && telefono!.isNotEmpty) {
      map['telefono'] = telefono;
    }
    return map;
  }
}
