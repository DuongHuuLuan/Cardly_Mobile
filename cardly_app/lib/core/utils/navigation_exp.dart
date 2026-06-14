import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/domain/entities/scanned_document.dart';
import 'package:cardly_app/domain/entities/user_entity.dart';
import 'package:cardly_app/presentation/auth/forgot-password/forgot_password_screen.dart';
import 'package:cardly_app/presentation/auth/forgot-password/input_otp_screen.dart';
import 'package:cardly_app/presentation/auth/forgot-password/reset_password_screen.dart';
import 'package:cardly_app/presentation/auth/view/login_screen.dart';
import 'package:cardly_app/presentation/auth/view/register_screen.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_cubit.dart';
import 'package:cardly_app/presentation/contact/view/contact_add/contact_add_screen.dart';

import 'package:cardly_app/presentation/contact/view/contact_screen.dart';
import 'package:cardly_app/presentation/digital_card/digital_card_screen.dart';
import 'package:cardly_app/presentation/enrichment/enrichment_screen.dart';
import 'package:cardly_app/presentation/home/view/home_screen.dart';
import 'package:cardly_app/presentation/onboarding/views/onboarding_screen.dart';
import 'package:cardly_app/presentation/profile/edit-profile/edit_profile_screen.dart';
import 'package:cardly_app/presentation/profile/profile_screen.dart';
import 'package:cardly_app/presentation/scan/cubit/scan_cubit.dart';
import 'package:cardly_app/presentation/scan/scan_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/custom_camera/custom_camera_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_document/document_detail_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_edit/edit_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_preview/preview_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_preview/review_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_upload/upload_screen.dart';
import 'package:cardly_app/presentation/scan/sub_screens/scan_upload/upload_success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

extension AppNavigation on BuildContext {
  void goToLogin() => push(LoginPage.routerName);
  void goToRegister() => push(RegisterPage.routerName);
  void goToForgotPassword() => push(ForgotPasswordScreen.routerName);
  void goToOtpVerificationRegister(UserEntity user) => push(
    OtpVerificationScreen.routerName,
    extra: <String, dynamic>{
      'email': user.email,
      'isRegistration': true,
      'user': user,
    },
  );

  void goToOtpVerificationForgotPassword(String email) => push(
    OtpVerificationScreen.routerName,
    extra: <String, dynamic>{'email': email, 'isRegistration': false},
  );
  void goToResetPassword(String email, String resetToken) => push(
    ResetPasswordScreen.routerName,
    extra: <String, String>{"email": email, "resetToken": resetToken},
  );

  void goToOnboarding() => push(OnboardingScreen.routerName);

  void goToHome() => push(HomePage.routerName);

  void goToScan() => push(ScanScreen.routerName);
  void goToScanCamera(ScanCubit cubit) =>
      push('/scan/${CustomCameraScreen.routerName}', extra: cubit);
  void goToScanPreview(ScanCubit cubit) =>
      push('/scan/${PreviewScreen.routerName}', extra: cubit);
  Future<T?> goToScanEdit<T>(ScanCubit cubit) =>
      push<T>('/scan/${EditScreen.routerName}', extra: cubit);
  Future<T?> goToScanReview<T>(ScanCubit cubit) =>
      push<T>('/scan/${ReviewScreen.routerName}', extra: cubit);
  void goToScanUpload(ScanCubit cubit) =>
      push('/scan/${UploadScreen.routerName}', extra: cubit);
  void goToScanUploadSuccess(ScanCubit cubit) =>
      push('/scan/${UploadSuccessScreen.routerName}', extra: cubit);
  void goToScanDocumentDetail(List<ScannedDocument> docs) =>
      push('/scan/${DocumentDetailScreen.routerName}', extra: docs);

  void goToProfile() => push(ProfileScreen.routerName);
  void goToEditProfile() => push(EditProfileScreen.routerName);

  void goToContact() => push(ContactScreen.routerName);
  void goToContactAdd() => push(ContactAddScreen.routerName);
  void goToContactDetail(String id) => push('/contact-detail/$id');

  void goToDigitalCard() => push(DigitalCardScreen.routerName);

  Future<T?> goToEnrichment<T>(
    BusinessCardEntity card,
    Map<String, dynamic> data,
    ContactCubit contactCubit,
  ) => push<T>(
    EnrichmentScreen.routerName,
    extra: <String, dynamic>{
      'card': card,
      'data': data,
      'contactCubit': contactCubit,
    },
  );
}
