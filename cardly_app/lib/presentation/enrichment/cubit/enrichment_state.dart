import 'package:cardly_app/domain/entities/enrichment/enrichment_entity.dart';
import 'package:equatable/equatable.dart';

enum EnrichmentStatus { initial, loading, loaded, failure }

class EnrichmentState extends Equatable {
  final EnrichmentStatus status;
  final EnrichmentEntity? enrichment;
  final String? errorMessage;

  const EnrichmentState({
    this.status = EnrichmentStatus.initial,
    this.enrichment,
    this.errorMessage,
  });

  EnrichmentState copyWith({
    EnrichmentStatus? status,
    Object? enrichment = _nullValue,
    Object? errorMessage = _nullValue,
  }) => EnrichmentState(
    status: status ?? this.status,
    enrichment: identical(enrichment, _nullValue)
        ? this.enrichment
        : enrichment as EnrichmentEntity?,
    errorMessage: identical(errorMessage, _nullValue)
        ? this.errorMessage
        : errorMessage as String?,
  );

  @override
  List<Object?> get props => [status, enrichment, errorMessage];
}

const _nullValue = Object();
