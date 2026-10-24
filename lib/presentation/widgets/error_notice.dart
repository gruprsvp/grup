import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';

/// Explains [error] to the user.
String errorMessage(AppLocalizations l10n, Exception error) => switch (error) {
  NetworkException() => l10n.errorNetwork,
  NotFoundException() => l10n.errorNotFound,
  NotAllowedException() => l10n.errorNotAllowed,
  InvalidInviteCodeException() => l10n.errorInvalidInviteCode,
  AlreadyMemberException() => l10n.errorAlreadyMember,
  NotSignedInException() => l10n.errorNotSignedIn,
  _ => l10n.errorGeneric,
};

/// Tells the user why [result] failed, if it did, in a snack bar.
void showFailure(BuildContext context, Result<Object?>? result) {
  if (result case Error(:final error)) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(errorMessage(AppLocalizations.of(context)!, error)),
        ),
      );
  }
}

/// Confirms a change that's easy to make by mistake, with a way to [undo] it.
void showUndo(
  BuildContext context,
  String message,
  Future<Result<Object?>> Function() undo,
) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo,
          onPressed: () async {
            final result = await undo();
            if (context.mounted) showFailure(context, result);
          },
        ),
      ),
    );
}

/// Says why loading failed, with a way to try again.
class ErrorNotice extends StatelessWidget {
  const ErrorNotice({super.key, required this.error, this.onRetry});

  final Exception error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.cloud_off, color: colorScheme.error),
          const SizedBox(width: 16),
          Expanded(child: Text(errorMessage(l10n, error))),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}
