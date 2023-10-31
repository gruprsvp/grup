import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.profile)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage('assets/images/wolf.png'),
              radius: 64,
              child: Icon(
                Icons.camera_alt_rounded,
                size: 32,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const NameWidget()
            // TODO(borgoat): options to link additional auth providers
          ],
        ),
      ),
    );
  }
}

class NameWidget extends StatefulWidget {
  const NameWidget({super.key});

  @override
  _NameWidgetState createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.enterYourName,
      ),
      controller: _controller,
    );
  }
}
