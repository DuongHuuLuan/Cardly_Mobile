import 'package:cardly_app/domain/Entities/onboarding.dart';

abstract class OnboardingRepository {
  Future<List<Onboarding>> getData();
}
