import 'package:cardly_app/core/cubit/deep_link/deep_link_state.dart';
import 'package:cardly_app/domain/usecase/deep_link/clear_pending_deep_link_usecase.dart';
import 'package:cardly_app/domain/usecase/deep_link/resolve_pending_deep_link_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeepLinkCubit extends Cubit<DeepLinkState> {
  final ResolvePendingDeepLinkUsecase resolveUsecase;
  final ClearPendingDeepLinkUsecase clearUsecase;

  DeepLinkCubit({required this.resolveUsecase, required this.clearUsecase})
    : super(DeepLinkInitial());

  Future<void> checkPendingLink() async {
    final result = await resolveUsecase.call();
    result.fold((_) => null, (link) {
      if (link != null) {
        emit(DeepLinkDetected(link));
        clearUsecase.call();
      }
    });
  }
}
