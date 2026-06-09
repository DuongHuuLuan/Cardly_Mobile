class Onboarding {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;

  Onboarding({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  Onboarding copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
  }) {
    return Onboarding(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
