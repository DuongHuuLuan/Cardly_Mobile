import 'dart:convert';
import 'package:cardly_app/data/mappers/deep_link/deep_link_mapper.dart';
import 'package:cardly_app/data/models/deep_link/deep_link_model.dart';
import 'package:cardly_app/domain/entities/deep_link/deep_link_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DeepLinkLocalDataSource {
  Future<void> savePendingDeepLink(DeepLinkEntity link);
  Future<DeepLinkEntity?> getPendingDeepLink();
  Future<void> clearPendingDeepLink();
  void savePendingDeepLinkSync(DeepLinkEntity link);
  DeepLinkEntity? getPendingDeepLinkSync();
}

class DeepLinkLocalDataSourceImpl implements DeepLinkLocalDataSource {
  final SharedPreferences prefs;
  static const _key = 'pending_deep_link';

  DeepLinkLocalDataSourceImpl(this.prefs);

  @override
  Future<void> savePendingDeepLink(DeepLinkEntity link) async {
    final model = DeepLinkMapper.toModel(link);
    await prefs.setString(_key, jsonEncode(model.toJson()));
  }

  @override
  Future<DeepLinkEntity?> getPendingDeepLink() async {
    final json = prefs.getString(_key);
    if (json == null) return null;
    final model = DeepLinkModel.fromJson(jsonDecode(json));
    return DeepLinkMapper.toEntity(model);
  }

  @override
  Future<void> clearPendingDeepLink() async {
    await prefs.remove(_key);
  }

  @override
  void savePendingDeepLinkSync(DeepLinkEntity link) {
    final model = DeepLinkMapper.toModel(link);
    prefs.setString(_key, jsonEncode(model.toJson()));
  }

  @override
  DeepLinkEntity? getPendingDeepLinkSync() {
    final json = prefs.getString(_key);
    if (json == null) return null;
    final model = DeepLinkModel.fromJson(jsonDecode(json));
    return DeepLinkMapper.toEntity(model);
  }
}
