import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/local_cache_params.dart';
import 'local_cache.dart';

class LocalCacheImpl extends LocalCache {
  LocalCacheImpl(this._storage);
  final SharedPreferences _storage;

  @override
  Future<void> clearCache() async {
    await _storage.clear();
  }

  @override
  Future<void> deleteToken() async {
    await _storage.remove(LocalCacheParam.token);
  }

  @override
  Object? getFromLocalCache(String key) {
    return _storage.get(key);
  }

  @override
  String? getToken() {
    return _storage.getString(LocalCacheParam.token);
  }

  @override
  Map<String, dynamic>? getUserData() {
    final String? response = _storage.getString(LocalCacheParam.user);

    return response == null
        ? null
        : jsonDecode(response) as Map<String, dynamic>;
  }

  @override
  Future<void> removeFromLocalCache(String key) async {
    await _storage.remove(key);
  }

  @override
  Future<void> saveToLocalCache(
      {required String key, required dynamic value}) async {
    switch (value.runtimeType) {
      case String:
        await _storage.setString(key, value as String);
        break;
      case bool:
        await _storage.setBool(key, value as bool);
        break;
      case int:
        await _storage.setInt(key, value as int);
        break;
      case double:
        await _storage.setDouble(key, value as double);
        break;
      case List<String>:
        await _storage.setStringList(key, value as List<String>);
        break;
      // default:
    }
  }

  @override
  Future<void> saveToken(String tokenId) {
    return saveToLocalCache(key: LocalCacheParam.token, value: tokenId);
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> json) {
    return saveToLocalCache(key: LocalCacheParam.user, value: jsonEncode(json));
  }
}
