// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'GRUP';

  @override
  String get addContact => 'Add contact';

  @override
  String get addInvite => 'Add invite';

  @override
  String get camera => 'Camera';

  @override
  String get cancel => 'Cancel';

  @override
  String get changeTheme => 'Theme';

  @override
  String get chooseNewProfilePicture => 'Choose new profile picture';

  @override
  String get confirm => 'Confirm';

  @override
  String get contactEmail => 'Email';

  @override
  String get contactName => 'Name';

  @override
  String get contactPhone => 'Phone';

  @override
  String get contacts => 'Contacts';

  @override
  String get contactNew => 'New contact';

  @override
  String get contactsPermission => 'Contacts permission';

  @override
  String get contactsPermissionMessage =>
      'To invite your friends to groups you need to grant access to your contacts';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get copy => 'Copy';

  @override
  String get create => 'Create';

  @override
  String get createNewEvent => 'Create new event';

  @override
  String get createNewGroup => 'Create new group';

  @override
  String get createOrJoinGroup => 'Create or join group';

  @override
  String get defaultRulesExplanation =>
      'Your usual answer fills in every occurrence it covers, so you\'re counted without answering each time. You can still change any single day.';

  @override
  String get defaultRulesWeekdays => 'Weekdays';

  @override
  String get defaultRulesWeekends => 'Weekends';

  @override
  String get delete => 'Delete';

  @override
  String get deleteGroup => 'Delete group';

  @override
  String get deleteGroupConfirmation =>
      'Are you sure you want to delete this group?';

  @override
  String get deleteProfile => 'Delete profile';

  @override
  String get deleteProfileConfirmation =>
      'Are you sure you want to delete your profile?';

  @override
  String get deleteSchedule => 'Delete event';

  @override
  String get deleteScheduleConfirmation =>
      'Are you sure you want to delete this event?';

  @override
  String get details => 'Details';

  @override
  String get enterGroupDescription =>
      'You may enter an optional group description';

  @override
  String get enterGroupName => 'Enter a group name';

  @override
  String get enterGroupNamePlease => 'A group name is required';

  @override
  String get enterInviteCode => 'Enter invite code';

  @override
  String get enterInviteCodePlease => 'An invite code is required';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get enterYourNamePlease => 'A name is required';

  @override
  String get eventDatetime => 'Event date and time';

  @override
  String get eventName => 'Event name';

  @override
  String get events => 'Events';

  @override
  String get eventsEmpty =>
      'Time to bring your group to life!<br/>Tap the <newevent/> button to schedule your first activity.<br/>Choose a date, set a time, and add details to get everyone excited about coming together.';

  @override
  String feedbackEmailCantSend(Object email) {
    return 'Could not open an email client. You can send us an email at $email';
  }

  @override
  String get feedbackEmailSubject => 'Feedback for GRUP';

  @override
  String get feedbackEmailBody =>
      'Hi GRUP team,\n\nI have some feedback for you:\n\n';

  @override
  String get feedbackPromptTitle => 'How are we doing?';

  @override
  String get feedbackPromptBody =>
      'If you like <title>GRUP</title>, please leave us a positive review to reach more people!\nIf you have any feedback, please let us know so we can improve.';

  @override
  String feedbackStoreReview(Object store) {
    return 'Rate us on $store';
  }

  @override
  String get feedbackTellUs => 'Send us a message';

  @override
  String get gallery => 'Gallery';

  @override
  String get groupDismissAdmin => 'Dismiss as admin';

  @override
  String get groupDismissAdminConfirmation =>
      'Are you sure you want to dismiss this member as an admin?';

  @override
  String get groupEmptyEventsUser =>
      'This group has no events yet.<br/>When an admin adds one, it shows up here and you answer with one tap.';

  @override
  String get groupLeave => 'Leave group';

  @override
  String get groupLeaveConfirmation =>
      'Are you sure you want to leave this group? You will lose access to all group events and members.';

  @override
  String get groupMakeAdmin => 'Make group admin';

  @override
  String get groupMakeAdminConfirmation =>
      'Are you sure you want to make this member an admin?';

  @override
  String get groupManage => 'Manage group';

  @override
  String get grantPermission => 'Grant permission';

  @override
  String get groupRemoveMember => 'Remove from group';

  @override
  String get groupRemoveConfirmation =>
      'Are you sure you want to remove this member from the group?';

  @override
  String groupRoles(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Admin',
      'member': 'Member',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String get guest => 'Guest';

  @override
  String get invite => 'Invite members';

  @override
  String inviteCodeExplanation(String user) {
    return 'Share this code with $user to invite them to the group';
  }

  @override
  String inviteMessage(String code, String link) {
    return 'Hey, join my group on GRUP! Use this code $code or click here: $link';
  }

  @override
  String get invites => 'Invites';

  @override
  String get invitesEmpty =>
      'Your group is waiting for its first member!<br/>Tap the <invite/> button to add friends, family, or colleagues.';

  @override
  String get inviteFromContacts => 'Invite from contacts';

  @override
  String get inviteManual => 'Invite manually';

  @override
  String get inviteMembersCTA => 'Invite some friends!';

  @override
  String get join => 'Join';

  @override
  String get joinGroup => 'Join group';

  @override
  String get language => 'Language';

  @override
  String get loading => 'Loading...';

  @override
  String get members => 'Members';

  @override
  String get newGroup => 'New group';

  @override
  String get no => 'No';

  @override
  String get profile => 'Profile';

  @override
  String get recurrenceRule => 'Recurrence';

  @override
  String get save => 'Save';

  @override
  String get selectContacts => 'Select contacts';

  @override
  String get settings => 'Settings';

  @override
  String get settingsMoreInfo => 'More info';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirmation => 'Are you sure you want to sign out?';

  @override
  String get systemLanguage => 'System language';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get unknown => 'Unknown';

  @override
  String get yes => 'Yes';

  @override
  String get you => 'You';

  @override
  String get errorNetwork =>
      'Couldn\'t reach GRUP. Check your connection and try again.';

  @override
  String get errorNotFound =>
      'This isn\'t available any more. It may have been deleted, or you no longer have access.';

  @override
  String get errorNotAllowed => 'You\'re not allowed to do that.';

  @override
  String get errorInvalidInviteCode =>
      'This invite code isn\'t valid. Check it and try again.';

  @override
  String get errorAlreadyMember => 'You\'re already a member of this group.';

  @override
  String get errorNotSignedIn => 'You\'re signed out. Sign in and try again.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get joiningGroup => 'Joining the group…';

  @override
  String get joinedGroup => 'You joined the group!';

  @override
  String get goToGroups => 'Go to your groups';

  @override
  String get licenses => 'Licenses';

  @override
  String get recurrenceOnce => 'Once';

  @override
  String get recurrenceDaily => 'Every day';

  @override
  String get recurrenceWeekly => 'Every week';

  @override
  String get recurrenceMonthly => 'Every month';

  @override
  String get recurrenceYearly => 'Every year';

  @override
  String get recurrenceWeekdays => 'On weekdays';

  @override
  String get recurrenceWeekends => 'On weekends';

  @override
  String get recurrenceCustom => 'Custom';

  @override
  String get authEnterEmail => 'Enter your email';

  @override
  String get authValidEmailError => 'Please enter a valid email address';

  @override
  String get authEnterPassword => 'Enter your password';

  @override
  String get authPasswordLengthError =>
      'Please enter a password that is at least 6 characters long';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authForgotPassword => 'Forgot your password?';

  @override
  String get authDontHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get authHaveAccount => 'Already have an account? Sign in';

  @override
  String get authSendPasswordReset => 'Send password reset email';

  @override
  String get authPasswordResetSent => 'Password reset email has been sent';

  @override
  String get authBackToSignIn => 'Back to sign in';

  @override
  String get authUnexpectedError => 'An unexpected error occurred';

  @override
  String get authRequiredFieldError => 'This field is required';

  @override
  String get authConfirmPasswordError => 'Passwords do not match';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authEnterOtpCode => 'Enter OTP code';

  @override
  String get authEnterNewPassword => 'Enter new password';

  @override
  String get authChangePassword => 'Change Password';

  @override
  String get authPasswordChangedSuccess => 'Password successfully updated';

  @override
  String get authOtpCodeError => 'Invalid OTP code';

  @override
  String get authOtpDisabledError => 'OTP disabled';

  @override
  String get authEnterPhoneNumber => 'Enter your phone number';

  @override
  String get authValidPhoneNumberError => 'Please enter a valid phone number';

  @override
  String get authContinueWithMagicLink => 'Continue with magic Link';

  @override
  String get authCheckYourEmail => 'Check your email inbox!';

  @override
  String get authSuccessSignInMessage => 'Successfully signed in!';

  @override
  String get authUpdatePassword => 'Update Password';

  @override
  String get authEnterOneTimeCode => 'Please enter the one time code sent';

  @override
  String get authEnterCodeSent => 'Enter the code sent';

  @override
  String get authVerifyPhone => 'Verify Phone';

  @override
  String authContinueWithProvider(String provider) {
    return 'Continue with $provider';
  }

  @override
  String get updateRequiredTitle => 'Update GRUP';

  @override
  String get updateRequiredBody =>
      'This version of GRUP is no longer supported. Update the app to keep using it.';

  @override
  String get updateRequiredAction => 'Update';

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get notFoundBody =>
      'This link doesn\'t lead to anything in GRUP. It may be mistyped, or what it pointed to is gone.';

  @override
  String get notFoundAction => 'Go to your groups';

  @override
  String eventComing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count coming',
      one: '1 coming',
    );
    return '$_temp0';
  }

  @override
  String eventUsually(int count) {
    return '+$count usually';
  }

  @override
  String eventOut(int count) {
    return '$count out';
  }

  @override
  String eventNoReply(int count) {
    return '$count no reply';
  }

  @override
  String get noReplyYet => 'No reply yet';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get noEventsThisDay => 'No events on this day.';

  @override
  String nextEvent(String event, String date) {
    return 'Next: $event, $date';
  }

  @override
  String get eventNotFound => 'This event isn\'t on this day.';

  @override
  String get usualAnswer => 'usual answer';

  @override
  String get answerComing => 'coming';

  @override
  String get answerNotComing => 'not coming';

  @override
  String get answerUsuallyComing => 'usually coming';

  @override
  String get answerUsuallyNotComing => 'usually not coming';

  @override
  String get answerNoReply => 'no reply yet';

  @override
  String get usualAnswerYours => 'Your usual answer';

  @override
  String usualAnswerFor(String name) {
    return 'Usual answer for $name';
  }

  @override
  String get usualEveryTime => 'Every time';

  @override
  String get usuallyIn => 'Usually in';

  @override
  String get usuallyOut => 'Usually out';

  @override
  String usuallyInWhen(String when) {
    return 'Usually in · $when';
  }

  @override
  String usuallyOutWhen(String when) {
    return 'Usually out · $when';
  }

  @override
  String get setUsualAnswer => 'Set your usual answer';

  @override
  String get usualAnswerSaved => 'Usual answer saved';

  @override
  String get usualAnswerRemoved => 'Usual answer removed';

  @override
  String get undo => 'Undo';

  @override
  String markedComing(String name) {
    return '$name marked as coming';
  }

  @override
  String markedNotComing(String name) {
    return '$name marked as not coming';
  }

  @override
  String answerCleared(String name) {
    return 'Answer cleared for $name';
  }

  @override
  String get onboardingWelcome => 'Welcome to <title>GRUP</title>';

  @override
  String get onboardingTagline => 'Know who\'s coming, without asking around.';

  @override
  String get onboardingExampleEvent => 'Tuesday football';

  @override
  String get onboardingExampleCaption =>
      'Every event shows you who\'s coming. Usual answers count separately until people confirm.';

  @override
  String get onboardingStepGroup => 'Start a group';

  @override
  String get onboardingStepGroupHint =>
      'For the people you meet with: a team, a club, friends or family.';

  @override
  String get onboardingStepEvent => 'Add its events';

  @override
  String get onboardingStepEventHint =>
      'Make one repeat if you meet every week.';

  @override
  String get onboardingStepInvite => 'Invite your people';

  @override
  String get onboardingStepInviteHint =>
      'They answer with one tap, or set a usual answer once.';

  @override
  String get onboardingJoin => 'Join with an invite code';

  @override
  String get groupSetupTitle => 'Get your group going';

  @override
  String get groupSetupBody =>
      'Its events show up here, with who\'s coming to each.';

  @override
  String get groupSetupEvent => 'Add the first event';

  @override
  String get profileNameHelper =>
      'Your groups see this name next to your answers.';

  @override
  String get signUpCheckEmail =>
      'Almost there: open the link we emailed you to finish signing up.';
}
