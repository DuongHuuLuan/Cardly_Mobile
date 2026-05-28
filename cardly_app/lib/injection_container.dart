import 'package:cardly_app/core/constants/app_constant.dart';
import 'package:cardly_app/data/datasources/local/auth_local_data_source.dart';
import 'package:cardly_app/data/datasources/mock/onboarding_mock_data_source.dart';
import 'package:cardly_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:cardly_app/data/datasources/remote/card_remote_data_source.dart';
import 'package:cardly_app/data/repositories/auth_repository_impl.dart';
import 'package:cardly_app/data/repositories/card_repository_impl.dart';
import 'package:cardly_app/data/repositories/onboarding_repository_impl.dart';
import 'package:cardly_app/data/services/auth_service.dart';
import 'package:cardly_app/data/services/card_service.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:cardly_app/domain/repositories/card_repository.dart';
import 'package:cardly_app/domain/repositories/onboarding_repository.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/forgot_password_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/reset_password_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/verify_otp_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/get_current_user_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/get_onboardin_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/login_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/logout_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/register_usecase.dart';
import 'package:cardly_app/domain/usecase/card/scan_card_usecase.dart';
import 'package:cardly_app/domain/usecase/card/update_card_usecase.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/home/cubit/home_cubit.dart';
import 'package:cardly_app/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstant.baseUrl,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = getIt<SharedPreferences>();
          final token = prefs.getString("access_token");
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          handler.next(options);
        },
      ),
    );
    return dio;
  });

  // Service
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<Dio>()));
  getIt.registerLazySingleton<CardService>(() => CardService(getIt<Dio>()));

  // Data Source
  getIt.registerLazySingleton<OnboardingMockDataSource>(
    () => OnboardingMockDataSource(),
  );
  // Local Data Source
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt<SharedPreferences>()),
  );
  // Remote Data Source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<AuthService>(), userMock: true),
  );
  getIt.registerLazySingleton<CardRemoteDataSource>(
    () => CardRemoteDataSource(getIt<CardService>(), userMock: true),
  );

  // Repositories
  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(
      mockDataSource: getIt<OnboardingMockDataSource>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<CardRepository>(
    () => CardRepositoryImpl(remoteDataSource: getIt<CardRemoteDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton<GetOnboardingData>(
    () => GetOnboardingData(getIt<OnboardingRepository>()),
  );
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
  getIt.registerLazySingleton<ForgotPasswordUsecase>(
    () => ForgotPasswordUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<VerifyOtpUsecase>(
    () => VerifyOtpUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ResetPasswordUsecase>(
    () => ResetPasswordUsecase(repository: getIt<AuthRepository>()),
  );

  // Cubit
  getIt.registerFactory(() => OnboardingCubit(getIt()));
  getIt.registerFactory(
    () => AuthCubit(
      localStorage: getIt<AuthLocalDataSource>(),
      loginUsecase: getIt<LoginUsecase>(),
      registerUsecase: getIt<RegisterUsecase>(),
      logoutUsecase: getIt<LogoutUsecase>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),

      forgotPasswordUsecase: getIt<ForgotPasswordUsecase>(),
      verifyOtpUsecase: getIt<VerifyOtpUsecase>(),
      resetPasswordUsecase: getIt<ResetPasswordUsecase>(),
    ),
  );
  getIt.registerFactory(() => HomeCubit());
  getIt.registerFactory(
    () => ScanCubit(scanCardUsecase: getIt<ScanCardUsecase>()),
  );
}
