import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_loading_state.dart';

class AppLoadingCubit extends Cubit<AppLoadingState> {
  AppLoadingCubit() : super(const AppLoadingState());

  void show({String? message}) {
    emit(AppLoadingState(isLoading: true, message: message));
  }

  void hide() {
    emit(const AppLoadingState());
  }
}
