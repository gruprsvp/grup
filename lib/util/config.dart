import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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
    const env = String.fromEnvironment('ENV', defaultValue: 'local');
    final envConfigFile = await rootBundle.loadString('env/$env.json');
    final config =
        Config.fromJson(json.decode(envConfigFile) as Map<String, dynamic>);
    this.config = config;
  }
}

@freezed
sealed class Config with _$Config {
  const factory Config({
    required String supabaseConfigPath,
    required String socialAuthWebClientId,
    required String socialAuthIosClientId,
  }) = _Config;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
