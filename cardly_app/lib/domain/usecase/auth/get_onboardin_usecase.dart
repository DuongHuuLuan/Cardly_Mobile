import 'package:cardly_app/domain/entities/onboarding.dart';
import 'package:cardly_app/domain/repositories/onboarding_repository.dart';

class GetOnboardingData {
  final OnboardingRepository repository;
  GetOnboardingData(this.repository);

  Future<List<Onboarding>> call() async {
    return await repository.getData();
  }
}
