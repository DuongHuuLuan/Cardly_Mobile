import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/injection_container.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/contact/view/contact_add/contact_add_screen.dart';
import 'package:cardly_app/presentation/contact/view/contact_screen.dart';
import 'package:cardly_app/presentation/digital_card/digital_card_screen.dart';
import 'package:cardly_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:cardly_app/presentation/auth/forgot-password/forgot_password_screen.dart';
import 'package:cardly_app/presentation/auth/forgot-password/input_otp_screen.dart';
import 'package:cardly_app/presentation/auth/forgot-password/reset_password_screen.dart';
import 'package:cardly_app/presentation/auth/view/login_screen.dart';
import 'package:cardly_app/presentation/auth/view/register_screen.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/contact_detail_screen.dart';
import 'package:cardly_app/presentation/home/view/home_screen.dart';
import 'package:cardly_app/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:cardly_app/presentation/onboarding/views/onboarding_screen.dart';
import 'package:cardly_app/presentation/profile/edit-profile/edit_profile_screen.dart';
import 'package:cardly_app/presentation/profile/profile_screen.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/presentation/scan/sub_screens/custom_camera/custom_camera_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_document/document_detail_screen.dart';
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
    initialLocation: SplashScreen.routerName,
    routes: [
      GoRoute(
        path: SplashScreen.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: OnboardingScreen.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<OnboardingCubit>()..loadData(),
          child: const OnboardingScreen(),
        ),
      ),

      GoRoute(
        path: LoginPage.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: RegisterPage.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: ForgotPasswordScreen.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: OtpVerificationScreen.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: OtpVerificationScreen(),
        ),
      ),
      GoRoute(
        path: ResetPasswordScreen.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: ResetPasswordScreen(),
        ),
      ),

      GoRoute(
        path: HomePage.routerName,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<AuthCubit>()..getUser()),
            BlocProvider(
              create: (context) => getIt<ContactCubit>()..loadContacts(),
            ),
          ],
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: ContactScreen.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ContactCubit>()..loadContacts(),
          child: const ContactScreen(),
        ),
      ),
      GoRoute(
        path: ContactDetailScreen.routerName,
        builder: (context, state) {
          final contact = state.extra as BusinessCardEntity;
          return BlocProvider(
            create: (context) => getIt<ContactCubit>(),
            child: ContactDetailScreen(contact: contact),
          );
        },
      ),

      GoRoute(
        path: ContactAddScreen.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ContactCubit>(),
          child: ContactAddScreen(),
        ),
      ),

      GoRoute(
        path: ScanScreen.routerName,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<ScanCubit>(),
            child: const ScanScreen(),
          );
        },
        routes: [
          GoRoute(
            path: ReviewScreen.routerName,
            builder: (context, state) {
              return BlocProvider.value(
                value: state.extra as ScanCubit,
                child: const ReviewScreen(),
              );
            },
          ),
          GoRoute(
            path: CustomCameraScreen.routerName,
            builder: (context, state) {
              return BlocProvider.value(
                value: state.extra as ScanCubit,
                child: const CustomCameraScreen(),
              );
            },
          ),
          GoRoute(
            path: UploadScreen.routerName,
            builder: (context, state) {
              return BlocProvider.value(
                value: state.extra as ScanCubit,
                child: const UploadScreen(),
              );
            },
          ),
          GoRoute(
            path: UploadSuccessScreen.routerName,
            builder: (context, state) {
              return BlocProvider.value(
                value: state.extra as ScanCubit,
                child: const UploadSuccessScreen(),
              );
            },
          ),
          GoRoute(
            path: DocumentDetailScreen.routerName,
            builder: (context, state) {
              final documents = state.extra as List<ScannedDocument>;
              return BlocProvider(
                create: (_) => getIt<ContactCubit>(),
                child: DocumentDetailScreen(documents: documents),
              );
            },
          ),

          GoRoute(
            path: EditScreen.routerName,
            builder: (context, state) {
              return BlocProvider.value(
                value: state.extra as ScanCubit,
                child: const EditScreen(),
              );
            },
          ),
          GoRoute(
            path: PreviewScreen.routerName,
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
        path: ProfileScreen.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>()..getUser(),
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: EditProfileScreen.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>()..getUser(),
          child: const EditProfileScreen(),
        ),
      ),

      GoRoute(
        path: DigitalCardScreen.routerName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>()..getUser(),
          child: const DigitalCardScreen(),
        ),
      ),
    ],
  );
}
