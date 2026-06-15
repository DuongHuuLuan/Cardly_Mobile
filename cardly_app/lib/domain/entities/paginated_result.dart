import 'package:cardly_app/domain/entities/business_card_entity.dart';

class PaginatedResult {
  final List<BusinessCardEntity> items;
  final bool hasMore;

  const PaginatedResult({required this.items, required this.hasMore});
}
