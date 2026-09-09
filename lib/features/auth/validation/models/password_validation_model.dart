class PasswordValidationModel {
  final String password;

  final int length;

  final bool isLengthValid;

  final bool hasUppercase;

  final bool hasLowercase;

  final bool hasNumber;

  final bool hasSpecialCharacter;

  final bool hasWhitespace;

  final bool isValid;

  PasswordValidationModel({
    required this.password,
    required this.length,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSpecialCharacter,
    required this.hasWhitespace,
    required this.isLengthValid,
    required this.isValid,
  });

  PasswordValidationModel copyWith({
    String? password,
    int? length,
    bool? isLengthValid,
    bool? hasUppercase,
    bool? hasLowercase,
    bool? hasNumber,
    bool? hasSpecialCharacter,
    bool? hasWhitespace,
    bool? isValid,
  }) {
    return PasswordValidationModel(
      password: password ?? this.password,
      length: length ?? this.length,
      isLengthValid: isLengthValid ?? this.isLengthValid,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasLowercase: hasLowercase ?? this.hasLowercase,
      hasNumber: hasNumber ?? this.hasNumber,
      hasSpecialCharacter: hasSpecialCharacter ?? this.hasSpecialCharacter,
      hasWhitespace: hasWhitespace ?? this.hasWhitespace,
      isValid: isValid ?? this.isValid,
    );
  }
}
