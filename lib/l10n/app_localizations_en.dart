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
  String get defaultRules => 'Default replies';

  @override
  String get defaultRulesDescription =>
      'Choose a default reply to apply to this event';

  @override
  String get defaultRulesDaily => 'Daily';

  @override
  String get defaultRulesExplanation =>
      'Default replies allow you to set automatic responses for recurring events. You can choose from daily, weekdays, or weekends options.';

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
  String get groupEmptyEventsAdmin =>
      'Your event calendar is empty.<br/>Ready to plan something exciting? Tap the <manage/> button to create a new event and invite your group members!';

  @override
  String get groupEmptyEventsUser =>
      'There are no events for this specific day, check another date!';

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
    String _temp0 = intl.Intl.selectLogic(
      role,
      {
        'admin': 'Admin',
        'member': 'Member',
        'other': 'Unknown',
      },
    );
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
  String get onboardingMessage =>
      'Welcome to <title>GRUP</title>!<br/>You haven’t created any groups yet. Start by tapping the <plus/> button to create your first group and begin organizing events with friends, family, or colleagues.';

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
}
