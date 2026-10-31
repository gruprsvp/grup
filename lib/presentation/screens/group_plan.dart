import 'dart:math';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

/// A group's plan: what it is and why, its spots, what plans include, and
/// (where plans are sold) choosing one in a short sheet or managing the one
/// the user pays for.
class GroupPlanScreen extends StatefulWidget {
  const GroupPlanScreen({
    super.key,
    required this.access,
    required this.loading,
    this.group,
    this.error,
    this.onRetry,
    this.onRefresh,
    this.isFounder = false,
    this.isPayer = false,
    this.catalog = const [],
    this.nameOf,
    this.activating = false,
    this.activationSlow = false,
    this.celebrate = false,
    this.opening = false,
    this.onSubscribe,
    this.onManageBilling,
    this.onContact,
  });

  final Group? group;
  final GroupAccess access;
  final bool loading;
  final Exception? error;
  final VoidCallback? onRetry;
  final Future<void> Function()? onRefresh;

  /// The user signed up before paid plans were announced: 30% off.
  final bool isFounder;

  /// The user pays for the group's plan.
  final bool isPayer;

  /// The plans on sale.
  final List<CatalogPlan> catalog;

  /// The name of a user (a payer), if known.
  final String? Function(String? userId)? nameOf;

  /// Back from paying, the plan is on its way; it's taking a while.
  final bool activating;
  final bool activationSlow;

  /// Back from paying, the plan just switched on: it gets a welcome.
  final bool celebrate;

  /// A checkout is opening; Stripe's page comes next.
  final bool opening;

  /// Buys a plan by the month or year.
  final void Function(String plan, String interval)? onSubscribe;
  final VoidCallback? onManageBilling;

  /// For groups bigger than any plan, which are invoiced by hand.
  final VoidCallback? onContact;

  @override
  State<GroupPlanScreen> createState() => _GroupPlanScreenState();
}

/// Each paid feature's icon, as where it lives in the app.
const _featureIcons = {
  FeatureKey.kitchenView: Icons.soup_kitchen_outlined,
  FeatureKey.replyCutoffs: Icons.lock_clock_outlined,
  FeatureKey.exportCsv: Icons.file_download_outlined,
};

class _GroupPlanScreenState extends State<GroupPlanScreen>
    with SingleTickerProviderStateMixin {
  /// The welcome of a plan that just switched on: its mark, then its spots,
  /// pop in. At rest otherwise.
  late final _welcome = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    value: 1,
  );

  /// The first of the spots the new plan adds: they pop in, the group's
  /// people stay put.
  int _newSpots = 0;

  @override
  void didUpdateWidget(GroupPlanScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.celebrate &&
        !oldWidget.celebrate &&
        !MediaQuery.disableAnimationsOf(context)) {
      _newSpots = max(
        oldWidget.access.limit(LimitKey.maxSeats) ?? 0,
        widget.access.group.seats,
      );
      _welcome.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _welcome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final muted = textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final access = widget.access;
    final error = widget.error;
    final subscription = access.subscription;
    final name = subscription == null
        ? l10n.planFree
        : l10n.planName(subscription.plan ?? '');
    final limit = access.limit(LimitKey.maxSeats);
    final seats = access.group.seats;
    final plans = widget.catalog.sortedBy<num>((plan) => plan.rank);
    final canBuy =
        access.purchaseUi && subscription == null && !widget.activating;
    final currency = _currency(context);
    final from = switch (plans.firstOrNull) {
      final plan? => _amount(plan, 'month', currency),
      null => null,
    };

    // What every plan adds, or what the group's plan includes. A group with
    // no limit already has all the room there is.
    final roomFor = subscription == null
        ? plans.map((plan) => plan.limits[LimitKey.maxSeats]).nonNulls.maxOrNull
        : limit;
    final perks = [
      if (limit != null && roomFor != null)
        (
          Icons.group_add_outlined,
          l10n.planRoomTitle,
          l10n.planUpToSeats(roomFor),
        ),
      for (final feature
          in subscription == null
              ? plans.firstOrNull?.features ?? const <String>[]
              : access.group.features)
        (
          _featureIcons[feature] ?? Icons.check_circle_outline,
          l10n.featureName(feature),
          l10n.featurePitch(feature),
        ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(widget.group?.displayName ?? l10n.planTitle)),
      body: RefreshIndicator.adaptive(
        onRefresh: widget.onRefresh ?? () async {},
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            if (widget.loading) const LinearProgressIndicator(),
            if (error != null)
              ErrorNotice(error: error, onRetry: widget.onRetry),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  ScaleTransition(
                    alignment: Alignment.centerLeft,
                    scale: _welcome.drive(
                      CurveTween(
                        curve: const Interval(
                          0,
                          0.5,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                    ),
                    child: PlanMark(name, style: textTheme.displaySmall),
                  ),
                  if (widget.celebrate)
                    FadeTransition(
                      opacity: _welcome.drive(
                        CurveTween(curve: const Interval(0.5, 1)),
                      ),
                      child: Text(
                        l10n.planWelcome(name),
                        style: textTheme.titleMedium,
                      ),
                    ),
                  ..._status(context),
                  // Back from paying, the wait shows where the plan will.
                  if (widget.activating)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        spacing: 16,
                        children: [
                          widget.activationSlow
                              ? const Icon(Icons.hourglass_bottom)
                              : const SizedBox.square(
                                  dimension: 24,
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                          Expanded(
                            child: Text(
                              widget.activationSlow
                                  ? l10n.planActivationSlow
                                  : l10n.planActivating,
                              style: textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: limit == null
                  // No limit, no dots: a founding group can be any size.
                  ? Text(
                      l10n.planSpotsTaken(seats),
                      style: textTheme.titleMedium,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Text(
                          l10n.planSeats(seats, limit),
                          style: textTheme.titleMedium,
                        ),
                        SpotsMeter(
                          taken: seats,
                          limit: limit,
                          from: _newSpots,
                          animation: _welcome.drive(
                            CurveTween(curve: const Interval(0.25, 1)),
                          ),
                        ),
                        switch ((access.seatsFull, subscription)) {
                          // A plan changes size where it's paid for.
                          (true, _?) => Text(
                            l10n.planSeatsFullPaid,
                            style: textTheme.bodyLarge,
                          ),
                          (true, null) => Text(
                            l10n.planSeatsFull,
                            style: textTheme.bodyLarge,
                          ),
                          _ => Text(l10n.planPendingInvites, style: muted),
                        },
                      ],
                    ),
            ),
            if (perks.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 4),
                child: Text(
                  subscription == null
                      ? l10n.planPerksEvery
                      : l10n.planPerksYours,
                  style: textTheme.titleMedium,
                ),
              ),
              for (final (icon, title, pitch) in perks)
                ListTile(
                  leading: Icon(icon, color: theme.colorScheme.primary),
                  title: Text(title),
                  subtitle: Text(pitch),
                ),
            ],
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  if (canBuy) ...[
                    FilledButton.icon(
                      onPressed:
                          plans.isEmpty ||
                              widget.opening ||
                              widget.onSubscribe == null
                          ? null
                          : _choosePlan,
                      icon: widget.opening
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : null,
                      label: Text(l10n.planChoose),
                    ),
                    if (from != null)
                      Text(
                        l10n.planFrom(_money(context, from, currency)),
                        style: muted,
                        textAlign: TextAlign.center,
                      ),
                  ],
                  if (widget.isPayer && widget.onManageBilling != null) ...[
                    FilledButton.tonalIcon(
                      onPressed: widget.onManageBilling,
                      icon: const Icon(Icons.receipt_long),
                      label: Text(l10n.planManageBilling),
                    ),
                    Text(
                      l10n.planManageHint,
                      style: muted,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Where the group's plan and extras come from, one line each.
  List<Widget> _status(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final date = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    String payer(EntitlementSource source) => widget.isPayer
        ? l10n.planYou
        : (widget.nameOf?.call(source.payer) ?? l10n.planSomeone);
    Widget line(String text, {bool problem = false}) => Text(
      text,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: problem
            ? theme.colorScheme.error
            : theme.colorScheme.onSurfaceVariant,
      ),
    );
    final legacy = widget.access.group.sources.any(
      (source) => source.source == 'legacy',
    );
    return [
      for (final source in widget.access.group.sources)
        ...switch (source) {
          EntitlementSource(kind: 'subscription') => [
            if (source.status == 'grace')
              line(
                widget.isPayer
                    ? l10n.planPaymentIssueYou
                    : l10n.planPaymentIssue(payer(source)),
                problem: true,
              ),
            line(switch ((source.until, source.renews)) {
              (final until?, true) => l10n.planFundedRenews(
                payer(source),
                date.format(until.toLocal()),
              ),
              (final until?, _) => l10n.planFundedEnds(
                payer(source),
                date.format(until.toLocal()),
              ),
              (null, _) => l10n.planFundedBy(payer(source)),
            }),
          ],
          EntitlementSource(source: 'legacy') => [line(l10n.planLegacy)],
          EntitlementSource(source: 'founder_trial', :final until?) => [
            line(l10n.planFounderTrial(date.format(until.toLocal()))),
          ],
          EntitlementSource(source: 'early_access', :final until?) => [
            line(l10n.planEarlyAccess(date.format(until.toLocal()))),
          ],
          EntitlementSource(:final until?) => [
            line(l10n.planExtraUntil(date.format(until.toLocal()))),
          ],
          _ => [line(l10n.planExtra)],
        },
      // A limit lifted by something other than a founding group's grant.
      if (widget.access.limit(LimitKey.maxSeats) == null && !legacy)
        line(l10n.planNoSeatLimit),
    ];
  }

  /// Opens the sheet that picks a plan, then goes to pay for it.
  Future<void> _choosePlan() async {
    final access = widget.access;
    final choice = await showModalBottomSheet<(String, String)>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _UpgradeSheet(
        plans: widget.catalog.sortedBy<num>((plan) => plan.rank),
        seats: access.group.seats,
        unlimited: access.limit(LimitKey.maxSeats) == null,
        isFounder: widget.isFounder,
        trialEnds: access.founderTrial?.until,
        onContact: widget.onContact,
      ),
    );
    if (!mounted) return;
    if (choice case (final plan, final interval)) {
      widget.onSubscribe?.call(plan, interval);
    }
  }
}

/// Buying a plan, one question at a time: its size, then monthly or yearly.
/// Pops with the plan and the interval to pay for.
class _UpgradeSheet extends StatefulWidget {
  const _UpgradeSheet({
    required this.plans,
    required this.seats,
    required this.unlimited,
    required this.isFounder,
    this.trialEnds,
    this.onContact,
  });

  /// The plans on sale, smallest first.
  final List<CatalogPlan> plans;

  /// The spots the group uses.
  final int seats;

  /// The group has no spot limit (a founding group), so the size only sets
  /// the price: the smallest is all it needs.
  final bool unlimited;

  final bool isFounder;

  /// When a founding group's free plan ends; paying starts then.
  final DateTime? trialEnds;

  final VoidCallback? onContact;

  @override
  State<_UpgradeSheet> createState() => _UpgradeSheetState();
}

class _UpgradeSheetState extends State<_UpgradeSheet> {
  /// The size picked; null while picking one.
  late CatalogPlan? _plan = widget.unlimited ? widget.plans.firstOrNull : null;
  String _interval = 'month';

  @override
  Widget build(BuildContext context) {
    final plan = _plan;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 200);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: AnimatedSize(
        duration: duration,
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: duration,
          child: plan == null ? _sizes(context) : _payment(context, plan),
        ),
      ),
    );
  }

  Widget _sizes(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currency = _currency(context);
    final needed = widget.unlimited ? 0 : widget.seats;
    final recommended = recommendedPlan(widget.plans, needed);
    final onContact = widget.onContact;
    return Column(
      key: const ValueKey('sizes'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.planSizeTitle, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          l10n.planSizeHint(widget.seats),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        for (final plan in widget.plans)
          _SizeOption(
            name: l10n.planName(plan.plan),
            limit: plan.limits[LimitKey.maxSeats],
            price: switch (_amount(plan, 'month', currency)) {
              final cents? => l10n.planPerMonth(
                _money(context, cents, currency),
              ),
              null => null,
            },
            recommended: plan == recommended,
            onTap: (plan.limits[LimitKey.maxSeats] ?? needed) < needed
                ? null
                : () => setState(() => _plan = plan),
          ),
        if (recommended == null && onContact != null)
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onContact();
            },
            icon: const Icon(Icons.mail_outline),
            label: Text(l10n.planContactUs),
          ),
      ],
    );
  }

  Widget _payment(BuildContext context, CatalogPlan plan) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final muted = textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final locale = Localizations.localeOf(context).toString();
    final currency = _currency(context);
    final month = _amount(plan, 'month', currency);
    final year = _amount(plan, 'year', currency);
    final cents = _interval == 'year' ? year : month;
    final limit = plan.limits[LimitKey.maxSeats];
    final trialEnds = widget.trialEnds;

    return Column(
      key: ValueKey(plan.plan),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (!widget.unlimited)
              BackButton(onPressed: () => setState(() => _plan = null)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlanMark(
                    l10n.planName(plan.plan),
                    style: textTheme.headlineMedium,
                  ),
                  Text(
                    widget.unlimited || limit == null
                        ? l10n.planNoSeatLimit
                        : l10n.planUpToSeats(limit),
                    style: muted,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'month', label: Text(l10n.planMonthly)),
            ButtonSegment(value: 'year', label: Text(l10n.planYearly)),
          ],
          selected: {_interval},
          onSelectionChanged: (selected) =>
              setState(() => _interval = selected.single),
        ),
        const SizedBox(height: 20),
        if (cents != null)
          Text(
            _interval == 'year'
                ? l10n.planPerYear(_money(context, cents, currency))
                : l10n.planPerMonth(_money(context, cents, currency)),
            style: textTheme.headlineSmall,
          ),
        // A year costs ten months (billing doc, F3): say so while it's true.
        if ((month, year) case (final month?, final year?)
            when year == month * 10)
          Text(
            _interval == 'year'
                ? l10n.planYearlySaving
                : l10n.planYearlyNudge(_money(context, year, currency)),
            style: textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        for (final note in [
          if (widget.isFounder) l10n.planFounderDiscount,
          // A checkout bills from the trial's end when it's at least 48
          // hours away (Stripe's minimum).
          if (trialEnds != null &&
              trialEnds.isAfter(DateTime.now().add(const Duration(hours: 48))))
            l10n.planBillingStarts(
              DateFormat.yMMMd(locale).format(trialEnds.toLocal()),
            ),
        ])
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(note, style: muted),
          ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.pop(context, (plan.plan, _interval)),
          child: Text(l10n.planSubscribe),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.planFinePrint,
          style: textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// One size to pick: its mark, how many people it fits and its monthly
/// price. A size too small for the group lies flat: lift means tappable.
class _SizeOption extends StatelessWidget {
  const _SizeOption({
    required this.name,
    required this.limit,
    required this.price,
    required this.recommended,
    this.onTap,
  });

  final String name;
  final int? limit;
  final String? price;
  final bool recommended;

  /// Null when the size is too small for the group.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final limit = this.limit;
    final price = this.price;
    final onTap = this.onTap;
    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlanMark(name),
                if (limit != null) Text(l10n.planUpToSeats(limit)),
                if (recommended)
                  Text(
                    l10n.planRecommended,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                if (onTap == null)
                  Text(
                    l10n.planTooSmall,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (price != null) Text(price, style: theme.textTheme.titleMedium),
          if (onTap != null) const Icon(Icons.chevron_right),
        ],
      ),
    );
    const margin = EdgeInsets.only(bottom: 8);
    // Raised sizes stand out from the sheet: white with a shadow by day, a
    // tone above it at night, where shadows don't show. A size too small is
    // an outlined, flat slot.
    return onTap == null
        ? Card.outlined(
            margin: margin,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: content,
          )
        : Card(
            margin: margin,
            color: recommended
                ? theme.colorScheme.primaryContainer
                : theme.brightness == Brightness.dark
                ? theme.colorScheme.surfaceContainerHigh
                : theme.colorScheme.surfaceContainerLowest,
            child: Semantics(
              button: true,
              child: InkWell(onTap: onTap, child: content),
            ),
          );
  }
}

/// The currency the user probably pays in: the device's country says where
/// they pay, not the app's language. The price at checkout is final.
String _currency(BuildContext context) =>
    priceCurrency(View.of(context).platformDispatcher.locale.countryCode);

/// [plan]'s Stripe price per [interval] in [currency], in cents; null when
/// it has none.
int? _amount(CatalogPlan plan, String interval, String currency) => plan.prices
    .firstWhereOrNull(
      (price) => price.provider == 'stripe' && price.interval == interval,
    )
    ?.amounts[currency];

/// [cents] as the plan pages show prices: "CHF 9", or "CHF 9.50".
String _money(BuildContext context, int cents, String currency) =>
    NumberFormat.simpleCurrency(
          locale: Localizations.localeOf(context).toString(),
          name: currency,
          decimalDigits: cents % 100 == 0 ? 0 : 2,
        )
        .format(cents / 100)
        // intl writes "CHF9": a currency code before the number needs a space.
        .replaceFirstMapped(
          RegExp(r'^([A-Z]{3})(\d)'),
          (match) => '${match[1]} ${match[2]}',
        );
