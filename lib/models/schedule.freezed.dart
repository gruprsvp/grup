// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Schedule implements DiagnosticableTreeMixin {

 String get id; String get groupId; String get displayName; DateTime get startDate; RecurrenceRule get recurrenceRule; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCopyWith<Schedule> get copyWith => _$ScheduleCopyWithImpl<Schedule>(this as Schedule, _$identity);

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Schedule'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('groupId', groupId))..add(DiagnosticsProperty('displayName', displayName))..add(DiagnosticsProperty('startDate', startDate))..add(DiagnosticsProperty('recurrenceRule', recurrenceRule))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('updatedAt', updatedAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Schedule&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,displayName,startDate,recurrenceRule,createdAt,updatedAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Schedule(id: $id, groupId: $groupId, displayName: $displayName, startDate: $startDate, recurrenceRule: $recurrenceRule, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ScheduleCopyWith<$Res>  {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) _then) = _$ScheduleCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String displayName, DateTime startDate, RecurrenceRule recurrenceRule, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ScheduleCopyWithImpl<$Res>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._self, this._then);

  final Schedule _self;
  final $Res Function(Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? displayName = null,Object? startDate = null,Object? recurrenceRule = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,recurrenceRule: null == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as RecurrenceRule,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Schedule].
extension SchedulePatterns on Schedule {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Schedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Schedule value)  $default,){
final _that = this;
switch (_that) {
case _Schedule():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Schedule value)?  $default,){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String displayName,  DateTime startDate,  RecurrenceRule recurrenceRule,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.id,_that.groupId,_that.displayName,_that.startDate,_that.recurrenceRule,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String displayName,  DateTime startDate,  RecurrenceRule recurrenceRule,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Schedule():
return $default(_that.id,_that.groupId,_that.displayName,_that.startDate,_that.recurrenceRule,_that.createdAt,_that.updatedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String displayName,  DateTime startDate,  RecurrenceRule recurrenceRule,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.id,_that.groupId,_that.displayName,_that.startDate,_that.recurrenceRule,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Schedule with DiagnosticableTreeMixin implements Schedule {
  const _Schedule({required this.id, required this.groupId, required this.displayName, required this.startDate, required this.recurrenceRule, this.createdAt, this.updatedAt});
  factory _Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);

@override final  String id;
@override final  String groupId;
@override final  String displayName;
@override final  DateTime startDate;
@override final  RecurrenceRule recurrenceRule;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCopyWith<_Schedule> get copyWith => __$ScheduleCopyWithImpl<_Schedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Schedule'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('groupId', groupId))..add(DiagnosticsProperty('displayName', displayName))..add(DiagnosticsProperty('startDate', startDate))..add(DiagnosticsProperty('recurrenceRule', recurrenceRule))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('updatedAt', updatedAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Schedule&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,displayName,startDate,recurrenceRule,createdAt,updatedAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Schedule(id: $id, groupId: $groupId, displayName: $displayName, startDate: $startDate, recurrenceRule: $recurrenceRule, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCopyWith<$Res> implements $ScheduleCopyWith<$Res> {
  factory _$ScheduleCopyWith(_Schedule value, $Res Function(_Schedule) _then) = __$ScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String displayName, DateTime startDate, RecurrenceRule recurrenceRule, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ScheduleCopyWithImpl<$Res>
    implements _$ScheduleCopyWith<$Res> {
  __$ScheduleCopyWithImpl(this._self, this._then);

  final _Schedule _self;
  final $Res Function(_Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? displayName = null,Object? startDate = null,Object? recurrenceRule = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Schedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,recurrenceRule: null == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as RecurrenceRule,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
