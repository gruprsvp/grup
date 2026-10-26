import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class GroupManageContainer extends StatelessWidget {
  final String groupId;

  const GroupManageContainer({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GroupManageViewModel(
      groupId: groupId,
      groups: context.read(),
      schedules: context.read(),
      billing: context.read(),
    ),
    child: Consumer<GroupManageViewModel>(
      builder: (context, vm, _) => GroupManageScreen(
        groupId: groupId,
        group: vm.group,
        loading:
            vm.load.running ||
            vm.update.running ||
            vm.invite.running ||
            vm.createSchedule.running ||
            vm.deleteSchedule.running ||
            vm.setCutoff.running ||
            vm.export.running,
        error: switch (vm.load.result) {
          Error(:final error) => error,
          _ => null,
        },
        onRetry: vm.load.execute,
        onDelete: vm.delete.running
            ? null
            : () async {
                await vm.delete.execute();
                if (!context.mounted) return;
                showFailure(context, vm.delete.result);
                if (vm.delete.completed) const HomeScreenRoute().go(context);
              },
        members: vm.members,
        onInvite: (contacts) async {
          await vm.invite.execute(contacts);
          if (context.mounted) showFailure(context, vm.invite.result);
        },
        schedules: vm.schedules,
        onCreateSchedule: (schedule) async {
          await vm.createSchedule.execute(schedule);
          if (context.mounted) showFailure(context, vm.createSchedule.result);
        },
        onDeleteSchedule: (schedule) async {
          await vm.deleteSchedule.execute(schedule);
          if (context.mounted) showFailure(context, vm.deleteSchedule.result);
        },
        onSave: (args) async {
          await vm.update.execute((group: args.$1, image: args.$2));
          if (context.mounted) showFailure(context, vm.update.result);
        },
        access: vm.access,
        onSetCutoff: (schedule, minutes) async {
          await vm.setCutoff.execute((schedule: schedule, minutes: minutes));
          if (context.mounted) showFailure(context, vm.setCutoff.result);
        },
        onExport: vm.export.running ? null : () => _export(context, vm),
      ),
    ),
  );

  /// Asks for up to a year of days, then hands over everyone's answers as
  /// CSV: through the share sheet on a phone, as a download on the web.
  Future<void> _export(BuildContext context, GroupManageViewModel vm) async {
    final today = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 2),
      initialDateRange: DateTimeRange(
        start: today.copyWith(day: today.day - 30),
        end: today,
      ),
    );
    if (range == null || !context.mounted) return;
    final first = range.start;
    final last = range.end;
    if (!last.isBefore(DateTime(first.year + 1, first.month, first.day))) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.exportTooLong)),
        );
      return;
    }
    await vm.export.execute((first: first, last: last));
    if (!context.mounted) return;
    final result = vm.export.result;
    if (result is! Ok<String>) return showFailure(context, result);
    final day = DateFormat('yyyy-MM-dd');
    final name = 'grup-answers-${day.format(first)}-${day.format(last)}.csv';
    // With a byte order mark, spreadsheets read the names as UTF-8.
    final file = XFile.fromData(
      utf8.encode('\uFEFF${result.value}'),
      mimeType: 'text/csv',
      name: name,
    );
    final shared = await guard(() async {
      // The web downloads it: browsers that can share files would offer the
      // system share sheet, not where a spreadsheet goes.
      if (kIsWeb) return file.saveTo(name);
      await SharePlus.instance.share(
        ShareParams(files: [file], fileNameOverrides: [name]),
      );
    });
    if (context.mounted) showFailure(context, shared);
  }
}
