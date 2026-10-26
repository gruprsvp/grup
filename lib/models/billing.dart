import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing.freezed.dart';

part 'billing.g.dart';

// Paid plans (docs/billing-and-entitlements.md). The server decides what each
// group may do; the app only reads it, as feature and limit keys.

/// Flipped in the Phase 2 release. Compile-time on purpose: Phase 1 iOS
/// builds must never show pro screens, whatever the server says
/// (App Store Guideline 3.1.3(b)).
const kIapSupported = false;

/// The features plans give. Code checks these, never plan names.
abstract final class FeatureKey {
  static const kitchenView = 'kitchen_view';
  static const replyCutoffs = 'reply_cutoffs';
  static const exportCsv = 'export_csv';
}

/// The limits plans set.
abstract final class LimitKey {
  static const maxSeats = 'max_seats';
}

/// `unlocked` on self-hosted installs (everything, no billing), `prelaunch`
/// on the hosted service before paid plans launch, then `live`.
enum BillingMode { unlocked, prelaunch, live }

/// What the server says about billing for the signed-in user.
@freezed
sealed class BillingState with _$BillingState {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BillingState({
    // A mode added after this version shipped shows no pro screens and no
    // billing UI. Until the server answers, neither shows either.
    @JsonKey(unknownEnumValue: BillingMode.prelaunch)
    @Default(BillingMode.prelaunch)
    BillingMode mode,

    /// The account was created before paid plans were announced.
    @Default(false) bool isFounder,

    /// The user has paid on the web, so they have billing to manage.
    @Default(false) bool isCustomer,

    /// The entitlements of each of the user's groups, by group id.
    @Default({}) Map<String, GroupEntitlements> groups,

    /// The plans on sale, cheapest first.
    @Default([]) List<CatalogPlan> catalog,
  }) = _BillingState;

  factory BillingState.fromJson(Map<String, dynamic> json) =>
      _$BillingStateFromJson(json);
}

/// What a group may do, and why.
@freezed
sealed class GroupEntitlements with _$GroupEntitlements {
  const factory GroupEntitlements({
    @Default([]) List<String> features,

    /// A limit that is null, or missing, is unlimited.
    @Default({}) Map<String, int?> limits,

    /// Members with an account, plus members with a pending invite.
    @Default(0) int seats,
    @Default([]) List<EntitlementSource> sources,
  }) = _GroupEntitlements;

  factory GroupEntitlements.fromJson(Map<String, dynamic> json) =>
      _$GroupEntitlementsFromJson(json);
}

/// A grant or a subscription that gives a group its entitlements. Plain
/// strings, so a value added on the server can't stop the rest decoding.
@freezed
sealed class EntitlementSource with _$EntitlementSource {
  const factory EntitlementSource({
    /// `grant` or `subscription`.
    required String kind,

    /// A grant's source: `legacy`, `founder_trial`, `early_access`, `manual`.
    String? source,

    /// A subscription's plan and its rank among plans.
    String? plan,
    int? rank,

    /// A subscription's provider (`stripe`, `app_store`, ...) and status.
    String? provider,
    String? status,

    /// The user id of who pays for the subscription.
    String? payer,

    /// When it ends (a subscription: renews); `null` for never.
    DateTime? until,

    /// Whether a subscription renews at [until].
    bool? renews,
  }) = _EntitlementSource;

  factory EntitlementSource.fromJson(Map<String, dynamic> json) =>
      _$EntitlementSourceFromJson(json);
}

/// A plan on sale.
@freezed
sealed class CatalogPlan with _$CatalogPlan {
  const factory CatalogPlan({
    required String plan,
    required int rank,
    @Default([]) List<String> features,
    @Default({}) Map<String, int?> limits,
    @Default([]) List<CatalogPrice> prices,
  }) = _CatalogPlan;

  factory CatalogPlan.fromJson(Map<String, dynamic> json) =>
      _$CatalogPlanFromJson(json);
}

/// A price of a plan on one provider.
@freezed
sealed class CatalogPrice with _$CatalogPrice {
  const factory CatalogPrice({
    required String provider,
    required String id,

    /// `month` or `year`.
    required String interval,

    /// For display only, in minor units by currency: `{"CHF": 900}`.
    @Default({}) Map<String, int> amounts,
  }) = _CatalogPrice;

  factory CatalogPrice.fromJson(Map<String, dynamic> json) =>
      _$CatalogPriceFromJson(json);
}

/// The platform for [GroupAccess]: `null` on the web.
TargetPlatform? get appPlatform =>
    (debugIsWeb ?? kIsWeb) ? null : defaultTargetPlatform;

/// Overrides [kIsWeb] for [appPlatform] in tests.
@visibleForTesting
bool? debugIsWeb;

/// The only place the UI asks "may this group show X here?".
class GroupAccess {
  const GroupAccess(
    this.state,
    this.group,
    this.platform, {
    this.iapSupported = kIapSupported,
  });

  /// What [groupId] may do on this platform, per [state]. A group the state
  /// doesn't know yet may do nothing extra.
  factory GroupAccess.of(BillingState state, String groupId) => GroupAccess(
    state,
    state.groups[groupId] ?? const GroupEntitlements(),
    appPlatform,
  );

  final BillingState state;
  final GroupEntitlements group;

  /// `null` on the web.
  final TargetPlatform? platform;
  final bool iapSupported;

  /// The group has the feature. Use for effects, such as a reply locked by a
  /// cutoff.
  bool can(String feature) => group.features.contains(feature);

  /// Null means unlimited.
  int? limit(String key) => group.limits[key];

  /// The feature's own screens and settings may show on this platform.
  bool show(String feature) =>
      can(feature) &&
      (state.mode != BillingMode.live ||
          platform != TargetPlatform.iOS ||
          iapSupported);

  /// Prices, plan pickers and upgrade prompts may show on this platform.
  bool get purchaseUi => state.mode == BillingMode.live && platform == null;

  /// Every seat is taken: invites wait until one frees up.
  bool get seatsFull {
    final max = limit(LimitKey.maxSeats);
    return max != null && group.seats >= max;
  }

  /// The subscription that funds the group, if any: the highest plan.
  EntitlementSource? get subscription => group.sources
      .where((source) => source.kind == 'subscription')
      .sortedBy<num>((source) => source.rank ?? 0)
      .lastOrNull;

  /// The founder benefit (Community until the trial ends), while it lasts.
  EntitlementSource? get founderTrial => group.sources.firstWhereOrNull(
    (source) => source.kind == 'grant' && source.source == 'founder_trial',
  );
}

/// The smallest plan whose seats cover [seats], or `null` when none does.
CatalogPlan? recommendedPlan(List<CatalogPlan> catalog, int seats) =>
    catalog.sortedBy<num>((plan) => plan.rank).firstWhereOrNull((plan) {
      final max = plan.limits[LimitKey.maxSeats];
      return max == null || max >= seats;
    });

/// Where the euro is the currency (the euro area, and those using it).
const _euroCountries = {
  'AT', 'BE', 'BG', 'CY', 'DE', 'EE', 'ES', 'FI', 'FR', 'GR', 'HR', 'IE', //
  'IT', 'LT', 'LU', 'LV', 'MT', 'NL', 'PT', 'SI', 'SK', 'AD', 'MC', 'ME', //
  'SM', 'VA', 'XK',
};

/// The currency to show prices in, guessed from the locale's country:
/// Switzerland pays in CHF, the euro area in EUR, anyone else in USD. The
/// price at checkout is final.
String priceCurrency(String? countryCode) => switch (countryCode) {
  'CH' || 'LI' => 'CHF',
  final code? when _euroCountries.contains(code) => 'EUR',
  _ => 'USD',
};
