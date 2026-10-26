// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillingState _$BillingStateFromJson(Map<String, dynamic> json) =>
    _BillingState(
      mode:
          $enumDecodeNullable(
            _$BillingModeEnumMap,
            json['mode'],
            unknownValue: BillingMode.prelaunch,
          ) ??
          BillingMode.prelaunch,
      isFounder: json['is_founder'] as bool? ?? false,
      isCustomer: json['is_customer'] as bool? ?? false,
      groups:
          (json['groups'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              GroupEntitlements.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const {},
      catalog:
          (json['catalog'] as List<dynamic>?)
              ?.map((e) => CatalogPlan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BillingStateToJson(_BillingState instance) =>
    <String, dynamic>{
      'mode': _$BillingModeEnumMap[instance.mode]!,
      'is_founder': instance.isFounder,
      'is_customer': instance.isCustomer,
      'groups': instance.groups,
      'catalog': instance.catalog,
    };

const _$BillingModeEnumMap = {
  BillingMode.unlocked: 'unlocked',
  BillingMode.prelaunch: 'prelaunch',
  BillingMode.live: 'live',
};

_GroupEntitlements _$GroupEntitlementsFromJson(
  Map<String, dynamic> json,
) => _GroupEntitlements(
  features:
      (json['features'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  limits:
      (json['limits'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num?)?.toInt()),
      ) ??
      const {},
  seats: (json['seats'] as num?)?.toInt() ?? 0,
  sources:
      (json['sources'] as List<dynamic>?)
          ?.map((e) => EntitlementSource.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$GroupEntitlementsToJson(_GroupEntitlements instance) =>
    <String, dynamic>{
      'features': instance.features,
      'limits': instance.limits,
      'seats': instance.seats,
      'sources': instance.sources,
    };

_EntitlementSource _$EntitlementSourceFromJson(Map<String, dynamic> json) =>
    _EntitlementSource(
      kind: json['kind'] as String,
      source: json['source'] as String?,
      plan: json['plan'] as String?,
      rank: (json['rank'] as num?)?.toInt(),
      provider: json['provider'] as String?,
      status: json['status'] as String?,
      payer: json['payer'] as String?,
      until: json['until'] == null
          ? null
          : DateTime.parse(json['until'] as String),
      renews: json['renews'] as bool?,
    );

Map<String, dynamic> _$EntitlementSourceToJson(_EntitlementSource instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'source': instance.source,
      'plan': instance.plan,
      'rank': instance.rank,
      'provider': instance.provider,
      'status': instance.status,
      'payer': instance.payer,
      'until': instance.until?.toIso8601String(),
      'renews': instance.renews,
    };

_CatalogPlan _$CatalogPlanFromJson(Map<String, dynamic> json) => _CatalogPlan(
  plan: json['plan'] as String,
  rank: (json['rank'] as num).toInt(),
  features:
      (json['features'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  limits:
      (json['limits'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num?)?.toInt()),
      ) ??
      const {},
  prices:
      (json['prices'] as List<dynamic>?)
          ?.map((e) => CatalogPrice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CatalogPlanToJson(_CatalogPlan instance) =>
    <String, dynamic>{
      'plan': instance.plan,
      'rank': instance.rank,
      'features': instance.features,
      'limits': instance.limits,
      'prices': instance.prices,
    };

_CatalogPrice _$CatalogPriceFromJson(Map<String, dynamic> json) =>
    _CatalogPrice(
      provider: json['provider'] as String,
      id: json['id'] as String,
      interval: json['interval'] as String,
      amounts:
          (json['amounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$CatalogPriceToJson(_CatalogPrice instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'id': instance.id,
      'interval': instance.interval,
      'amounts': instance.amounts,
    };
