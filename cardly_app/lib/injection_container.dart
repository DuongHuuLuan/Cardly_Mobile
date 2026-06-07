import 'package:cardly_app/core/constants/app_constant.dart';
import 'package:cardly_app/core/network/auth_interceptor.dart';
import 'package:cardly_app/data/datasources/local/auth_local_data_source.dart';
import 'package:cardly_app/data/datasources/local/card_local_data_source.dart';
import 'package:cardly_app/data/datasources/local/contact_local_data_source.dart';
import 'package:cardly_app/data/datasources/local/database_helper.dart';
import 'package:cardly_app/data/datasources/mock/onboarding_mock_data_source.dart';
import 'package:cardly_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:cardly_app/data/datasources/remote/card_remote_data_source.dart';
import 'package:cardly_app/data/datasources/remote/contact_remote_data_source.dart';
import 'package:cardly_app/data/datasources/remote/enrichment_remote_data_source.dart';
import 'package:cardly_app/data/repositories/auth_repository_impl.dart';
import 'package:cardly_app/data/repositories/card_repository_impl.dart';
import 'package:cardly_app/data/repositories/contact_repository_impl.dart';
import 'package:cardly_app/data/repositories/enrichment_repository_impl.dart';
import 'package:cardly_app/data/repositories/onboarding_repository_impl.dart';
import 'package:cardly_app/data/services/auth_service.dart';
import 'package:cardly_app/data/services/card_service.dart';
import 'package:cardly_app/data/services/contact_service.dart';
import 'package:cardly_app/data/services/enrichment_service.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:cardly_app/domain/repositories/card_repository.dart';
import 'package:cardly_app/domain/repositories/contact_repository.dart';
import 'package:cardly_app/domain/repositories/enrichment_repository.dart';
import 'package:cardly_app/domain/repositories/onboarding_repository.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/forgot_password_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/resend_otp_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/reset_password_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/verify_otp_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/forgot-password/verify_reset_otp_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/get_current_user_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/get_onboardin_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/get_profile_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/login_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/logout_usecase.dart';
import 'package:cardly_app/domain/usecase/auth/register_usecase.dart';
import 'package:cardly_app/domain/usecase/card/scan_card_usecase.dart';
import 'package:cardly_app/domain/usecase/card/update_card_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/delete_contact_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/get_contacts_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/save_contact_usecase.dart';
import 'package:cardly_app/domain/usecase/enrichment/enrichment_usecase.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/enrichment/cubit/enrichment_cubit.dart';
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
        receiveTimeout: Duration(seconds: 120),
      ),
    );
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );

    dio.interceptors.add(AuthInterceptor());
    return dio;
  });

  // Service
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<Dio>()));
  getIt.registerLazySingleton<CardService>(() => CardService(getIt<Dio>()));
  getIt.registerLazySingleton<ContactService>(
    () => ContactService(getIt<Dio>()),
  );
  getIt.registerLazySingleton<EnrichmentService>(
    () => EnrichmentService(getIt<Dio>()),
  );

  // Local Data base
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  // Mock Data Source
  getIt.registerLazySingleton<OnboardingMockDataSource>(
    () => OnboardingMockDataSource(),
  );

  // Local Data Source
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<ContactLocalDataSource>(
    () => ContactLocalDataSourceImpl(getIt<DatabaseHelper>()),
  );
  getIt.registerLazySingleton<CardLocalDataSource>(
    () => CardLocalDataSourceImpl(getIt<DatabaseHelper>()),
  );

  // Remote Data Source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<AuthService>(), userMock: false),
  );
  getIt.registerLazySingleton<CardRemoteDataSource>(
    () => CardRemoteDataSource(getIt<CardService>(), userMock: false),
  );
  getIt.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSource(getIt<ContactService>(), userMock: false),
  );
  getIt.registerLazySingleton<EnrichmentRemoteDataSource>(
    () =>
        EnrichmentRemoteDataSource(getIt<EnrichmentService>(), userMock: false),
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
    () => CardRepositoryImpl(
      remoteDataSource: getIt<CardRemoteDataSource>(),
      localDataSource: getIt<CardLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(
      remoteDataSource: getIt<ContactRemoteDataSource>(),
      localDataSource: getIt<ContactLocalDataSource>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<EnrichmentRepository>(
    () => EnrichmentRepositoryImpl(
      remoteDataSource: getIt<EnrichmentRemoteDataSource>(),
    ),
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
  getIt.registerLazySingleton<SaveContactUsecase>(
    () => SaveContactUsecase(repository: getIt<ContactRepository>()),
  );
  getIt.registerLazySingleton<GetContactsUsecase>(
    () => GetContactsUsecase(repository: getIt<ContactRepository>()),
  );
  getIt.registerLazySingleton<DeleteContactUsecase>(
    () => DeleteContactUsecase(repository: getIt<ContactRepository>()),
  );
  getIt.registerLazySingleton<ForgotPasswordUsecase>(
    () => ForgotPasswordUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<VerifyOtpUsecase>(
    () => VerifyOtpUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ResendOtpUsecase>(
    () => ResendOtpUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<ResetPasswordUsecase>(
    () => ResetPasswordUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GetProfileUsecase>(
    () => GetProfileUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<VerifyResetOtpUsecase>(
    () => VerifyResetOtpUsecase(repository: getIt<AuthRepository>()),
  );
  // Use Case enrichment
  getIt.registerLazySingleton<EnrichmentUsecase>(
    () => EnrichmentUsecase(repository: getIt<EnrichmentRepository>()),
  );

  // Cubit
  getIt.registerFactory(() => OnboardingCubit(getIt()));
  getIt.registerFactory(
    () => AuthCubit(
      localStorage: getIt<AuthLocalDataSource>(),
      loginUsecase: getIt<LoginUsecase>(),
      getProfileUsecase: getIt<GetProfileUsecase>(),
      registerUsecase: getIt<RegisterUsecase>(),
      logoutUsecase: getIt<LogoutUsecase>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),

      forgotPasswordUsecase: getIt<ForgotPasswordUsecase>(),
      verifyOtpUsecase: getIt<VerifyOtpUsecase>(),
      resendOtpUsecase: getIt<ResendOtpUsecase>(),
      resetPasswordUsecase: getIt<ResetPasswordUsecase>(),
      verifyResetOtpUsecase: getIt<VerifyResetOtpUsecase>(),
    ),
  );
  getIt.registerFactory(
    () => HomeCubit(getContactsUsecase: getIt<GetContactsUsecase>()),
  );
  getIt.registerFactory(
    () => ScanCubit(scanCardUsecase: getIt<ScanCardUsecase>()),
  );

  getIt.registerFactory(
    () => ContactCubit(
      getContacts: getIt<GetContactsUsecase>(),
      saveContact: getIt<SaveContactUsecase>(),
      deleteContact: getIt<DeleteContactUsecase>(),
      enrichment: getIt<EnrichmentUsecase>(),
    ),
  );
  getIt.registerFactory(
    () => EnrichmentCubit(enrichmentUsecase: getIt<EnrichmentUsecase>()),
  );
}
