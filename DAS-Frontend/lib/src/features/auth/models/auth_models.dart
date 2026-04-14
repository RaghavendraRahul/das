enum UserRole {
  admin('ADMIN', 'Admin'),
  employee('EMPLOYEE', 'Employee'),
  manager('MANAGER', 'Manager'),
  teamLead('TEAMLEAD', 'Team Lead');

  final String value;
  final String displayName;

  const UserRole(this.value, this.displayName);

  bool get isAdmin => this == UserRole.admin;
  bool get isManager => this == UserRole.manager;
  bool get isTeamLead => this == UserRole.teamLead;
  bool get isEmployee => this == UserRole.employee;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value.toUpperCase() == value.toUpperCase().replaceAll('_', ''),
      orElse: () => UserRole.employee,
    );
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final String refresh;
  final String access;
  final int userId;
  final String role;
  final String email;
  final String themePreference;
  final String? quickNotesLabel;

  LoginResponse({
    required this.refresh,
    required this.access,
    required this.userId,
    required this.role,
    required this.email,
    required this.themePreference,
    this.quickNotesLabel,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      refresh: json['refresh'] as String,
      access: json['access'] as String,
      userId: json['user_id'] as int,
      role: json['role'] as String,
      email: json['email'] as String,
      themePreference: json['theme_preference'] as String,
      quickNotesLabel: json['quick_notes_label'] as String?,
    );
  }
}

class SignupRequest {
  final String email;
  final String password;
  final String role;

  SignupRequest({
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
    };
  }
}

class SignupResponse {
  final String message;
  final String email;

  SignupResponse({
    required this.message,
    required this.email,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      message: json['message'] as String,
      email: json['email'] as String,
    );
  }
}

class VerifySignupRequest {
  final String email;
  final String otp;

  VerifySignupRequest({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}

class VerifySignupResponse {
  final String message;
  final String email;
  final String role;

  VerifySignupResponse({
    required this.message,
    required this.email,
    required this.role,
  });

  factory VerifySignupResponse.fromJson(Map<String, dynamic> json) {
    return VerifySignupResponse(
      message: json['message'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class ForgotPasswordResponse {
  final String message;

  ForgotPasswordResponse({required this.message});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'] as String,
    );
  }
}

class ResetPasswordRequest {
  final String email;
  final String otp;
  final String newPassword;

  ResetPasswordRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'new_password': newPassword,
    };
  }
}

class ResetPasswordResponse {
  final String message;

  ResetPasswordResponse({required this.message});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      message: json['message'] as String,
    );
  }
}
