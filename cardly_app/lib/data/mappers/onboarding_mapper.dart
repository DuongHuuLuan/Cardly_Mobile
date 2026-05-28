import 'dart:convert';

import 'package:cardly_app/domain/Entities/onboarding.dart';

class OnboardingMapper {
  static Onboarding fromJson(Map<String, dynamic> json) {
    return Onboarding(
      id: json["id"] as int,
      title: json["title"] as String,
      description: json["description"] as String,
      imageUrl: json["imageUrl"] as String,
    );
  }

  static Map<String, dynamic> toJson(Onboarding onboarding) {
    return {
      "id": onboarding.id,
      "title": onboarding.title,
      "description": onboarding.description,
      "imageUrl": onboarding.imageUrl,
    };
  }

  static Onboarding fromJsonString(String jsonString) {
    return fromJson(jsonDecode(jsonString));
  }

  static String toJsonString(Onboarding onboarding) {
    return jsonEncode(onboarding);
  }

  static List<Onboarding> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Onboarding> onboardings) {
    return onboardings.map((onboarding) => toJson(onboarding)).toList();
  }
}
