import 'package:cardly_app/data/datasources/local/auth_local_data_source.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';
import 'package:cardly_app/domain/usecase/auth/get_current_user_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/login_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/logout_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/register_usecase.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthLocalDataSource localStorage;
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;

  AuthCubit({
    required this.loginUsecase,
    required this.localStorage,
    required this.registerUsecase,
    required this.logoutUsecase,
    required this.getCurrentUserUsecase,
  }) : super(const AuthState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await loginUsecase(email, password);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failed,
          errorMessage: failure.message,
        ),
      ),
      (user) async {
        await localStorage.saveToken(user.accessToken!);
        await localStorage.saveUser(user);
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      },
    );
  }

  Future<void> register(UserEntity user) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await registerUsecase(user);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failed,
          errorMessage: failure.message,
        ),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> getUser() async {
    final result = await getCurrentUserUsecase();

    result.fold(
      (failure) => emit(state.copyWith(status: AuthStatus.unauthenticated)),
      (user) {
        if (user != null) {
          emit(state.copyWith(status: AuthStatus.authenticated, user: user));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      },
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await logoutUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failed,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.unauthenticated)),
    );
  }
}
