import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';
part 'config.g.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  late Config config;

  ConfigService._internal();

  factory ConfigService() {
    return _instance;
  }

  Future<void> initialize() async {
    const env = kReleaseMode ? 'supabase' : 'local';
    final envConfigFile = await rootBundle.loadString('assets/env/$env.json');
    final config = Config.fromJson(json.decode(envConfigFile));
    this.config = config;
  }
}

@freezed
sealed class Config with _$Config {
  const factory Config({
    required String supabaseConfigPath,
    required String socialAuthWebClientId,
    required String socialAuthIosClientId,
    required String revenuecatGoogleApiKey,
    required String revenuecatAppleApiKey,
  }) = _Config;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
