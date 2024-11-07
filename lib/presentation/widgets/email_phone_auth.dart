import 'package:flutter/material.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class EmailOrPhoneAuth extends StatefulWidget {
  const EmailOrPhoneAuth({super.key});

  @override
  State<EmailOrPhoneAuth> createState() => _EmailOrPhoneAuthState();
}

enum AuthMethod {
  email,
  phone,
}

class _EmailOrPhoneAuthState extends State<EmailOrPhoneAuth> {
  onSuccess(session) => HomeScreenRoute().go(context);

  var _selected = AuthMethod.email;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SegmentedButton(
          segments: [
            ButtonSegment(value: AuthMethod.email, label: Text('Email')),
            ButtonSegment(value: AuthMethod.phone, label: Text('Phone')),
          ],
          selected: {_selected},
          emptySelectionAllowed: false,
          onSelectionChanged: (selection) {
            setState(() {
              _selected = selection.first;
            });
          },
        ),
        _selected == AuthMethod.email
            ? SupaEmailAuth(
                onSignInComplete: onSuccess,
                onSignUpComplete: onSuccess,
              )
            : SupaPhoneAuth(
                authAction: SupaAuthAction.signUp,
                onSuccess: onSuccess,
              ),
      ],
    );
  }
}
