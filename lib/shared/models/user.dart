import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String email;
  final String name;
  final String role;
  final String? tipo;
  final int? bossId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.tipo,
    this.bossId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // Helper methods
  bool get isComercial => role == 'COMERCIAL';
  bool get isJefeEquipo => role == 'JEFE_EQUIPO';
  bool get isAdministrador => role == 'ADMINISTRADOR';

  bool get isCaptacion => tipo == 'CAPTACIÓN';
  bool get isFidelizacion => tipo == 'FIDELIZACIÓN';
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final bool success;
  final User? user;
  final String? error;

  const LoginResponse({
    required this.success,
    this.user,
    this.error,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}