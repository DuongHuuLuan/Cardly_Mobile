import 'package:equatable/equatable.dart';

class EnrichmentEntity extends Equatable {
  final String? professionalBrief;
  final List<String>? keywords;
  final List<String>? highlights;
  final String? generationStatus;

  const EnrichmentEntity({
    this.professionalBrief,
    this.keywords,
    this.highlights,
    this.generationStatus,
  });

  EnrichmentEntity copyWith({
    String? professionalBrief,
    List<String>? keywords,
    List<String>? highlights,
    String? generationStatus,
  }) {
    return EnrichmentEntity(
      professionalBrief: professionalBrief ?? this.professionalBrief,
      keywords: keywords ?? this.keywords,
      highlights: highlights ?? this.highlights,
      generationStatus: generationStatus ?? this.generationStatus,
    );
  }

  @override
  List<Object?> get props => [
    professionalBrief,
    keywords,
    highlights,
    generationStatus,
  ];
}
