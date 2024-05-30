import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
sealed class Group with _$Group {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Group({
    required int id,
    required String displayName,
    String? description,
    String? picture,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
