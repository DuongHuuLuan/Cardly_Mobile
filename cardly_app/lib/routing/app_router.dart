import 'package:cardly_app/injection_container.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/forgot-password/forgot_password_screen.dart';
import 'package:cardly_app/presentation/auth/forgot-password/input_otp_screen.dart';
import 'package:cardly_app/presentation/auth/forgot-password/reset_password_screen.dart';
import 'package:cardly_app/presentation/auth/view/login_screen.dart';
import 'package:cardly_app/presentation/auth/view/register_screen.dart';
import 'package:cardly_app/presentation/home/cubit/home_cubit.dart';
import 'package:cardly_app/presentation/home/view/home_screen.dart';
import 'package:cardly_app/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:cardly_app/presentation/onboarding/views/onboarding_screen.dart';
import 'package:cardly_app/presentation/profile/profile_screen.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/presentation/scan/sub_screens/custom_camera/custom_camera_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_edit/edit_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_preview/preview_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_preview/review_screen.dart';
import 'package:cardly_app/presentation/scan/scan_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_upload/upload_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_upload/upload_success_screen.dart';
import 'package:cardly_app/presentation/splash/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(
        path: "/splash",
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: "/onboarding",
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<OnboardingCubit>()..loadData(),
          child: const OnboardingScreen(),
        ),
      ),

      GoRoute(
        path: "/login",
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: "/register",
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: "/forgot-password",
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: "/verify-otp",
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: OtpVerificationScreen(),
        ),
      ),
      GoRoute(
        path: "/reset-password",
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: ResetPasswordScreen(),
        ),
      ),

      GoRoute(
        path: "/home",
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<AuthCubit>()..getUser()),
            BlocProvider(create: (context) => getIt<HomeCubit>()),
          ],
          child: const HomePage(),
        ),
      ),

      GoRoute(
        path: "/scan",
        builder: (context, state) {
          return BlocProvider.value(
            value: getIt<ScanCubit>(),
            child: const ScanScreen(),
          );
        },
        routes: [
          GoRoute(
            path: "review",
            builder: (context, state) {
              return BlocProvider.value(
                value: state.extra as ScanCubit,
                child: const ReviewScreen(),
              );
            },
          ),
          GoRoute(
            path: "custom-camera",
            builder: (context, state) {
              return BlocProvider.value(
                value: state.extra as ScanCubit,
                child: const CustomCameraScreen(),
              );
            },
          ),
          GoRoute(
            path: "upload",
            builder: (context, state) {
              return BlocProvider.value(
                value: state.extra as ScanCubit,
                child: const UploadScreen(),
              );
            },
          ),
          GoRoute(
            path: "upload-success",
            builder: (context, state) {
              return BlocProvider.value(
                value: state.extra as ScanCubit,
                child: const UploadSuccessScreen(),
              );
            },
          ),

          GoRoute(
            path: "edit",
            builder: (context, state) {
              return BlocProvider.value(
                value: state.extra as ScanCubit,
                child: const EditScreen(),
              );
            },
          ),
          GoRoute(
            path: "preview",
            builder: (context, state) {
              return BlocProvider.value(
                value: state.extra as ScanCubit,
                child: const PreviewScreen(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: "/profile",
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const ProfileScreen(),
        ),
      ),
    ],
  );
}
