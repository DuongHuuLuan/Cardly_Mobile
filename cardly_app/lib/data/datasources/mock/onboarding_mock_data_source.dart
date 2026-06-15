import 'dart:convert';

import 'package:cardly_app/data/mappers/onboarding/onboarding_mapper.dart';
import 'package:cardly_app/domain/entities/onboarding.dart';
import 'package:flutter/services.dart';

class OnboardingMockDataSource {
  final bool useEmbeddedData;

  OnboardingMockDataSource({this.useEmbeddedData = false});

  Future<List<Onboarding>> getOnboardingData() async {
    final String jsonString = await rootBundle.loadString(
      "assets/data/mock/onboarding.json",
    );
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return OnboardingMapper.fromJsonList(jsonList);
  }
}
