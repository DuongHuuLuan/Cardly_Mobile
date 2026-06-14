import 'package:cardly_app/data/datasources/mock/onboarding_mock_data_source.dart';
import 'package:cardly_app/domain/entities/onboarding.dart';
import 'package:cardly_app/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingMockDataSource _mockDataSource;

  OnboardingRepositoryImpl({required OnboardingMockDataSource mockDataSource})
    : _mockDataSource = mockDataSource;

  @override
  Future<List<Onboarding>> getData() async {
    final list = await _mockDataSource.getOnboardingData();
    return list;
  }
}
