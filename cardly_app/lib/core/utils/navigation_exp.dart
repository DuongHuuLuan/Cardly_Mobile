import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';
import 'package:cardly_app/presentation/auth/forgot-password/forgot_password_screen.dart';
import 'package:cardly_app/presentation/auth/forgot-password/input_otp_screen.dart';
import 'package:cardly_app/presentation/auth/forgot-password/reset_password_screen.dart';
import 'package:cardly_app/presentation/auth/view/login_screen.dart';
import 'package:cardly_app/presentation/auth/view/register_screen.dart';
import 'package:cardly_app/presentation/contact/view/contact_add/contact_add_screen.dart';
import 'package:cardly_app/presentation/contact/view/contact_detail/contact_detail_screen.dart';

import 'package:cardly_app/presentation/contact/view/contact_screen.dart';
import 'package:cardly_app/presentation/digital_card/digital_card_screen.dart';
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
  void goToResetPassword(String email, String otp) => push(
    ResetPasswordScreen.routerName,
    extra: <String, String>{"email": email, "otp": otp},
  );

  void goToOnboarding() => push(OnboardingScreen.routerName);

  void goToHome() => push(HomePage.routerName);

  void goToScan() => push(ScanScreen.routerName);
  void goToScanCamera(ScanCubit cubit) =>
      push('/scan/${CustomCameraScreen.routerName}', extra: cubit);
  void goToScanPreview(ScanCubit cubit) =>
      push('/scan/${PreviewScreen.routerName}', extra: cubit);
  void goToScanEdit(ScanCubit cubit) =>
      push('/scan/${EditScreen.routerName}', extra: cubit);
  void goToScanReview(ScanCubit cubit) =>
      push('/scan/${ReviewScreen.routerName}', extra: cubit);
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
  void goToContactDetail(BusinessCardEntity c) =>
      push(ContactDetailScreen.routerName, extra: c);

  void goToDigitalCard() => push(DigitalCardScreen.routerName);
}
