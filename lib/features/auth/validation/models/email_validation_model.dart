class EmailValidationModel {
  final String email;
  final bool hasOneAt;
  final bool hasWhitespace;
  final bool hasUsername;
  final bool hasDomain;
  final bool hasDotAfterDomain;
  final bool hasValidTld;
  final bool isValid;

  const EmailValidationModel({
    required this.email,
    required this.hasOneAt,
    required this.hasWhitespace,
    required this.hasUsername,
    required this.hasDomain,
    required this.hasDotAfterDomain,
    required this.hasValidTld,
    required this.isValid,
  });

  EmailValidationModel copyWith({
    String? email,
    bool? hasOneAt,
    bool? hasWhitespace,
    bool? hasUsername,
    bool? hasDomain,
    bool? hasDotAfterDomain,
    bool? hasValidTld,
    bool? isValid,
  }) {
    return EmailValidationModel(
      email: email ?? this.email,
      hasOneAt: hasOneAt ?? this.hasOneAt,
      hasWhitespace: hasWhitespace ?? this.hasWhitespace,
      hasUsername: hasUsername ?? this.hasUsername,
      hasDomain: hasDomain ?? this.hasDomain,
      hasDotAfterDomain: hasDotAfterDomain ?? this.hasDotAfterDomain,
      hasValidTld: hasValidTld ?? this.hasValidTld,
      isValid: isValid ?? this.isValid,
    );
  }
}