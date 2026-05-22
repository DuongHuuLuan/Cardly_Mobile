import 'package:cardly_app/core/constants/app_constant.dart';
import 'package:cardly_app/data/datasources/local/auth_local_data_source.dart';
import 'package:cardly_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:cardly_app/data/datasources/remote/card_remote_data_source.dart';
import 'package:cardly_app/data/repositories/auth_repository_impl.dart';
import 'package:cardly_app/data/repositories/card_repository_impl.dart';
import 'package:cardly_app/data/services/auth_service.dart';
import 'package:cardly_app/data/services/card_service.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:cardly_app/domain/repositories/card_repository.dart';
import 'package:cardly_app/domain/usecase/auth/get_current_user_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/login_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/logout_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/register_usecase.dart';
import 'package:cardly_app/domain/usecase/card/scan_card_usecase.dart';
import 'package:cardly_app/domain/usecase/card/update_card_usecase.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/home/cubit/home_cubit.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: AppConstant.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  );

  // Service
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<Dio>()));
  getIt.registerLazySingleton<CardService>(() => CardService(getIt<Dio>()));

  // Data Source
  getIt.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource());

  // Remote Data Source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<AuthService>(), userMock: true),
  );
  getIt.registerLazySingleton<CardRemoteDataSource>(
    () => CardRemoteDataSource(getIt<CardService>(), userMock: true),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<CardRepository>(
    () => CardRepositoryImpl(remoteDataSource: getIt<CardRemoteDataSource>()),
  );

  // Usecases
  getIt.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GetCurrentUserUsecase>(
    () => GetCurrentUserUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ScanCardUsecase>(
    () => ScanCardUsecase(repository: getIt<CardRepository>()),
  );
  getIt.registerLazySingleton<UpdateCardUsecase>(
    () => UpdateCardUsecase(repository: getIt<CardRepository>()),
  );

  // Cubit
  getIt.registerFactory(
    () => AuthCubit(
      loginUsecase: getIt<LoginUsecase>(),
      registerUsecase: getIt<RegisterUsecase>(),
      logoutUsecase: getIt<LogoutUsecase>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
    ),
  );
  getIt.registerFactory(() => HomeCubit());
  getIt.registerFactory(
    () => ScanCubit(scanCardUsecase: getIt<ScanCardUsecase>()),
  );
}
