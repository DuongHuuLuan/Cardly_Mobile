import 'package:cardly_app/domain/usecase/enrichment/enrichment_usecase.dart';
import 'package:cardly_app/presentation/enrichment/cubit/enrichment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnrichmentCubit extends Cubit<EnrichmentState> {
  final EnrichmentUsecase enrichmentUsecase;

  EnrichmentCubit({required this.enrichmentUsecase})
    : super(const EnrichmentState());

  Future<void> enrich(Map<String, dynamic> data) async {
    emit(state.copyWith(status: EnrichmentStatus.loading));
    final result = await enrichmentUsecase.enrich(data);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: EnrichmentStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (enriched) => emit(
        state.copyWith(status: EnrichmentStatus.loaded, enrichment: enriched),
      ),
    );
  }
}
