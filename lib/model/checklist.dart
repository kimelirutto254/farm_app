class Checklist {
  final String chapter;
  final String subchapter;
  final String requirementCode;
  final String requirement;

  Checklist({
    required this.chapter,
    required this.subchapter,
    required this.requirementCode,
    required this.requirement,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      chapter: json['chapter'] ?? '',
      subchapter: json['subchapter'] ?? '',
      requirementCode: json['requirement_code'] ?? '',
      requirement: json['requirement'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'subchapter': subchapter,
      'requirement_code': requirementCode,
      'requirement': requirement,
    };
  }
}
