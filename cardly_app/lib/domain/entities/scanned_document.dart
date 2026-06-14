import 'package:cardly_app/domain/entities/business_card_entity.dart';

sealed class ScannedDocument {
  final String id;
  final List<String> images;

  const ScannedDocument({required this.id, this.images = const []});
}

class BusinessCardDocument extends ScannedDocument {
  final BusinessCardEntity card;
  const BusinessCardDocument({
    required super.id,
    required this.card,
    super.images,
  });
  BusinessCardDocument copyWith({
    String? id,
    BusinessCardEntity? card,
    List<String>? images,
  }) => BusinessCardDocument(
    id: id ?? this.id,
    card: card ?? this.card,
    images: images ?? this.images,
  );
}
