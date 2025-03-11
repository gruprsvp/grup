import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'GRUP'**
  String get appName;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get addContact;

  /// No description provided for @addInvite.
  ///
  /// In en, this message translates to:
  /// **'Add invite'**
  String get addInvite;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get changeTheme;

  /// No description provided for @chooseNewProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Choose new profile picture'**
  String get chooseNewProfilePicture;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactEmail;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get contactName;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactPhone;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @contactNew.
  ///
  /// In en, this message translates to:
  /// **'New contact'**
  String get contactNew;

  /// No description provided for @contactsPermission.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission'**
  String get contactsPermission;

  /// No description provided for @contactsPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'To invite your friends to groups you need to grant access to your contacts'**
  String get contactsPermissionMessage;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createNewEvent.
  ///
  /// In en, this message translates to:
  /// **'Create new event'**
  String get createNewEvent;

  /// No description provided for @createNewGroup.
  ///
  /// In en, this message translates to:
  /// **'Create new group'**
  String get createNewGroup;

  /// No description provided for @createOrJoinGroup.
  ///
  /// In en, this message translates to:
  /// **'Create or join group'**
  String get createOrJoinGroup;

  /// No description provided for @defaultRules.
  ///
  /// In en, this message translates to:
  /// **'Default replies'**
  String get defaultRules;

  /// No description provided for @defaultRulesDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a default reply to apply to this event'**
  String get defaultRulesDescription;

  /// No description provided for @defaultRulesDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get defaultRulesDaily;

  /// No description provided for @defaultRulesExplanation.
  ///
  /// In en, this message translates to:
  /// **'Default replies allow you to set automatic responses for recurring events. You can choose from daily, weekdays, or weekends options.'**
  String get defaultRulesExplanation;

  /// No description provided for @defaultRulesWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get defaultRulesWeekdays;

  /// No description provided for @defaultRulesWeekends.
  ///
  /// In en, this message translates to:
  /// **'Weekends'**
  String get defaultRulesWeekends;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete group'**
  String get deleteGroup;

  /// No description provided for @deleteGroupConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this group?'**
  String get deleteGroupConfirmation;

  /// No description provided for @deleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete profile'**
  String get deleteProfile;

  /// No description provided for @deleteProfileConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your profile?'**
  String get deleteProfileConfirmation;

  /// No description provided for @deleteSchedule.
  ///
  /// In en, this message translates to:
  /// **'Delete event'**
  String get deleteSchedule;

  /// No description provided for @deleteScheduleConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this event?'**
  String get deleteScheduleConfirmation;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @enterGroupDescription.
  ///
  /// In en, this message translates to:
  /// **'You may enter an optional group description'**
  String get enterGroupDescription;

  /// No description provided for @enterGroupName.
  ///
  /// In en, this message translates to:
  /// **'Enter a group name'**
  String get enterGroupName;

  /// No description provided for @enterGroupNamePlease.
  ///
  /// In en, this message translates to:
  /// **'A group name is required'**
  String get enterGroupNamePlease;

  /// No description provided for @enterInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Enter invite code'**
  String get enterInviteCode;

  /// No description provided for @enterInviteCodePlease.
  ///
  /// In en, this message translates to:
  /// **'An invite code is required'**
  String get enterInviteCodePlease;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterYourNamePlease.
  ///
  /// In en, this message translates to:
  /// **'A name is required'**
  String get enterYourNamePlease;

  /// No description provided for @eventDatetime.
  ///
  /// In en, this message translates to:
  /// **'Event date and time'**
  String get eventDatetime;

  /// No description provided for @eventName.
  ///
  /// In en, this message translates to:
  /// **'Event name'**
  String get eventName;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @eventsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Time to bring your group to life!<br/>Tap the <newevent/> button to schedule your first activity.<br/>Choose a date, set a time, and add details to get everyone excited about coming together.'**
  String get eventsEmpty;

  /// No description provided for @feedbackEmailCantSend.
  ///
  /// In en, this message translates to:
  /// **'Could not open an email client. You can send us an email at {email}'**
  String feedbackEmailCantSend(Object email);

  /// No description provided for @feedbackEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'Feedback for GRUP'**
  String get feedbackEmailSubject;

  /// No description provided for @feedbackEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Hi GRUP team,\n\nI have some feedback for you:\n\n'**
  String get feedbackEmailBody;

  /// No description provided for @feedbackPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'How are we doing?'**
  String get feedbackPromptTitle;

  /// No description provided for @feedbackPromptBody.
  ///
  /// In en, this message translates to:
  /// **'If you like <title>GRUP</title>, please leave us a positive review to reach more people!\nIf you have any feedback, please let us know so we can improve.'**
  String get feedbackPromptBody;

  /// No description provided for @feedbackStoreReview.
  ///
  /// In en, this message translates to:
  /// **'Rate us on {store}'**
  String feedbackStoreReview(Object store);

  /// No description provided for @feedbackTellUs.
  ///
  /// In en, this message translates to:
  /// **'Send us a message'**
  String get feedbackTellUs;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @groupDismissAdmin.
  ///
  /// In en, this message translates to:
  /// **'Dismiss as admin'**
  String get groupDismissAdmin;

  /// No description provided for @groupDismissAdminConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to dismiss this member as an admin?'**
  String get groupDismissAdminConfirmation;

  /// No description provided for @groupEmptyEventsAdmin.
  ///
  /// In en, this message translates to:
  /// **'Your event calendar is empty.<br/>Ready to plan something exciting? Tap the <manage/> button to create a new event and invite your group members!'**
  String get groupEmptyEventsAdmin;

  /// No description provided for @groupEmptyEventsUser.
  ///
  /// In en, this message translates to:
  /// **'There are no events for this specific day, check another date!'**
  String get groupEmptyEventsUser;

  /// No description provided for @groupLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave group'**
  String get groupLeave;

  /// No description provided for @groupLeaveConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this group? You will lose access to all group events and members.'**
  String get groupLeaveConfirmation;

  /// No description provided for @groupMakeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Make group admin'**
  String get groupMakeAdmin;

  /// No description provided for @groupMakeAdminConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to make this member an admin?'**
  String get groupMakeAdminConfirmation;

  /// No description provided for @groupManage.
  ///
  /// In en, this message translates to:
  /// **'Manage group'**
  String get groupManage;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant permission'**
  String get grantPermission;

  /// No description provided for @groupRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Remove from group'**
  String get groupRemoveMember;

  /// No description provided for @groupRemoveConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this member from the group?'**
  String get groupRemoveConfirmation;

  /// Member roles in a group
  ///
  /// In en, this message translates to:
  /// **'{role, select, admin{Admin} member{Member} other{Unknown}}'**
  String groupRoles(String role);

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite members'**
  String get invite;

  /// Explain to admins how to use the invite code
  ///
  /// In en, this message translates to:
  /// **'Share this code with {user} to invite them to the group'**
  String inviteCodeExplanation(String user);

  /// Invite message to send to friends
  ///
  /// In en, this message translates to:
  /// **'Hey, join my group on GRUP! Use this code {code} or click here: {link}'**
  String inviteMessage(String code, String link);

  /// No description provided for @invites.
  ///
  /// In en, this message translates to:
  /// **'Invites'**
  String get invites;

  /// No description provided for @invitesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your group is waiting for its first member!<br/>Tap the <invite/> button to add friends, family, or colleagues.'**
  String get invitesEmpty;

  /// No description provided for @inviteFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Invite from contacts'**
  String get inviteFromContacts;

  /// No description provided for @inviteManual.
  ///
  /// In en, this message translates to:
  /// **'Invite manually'**
  String get inviteManual;

  /// No description provided for @inviteMembersCTA.
  ///
  /// In en, this message translates to:
  /// **'Invite some friends!'**
  String get inviteMembersCTA;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @joinGroup.
  ///
  /// In en, this message translates to:
  /// **'Join group'**
  String get joinGroup;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @newGroup.
  ///
  /// In en, this message translates to:
  /// **'New group'**
  String get newGroup;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @onboardingMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to <title>GRUP</title>!<br/>You haven’t created any groups yet. Start by tapping the <plus/> button to create your first group and begin organizing events with friends, family, or colleagues.'**
  String get onboardingMessage;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @recurrenceRule.
  ///
  /// In en, this message translates to:
  /// **'Recurrence'**
  String get recurrenceRule;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @selectContacts.
  ///
  /// In en, this message translates to:
  /// **'Select contacts'**
  String get selectContacts;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsMoreInfo.
  ///
  /// In en, this message translates to:
  /// **'More info'**
  String get settingsMoreInfo;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmation;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get systemLanguage;

  /// No description provided for @timezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezone;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
