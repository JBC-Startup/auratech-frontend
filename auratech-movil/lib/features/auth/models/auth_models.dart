class LoginRequest {
  final String email;
  final String contrasena;

  LoginRequest({required this.email, required this.contrasena});

  Map<String, dynamic> toJson() => {
        'email': email,
        'contrasena': contrasena,
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
  final bool activo;

  UserModel({
    required this.idUsuario,
    required this.email,
    required this.nombreCompleto,
    required this.rol,
    this.fotoPerfil,
    this.activo = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUsuario: json['id_usuario'] as int,
      email: json['email'] as String,
      nombreCompleto: json['nombre_completo'] as String,
      rol: json['rol'] as String,
      fotoPerfil: json['foto_perfil_url'] as String?,
      activo: json['activo'] as bool? ?? true,
    );
  }
}

class RegisterRequest {
  final String email;
  final String contrasena;
  final String nombreCompleto;
  final String rol;

  RegisterRequest({
    required this.email,
    required this.contrasena,
    required this.nombreCompleto,
    required this.rol,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'contrasena': contrasena,
        'nombre_completo': nombreCompleto,
        'rol': rol,
      };
}
