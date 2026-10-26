import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' show ClientException;
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/billing.dart';
import 'package:parousia/services/local_cache.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FunctionException;

import '../support/fake_backend.dart';
import '../support/preferences.dart';

void main() {
  late FakeBackend backend;
  late LocalCache cache;
  late BillingRepository repository;
  late Group club;

  BillingRepository newRepository() =>
      BillingRepository(billing: backend.billingService, cache: cache);

  setUp(() async {
    backend = FakeBackend();
    useInMemoryPreferences();
    cache = await openCache();
    repository = newRepository();
    repository.switchUser('me');
    club = backend.addGroup('Club');
  });

  test('knows nothing until the server answers: no pro features', () {
    expect(repository.state.mode, BillingMode.prelaunch);
    expect(repository.access(club.id).can(FeatureKey.kitchenView), isFalse);
  });

  test('refresh loads what each of the user\'s groups may do', () async {
    backend.fundGroup(club.id, maxSeats: 40);
    backend.addMember(club.id, profileId: 'ann');

    expect(await repository.refresh(), isA<Ok<void>>());

    final access = repository.access(club.id);
    expect(repository.state.mode, BillingMode.live);
    expect(access.can(FeatureKey.kitchenView), isTrue);
    expect(access.limit(LimitKey.maxSeats), 40);
    expect(access.group.seats, 2);
  });

  test('a failed refresh keeps the last state', () async {
    backend.fundGroup(club.id);
    await repository.refresh();

    backend.failure = ClientException('offline');
    expect(await repository.refresh(), isA<Error<void>>());
    expect(repository.access(club.id).can(FeatureKey.exportCsv), isTrue);
  });

  test('the state survives a restart, for the same user only', () async {
    backend.fundGroup(club.id);
    await repository.refresh();
    await pumpEventQueue();

    final restarted = BillingRepository(
      billing: backend.billingService,
      cache: await openCache(),
    )..switchUser('me');
    expect(restarted.access(club.id).can(FeatureKey.kitchenView), isTrue);

    restarted.switchUser('someone else');
    expect(restarted.state, const BillingState());
  });

  test('checkout asks the server for a Stripe page', () async {
    final result = await repository.checkout(
      groupId: club.id,
      plan: 'community_m',
      interval: 'year',
    );

    expect(
      (result as Ok<Uri>).value.toString(),
      'https://checkout.stripe.test/community_m-year',
    );
    expect(backend.checkouts.single, (
      groupId: club.id,
      plan: 'community_m',
      interval: 'year',
    ));
  });

  test(
    'a refused checkout refreshes the state, which was out of date',
    () async {
      // Another admin bought a plan meanwhile.
      backend.fundGroup(club.id);
      backend.stripeFailure = const FunctionException(
        status: 409,
        details: {'error': 'already_funded'},
      );

      final result = await repository.checkout(
        groupId: club.id,
        plan: 'community_s',
        interval: 'month',
      );

      expect((result as Error).error, isA<AlreadyFundedException>());
      expect(repository.access(club.id).can(FeatureKey.kitchenView), isTrue);
    },
  );

  test('portal comes back to the page it was opened from', () async {
    final result = await repository.portal('/groups/${club.id}/plan');

    expect(result, isA<Ok<Uri>>());
    expect(backend.portals, ['/groups/${club.id}/plan']);
  });
}
