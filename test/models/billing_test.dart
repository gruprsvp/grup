import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/models/models.dart';

void main() {
  // billing_state() as the server answers it (live mode, a funded group).
  final json = {
    'mode': 'live',
    'is_founder': true,
    'is_customer': false,
    'groups': {
      'g1': {
        'features': ['export_csv', 'kitchen_view', 'reply_cutoffs'],
        'limits': {'max_seats': 40},
        'seats': 12,
        'sources': [
          {
            'kind': 'grant',
            'source': 'founder_trial',
            'until': '2027-04-25T12:00:00+00:00',
          },
          {
            'kind': 'subscription',
            'plan': 'community_m',
            'rank': 20,
            'provider': 'stripe',
            'status': 'active',
            'payer': 'u1',
            'until': '2026-11-25T12:00:00+00:00',
            'renews': true,
          },
        ],
      },
      'g2': {
        'features': <String>[],
        'limits': {'max_seats': null},
        'seats': 3,
        'sources': [
          {'kind': 'grant', 'source': 'legacy', 'until': null},
        ],
      },
    },
    'catalog': [
      {
        'plan': 'community_s',
        'rank': 10,
        'features': ['kitchen_view', 'reply_cutoffs', 'export_csv'],
        'limits': {'max_seats': 20},
        'prices': [
          {
            'id': 'community_s_month',
            'amounts': {'CHF': 900, 'EUR': 900, 'USD': 900},
            'interval': 'month',
            'provider': 'stripe',
          },
          {
            'id': 'no_amounts',
            'amounts': null,
            'interval': 'year',
            'provider': 'stripe',
          },
        ],
      },
    ],
  };

  group('BillingState', () {
    test('decodes billing_state()', () {
      final state = BillingState.fromJson(json);

      expect(state.mode, BillingMode.live);
      expect(state.isFounder, isTrue);
      expect(state.groups['g1']?.limits, {'max_seats': 40});
      expect(state.groups['g1']?.seats, 12);
      expect(
        state.groups['g1']?.sources.last.until,
        DateTime.utc(2026, 11, 25, 12),
      );
      expect(state.groups['g2']?.limits, {'max_seats': null});
      expect(state.catalog.single.prices.first.amounts['CHF'], 900);
      expect(state.catalog.single.prices.last.amounts, isEmpty);
    });

    test('a mode it doesn\'t know shows nothing extra', () {
      final state = BillingState.fromJson({...json, 'mode': 'sabbatical'});
      expect(state.mode, BillingMode.prelaunch);
      expect(const BillingState().mode, BillingMode.prelaunch);
    });

    test('survives the device cache', () {
      final state = BillingState.fromJson(json);
      // As LocalCache stores it: JSON text and back.
      final cached = BillingState.fromJson(jsonDecodeEncode(state.toJson()));
      expect(cached, state);
    });
  });

  group('GroupAccess', () {
    const funded = GroupEntitlements(
      features: [FeatureKey.kitchenView],
      limits: {LimitKey.maxSeats: 20},
      seats: 20,
    );
    GroupAccess access(
      BillingMode mode,
      TargetPlatform? platform, {
      bool iap = false,
    }) => GroupAccess(
      BillingState(mode: mode),
      funded,
      platform,
      iapSupported: iap,
    );

    test('can: whatever the server gave, on every platform', () {
      for (final mode in BillingMode.values) {
        for (final platform in [
          null,
          TargetPlatform.android,
          TargetPlatform.iOS,
        ]) {
          expect(access(mode, platform).can(FeatureKey.kitchenView), isTrue);
          expect(access(mode, platform).can(FeatureKey.exportCsv), isFalse);
        }
      }
    });

    test('show: never on iOS while live, until in-app purchases ship', () {
      expect(
        access(BillingMode.live, null).show(FeatureKey.kitchenView),
        isTrue,
      );
      expect(
        access(
          BillingMode.live,
          TargetPlatform.android,
        ).show(FeatureKey.kitchenView),
        isTrue,
      );
      expect(
        access(
          BillingMode.live,
          TargetPlatform.iOS,
        ).show(FeatureKey.kitchenView),
        isFalse,
      );
      expect(
        access(
          BillingMode.live,
          TargetPlatform.iOS,
          iap: true,
        ).show(FeatureKey.kitchenView),
        isTrue,
      );
      // Self-hosted (unlocked): everything everywhere.
      expect(
        access(
          BillingMode.unlocked,
          TargetPlatform.iOS,
        ).show(FeatureKey.kitchenView),
        isTrue,
      );
      // Nothing the group doesn't have.
      expect(
        access(BillingMode.live, null).show(FeatureKey.exportCsv),
        isFalse,
      );
    });

    test('purchaseUi: on the web while live, nowhere else', () {
      for (final mode in BillingMode.values) {
        for (final platform in [
          null,
          TargetPlatform.android,
          TargetPlatform.iOS,
        ]) {
          for (final iap in [false, true]) {
            expect(
              access(mode, platform, iap: iap).purchaseUi,
              mode == BillingMode.live && platform == null,
              reason: '$mode on ${platform ?? 'the web'}, iap $iap',
            );
          }
        }
      }
    });

    test('Phase 1 iOS builds show no pro screens and no prices', () {
      expect(kIapSupported, isFalse);
      final ios = GroupAccess(
        const BillingState(mode: BillingMode.live),
        funded,
        TargetPlatform.iOS,
      );
      expect(ios.show(FeatureKey.kitchenView), isFalse);
      expect(ios.purchaseUi, isFalse);
    });

    test('limits, seats and where entitlements come from', () {
      final state = BillingState.fromJson(json);
      final g1 = GroupAccess(state, state.groups['g1']!, null);
      final g2 = GroupAccess(state, state.groups['g2']!, null);

      expect(g1.limit(LimitKey.maxSeats), 40);
      expect(g1.seatsFull, isFalse);
      expect(access(BillingMode.live, null).seatsFull, isTrue);
      expect(g2.limit(LimitKey.maxSeats), isNull);
      expect(g2.seatsFull, isFalse);

      expect(g1.subscription?.plan, 'community_m');
      expect(g1.founderTrial?.until, DateTime.utc(2027, 4, 25, 12));
      expect(g2.subscription, isNull);
    });

    test('a group the state doesn\'t know may do nothing extra', () {
      debugIsWeb = true;
      addTearDown(() => debugIsWeb = null);
      final access = GroupAccess.of(BillingState.fromJson(json), 'unknown');
      expect(access.group.features, isEmpty);
      expect(access.platform, isNull);
    });
  });

  test('recommendedPlan: the smallest plan whose seats cover the group', () {
    const catalog = [
      CatalogPlan(plan: 'community_l', rank: 30, limits: {'max_seats': 80}),
      CatalogPlan(plan: 'community_s', rank: 10, limits: {'max_seats': 20}),
      CatalogPlan(plan: 'community_m', rank: 20, limits: {'max_seats': 40}),
    ];
    expect(recommendedPlan(catalog, 8)?.plan, 'community_s');
    expect(recommendedPlan(catalog, 20)?.plan, 'community_s');
    expect(recommendedPlan(catalog, 21)?.plan, 'community_m');
    expect(recommendedPlan(catalog, 80)?.plan, 'community_l');
    expect(recommendedPlan(catalog, 81), isNull);
  });

  test('priceCurrency guesses from the country', () {
    expect(priceCurrency('CH'), 'CHF');
    expect(priceCurrency('LI'), 'CHF');
    expect(priceCurrency('DE'), 'EUR');
    expect(priceCurrency('IT'), 'EUR');
    expect(priceCurrency('BG'), 'EUR');
    expect(priceCurrency('US'), 'USD');
    expect(priceCurrency('GB'), 'USD');
    expect(priceCurrency(null), 'USD');
  });
}

/// JSON text and back, as the device cache does.
Map<String, dynamic> jsonDecodeEncode(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;
