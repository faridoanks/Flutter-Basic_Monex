class UsernameValidationModel {
  final String username;
  final int length;
  final bool isLengthValid;
  final bool hasLetter;
  final bool hasInvalidCharacter;
  final bool hasWhitespace;
  final bool isValid;

  const UsernameValidationModel({
    required this.username,
    required this.length,
    required this.isLengthValid,
    required this.hasLetter,
    required this.hasInvalidCharacter,
    required this.hasWhitespace,
    required this.isValid,
  });

  UsernameValidationModel copyWith({
    String? username,
    int? length,
    bool? isLengthValid,
    bool? hasLetter,
    bool? hasInvalidCharacter,
    bool? hasWhitespace,
    bool? isValid,
  }) {
    return UsernameValidationModel(
      username: username ?? this.username,
      length: length ?? this.length,
      isLengthValid: isLengthValid ?? this.isLengthValid,
      hasLetter: hasLetter ?? this.hasLetter,
      hasInvalidCharacter:
          hasInvalidCharacter ?? this.hasInvalidCharacter,
      hasWhitespace:
          hasWhitespace ?? this.hasWhitespace,
      isValid: isValid ?? this.isValid,
    );
  }
}