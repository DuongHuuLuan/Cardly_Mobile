import 'package:cardly_app/domain/entities/onboarding.dart';

abstract class OnboardingRepository {
  Future<List<Onboarding>> getData();
}
