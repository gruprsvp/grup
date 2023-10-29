import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
sealed class Profile with _$Profile {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Profile({
    required String id,
    String? displayName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
