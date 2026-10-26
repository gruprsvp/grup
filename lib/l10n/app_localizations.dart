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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
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
    Locale('it'),
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

  /// No description provided for @defaultRulesExplanation.
  ///
  /// In en, this message translates to:
  /// **'Your usual answer fills in every occurrence it covers, so you\'re counted without answering each time. You can still change any single day.'**
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

  /// No description provided for @groupEmptyEventsUser.
  ///
  /// In en, this message translates to:
  /// **'This group has no events yet.<br/>When an admin adds one, it shows up here and you answer with one tap.'**
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

  /// Shown when the server can't be reached.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach GRUP. Check your connection and try again.'**
  String get errorNetwork;

  /// Shown when something the user acted on was deleted, or they lost access to it.
  ///
  /// In en, this message translates to:
  /// **'This isn\'t available any more. It may have been deleted, or you no longer have access.'**
  String get errorNotFound;

  /// Shown when the server refuses an action the user isn't allowed to do.
  ///
  /// In en, this message translates to:
  /// **'You\'re not allowed to do that.'**
  String get errorNotAllowed;

  /// Shown when joining a group with a code that matches no invite.
  ///
  /// In en, this message translates to:
  /// **'This invite code isn\'t valid. Check it and try again.'**
  String get errorInvalidInviteCode;

  /// Shown when joining a group the user is already in.
  ///
  /// In en, this message translates to:
  /// **'You\'re already a member of this group.'**
  String get errorAlreadyMember;

  /// Shown when an action needs a signed-in user but the session ended.
  ///
  /// In en, this message translates to:
  /// **'You\'re signed out. Sign in and try again.'**
  String get errorNotSignedIn;

  /// Shown for any unexpected failure.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// Button that tries a failed load again.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Shown while an invite link is being used to join a group.
  ///
  /// In en, this message translates to:
  /// **'Joining the group…'**
  String get joiningGroup;

  /// Confirmation after joining a group from an invite link.
  ///
  /// In en, this message translates to:
  /// **'You joined the group!'**
  String get joinedGroup;

  /// Button that leaves an error screen for the home screen.
  ///
  /// In en, this message translates to:
  /// **'Go to your groups'**
  String get goToGroups;

  /// Settings entry that opens the open-source licenses page.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// A recurrence option: the event happens once.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get recurrenceOnce;

  /// A recurrence option.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get recurrenceDaily;

  /// A recurrence option.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get recurrenceWeekly;

  /// A recurrence option.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get recurrenceMonthly;

  /// A recurrence option.
  ///
  /// In en, this message translates to:
  /// **'Every year'**
  String get recurrenceYearly;

  /// A recurrence option: Monday to Friday.
  ///
  /// In en, this message translates to:
  /// **'On weekdays'**
  String get recurrenceWeekdays;

  /// A recurrence option: Saturday and Sunday.
  ///
  /// In en, this message translates to:
  /// **'On weekends'**
  String get recurrenceWeekends;

  /// A recurrence the app has no name for.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get recurrenceCustom;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEnterEmail;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get authValidEmailError;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authEnterPassword;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password that is at least 6 characters long'**
  String get authPasswordLengthError;

  /// Sign-in screen button.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// Sign-in screen button.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get authForgotPassword;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get authDontHaveAccount;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authHaveAccount;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Send password reset email'**
  String get authSendPasswordReset;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Password reset email has been sent'**
  String get authPasswordResetSent;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get authBackToSignIn;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get authUnexpectedError;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get authRequiredFieldError;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authConfirmPasswordError;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP code'**
  String get authEnterOtpCode;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get authEnterNewPassword;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get authChangePassword;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Password successfully updated'**
  String get authPasswordChangedSuccess;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP code'**
  String get authOtpCodeError;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'OTP disabled'**
  String get authOtpDisabledError;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get authEnterPhoneNumber;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get authValidPhoneNumberError;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Continue with magic Link'**
  String get authContinueWithMagicLink;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Check your email inbox!'**
  String get authCheckYourEmail;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Successfully signed in!'**
  String get authSuccessSignInMessage;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get authUpdatePassword;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Please enter the one time code sent'**
  String get authEnterOneTimeCode;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent'**
  String get authEnterCodeSent;

  /// Sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Verify Phone'**
  String get authVerifyPhone;

  /// Sign-in screen: a social sign-in button, e.g. 'Continue with Google'.
  ///
  /// In en, this message translates to:
  /// **'Continue with {provider}'**
  String authContinueWithProvider(String provider);

  /// No description provided for @updateRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Update GRUP'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'This version of GRUP is no longer supported. Update the app to keep using it.'**
  String get updateRequiredBody;

  /// No description provided for @updateRequiredAction.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateRequiredAction;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// No description provided for @notFoundBody.
  ///
  /// In en, this message translates to:
  /// **'This link doesn\'t lead to anything in GRUP. It may be mistyped, or what it pointed to is gone.'**
  String get notFoundBody;

  /// No description provided for @notFoundAction.
  ///
  /// In en, this message translates to:
  /// **'Go to your groups'**
  String get notFoundAction;

  /// Headline count of people coming to an event (answered yes).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 coming} other{{count} coming}}'**
  String eventComing(int count);

  /// People counted as coming only by their usual answer, shown after the headline count.
  ///
  /// In en, this message translates to:
  /// **'+{count} usually'**
  String eventUsually(int count);

  /// How many answered no.
  ///
  /// In en, this message translates to:
  /// **'{count} out'**
  String eventOut(int count);

  /// How many haven't answered.
  ///
  /// In en, this message translates to:
  /// **'{count} no reply'**
  String eventNoReply(int count);

  /// Section header for members who haven't answered.
  ///
  /// In en, this message translates to:
  /// **'No reply yet'**
  String get noReplyYet;

  /// Button that shows the day before.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get previousDay;

  /// Button that shows the day after.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get nextDay;

  /// A group's day with no events, when the group has events on other days.
  ///
  /// In en, this message translates to:
  /// **'No events on this day.'**
  String get noEventsThisDay;

  /// Button that jumps to the group's next event.
  ///
  /// In en, this message translates to:
  /// **'Next: {event}, {date}'**
  String nextEvent(String event, String date);

  /// An event link for a day the event doesn't happen on (or a deleted event).
  ///
  /// In en, this message translates to:
  /// **'This event isn\'t on this day.'**
  String get eventNotFound;

  /// Screen-reader value on an answer button that shows a usual answer, not a real one.
  ///
  /// In en, this message translates to:
  /// **'usual answer'**
  String get usualAnswer;

  /// Screen-reader status of a member.
  ///
  /// In en, this message translates to:
  /// **'coming'**
  String get answerComing;

  /// Screen-reader status of a member.
  ///
  /// In en, this message translates to:
  /// **'not coming'**
  String get answerNotComing;

  /// Screen-reader status of a member counted by their usual answer.
  ///
  /// In en, this message translates to:
  /// **'usually coming'**
  String get answerUsuallyComing;

  /// Screen-reader status of a member counted by their usual answer.
  ///
  /// In en, this message translates to:
  /// **'usually not coming'**
  String get answerUsuallyNotComing;

  /// Screen-reader status of a member who hasn't answered.
  ///
  /// In en, this message translates to:
  /// **'no reply yet'**
  String get answerNoReply;

  /// Title of the sheet that sets the user's usual answer.
  ///
  /// In en, this message translates to:
  /// **'Your usual answer'**
  String get usualAnswerYours;

  /// Title of the sheet where an admin sets a member's usual answer.
  ///
  /// In en, this message translates to:
  /// **'Usual answer for {name}'**
  String usualAnswerFor(String name);

  /// Usual-answer option covering every occurrence of the event.
  ///
  /// In en, this message translates to:
  /// **'Every time'**
  String get usualEveryTime;

  /// Under a member's name: their usual answer is yes, for every occurrence.
  ///
  /// In en, this message translates to:
  /// **'Usually in'**
  String get usuallyIn;

  /// Under a member's name: their usual answer is no, for every occurrence.
  ///
  /// In en, this message translates to:
  /// **'Usually out'**
  String get usuallyOut;

  /// Under a member's name: their usual answer is yes on some occurrences.
  ///
  /// In en, this message translates to:
  /// **'Usually in · {when}'**
  String usuallyInWhen(String when);

  /// Under a member's name: their usual answer is no on some occurrences.
  ///
  /// In en, this message translates to:
  /// **'Usually out · {when}'**
  String usuallyOutWhen(String when);

  /// Under the user's own row on a recurring event: opens the usual-answer sheet.
  ///
  /// In en, this message translates to:
  /// **'Set your usual answer'**
  String get setUsualAnswer;

  /// Confirmation after setting a usual answer.
  ///
  /// In en, this message translates to:
  /// **'Usual answer saved'**
  String get usualAnswerSaved;

  /// Confirmation after clearing a usual answer.
  ///
  /// In en, this message translates to:
  /// **'Usual answer removed'**
  String get usualAnswerRemoved;

  /// Snackbar action that reverts the last change.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// After an admin answers yes for a member.
  ///
  /// In en, this message translates to:
  /// **'{name} marked as coming'**
  String markedComing(String name);

  /// After an admin answers no for a member.
  ///
  /// In en, this message translates to:
  /// **'{name} marked as not coming'**
  String markedNotComing(String name);

  /// After an admin clears a member's answer.
  ///
  /// In en, this message translates to:
  /// **'Answer cleared for {name}'**
  String answerCleared(String name);

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to <title>GRUP</title>'**
  String get onboardingWelcome;

  /// No description provided for @onboardingTagline.
  ///
  /// In en, this message translates to:
  /// **'Know who\'s coming, without asking around.'**
  String get onboardingTagline;

  /// No description provided for @onboardingExampleEvent.
  ///
  /// In en, this message translates to:
  /// **'Tuesday football'**
  String get onboardingExampleEvent;

  /// No description provided for @onboardingExampleCaption.
  ///
  /// In en, this message translates to:
  /// **'Every event shows you who\'s coming. Usual answers count separately until people confirm.'**
  String get onboardingExampleCaption;

  /// No description provided for @onboardingStepGroup.
  ///
  /// In en, this message translates to:
  /// **'Start a group'**
  String get onboardingStepGroup;

  /// No description provided for @onboardingStepGroupHint.
  ///
  /// In en, this message translates to:
  /// **'For the people you meet with: a team, a club, friends or family.'**
  String get onboardingStepGroupHint;

  /// No description provided for @onboardingStepEvent.
  ///
  /// In en, this message translates to:
  /// **'Add its events'**
  String get onboardingStepEvent;

  /// No description provided for @onboardingStepEventHint.
  ///
  /// In en, this message translates to:
  /// **'Make one repeat if you meet every week.'**
  String get onboardingStepEventHint;

  /// No description provided for @onboardingStepInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite your people'**
  String get onboardingStepInvite;

  /// No description provided for @onboardingStepInviteHint.
  ///
  /// In en, this message translates to:
  /// **'They answer with one tap, or set a usual answer once.'**
  String get onboardingStepInviteHint;

  /// No description provided for @onboardingJoin.
  ///
  /// In en, this message translates to:
  /// **'Join with an invite code'**
  String get onboardingJoin;

  /// No description provided for @groupSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Get your group going'**
  String get groupSetupTitle;

  /// No description provided for @groupSetupBody.
  ///
  /// In en, this message translates to:
  /// **'Its events show up here, with who\'s coming to each.'**
  String get groupSetupBody;

  /// No description provided for @groupSetupEvent.
  ///
  /// In en, this message translates to:
  /// **'Add the first event'**
  String get groupSetupEvent;

  /// No description provided for @profileNameHelper.
  ///
  /// In en, this message translates to:
  /// **'Your groups see this name next to your answers.'**
  String get profileNameHelper;

  /// Shown after an email sign-up while the address still needs confirming.
  ///
  /// In en, this message translates to:
  /// **'Almost there: open the link we emailed you to finish signing up.'**
  String get signUpCheckEmail;

  /// Title of the card on the home screen asking once whether the user shares usage analytics. Playful.
  ///
  /// In en, this message translates to:
  /// **'Help us stop guessing'**
  String get analyticsTitle;

  /// Body of the analytics opt-in card: what is shared (which features are used, never content), and no ads.
  ///
  /// In en, this message translates to:
  /// **'Share which features you use, and we\'ll build what matters. We count taps, not secrets. No ads, ever.'**
  String get analyticsBody;

  /// Opt-in button on the analytics card.
  ///
  /// In en, this message translates to:
  /// **'Count me in'**
  String get analyticsYes;

  /// Opt-out button on the analytics card.
  ///
  /// In en, this message translates to:
  /// **'I\'ll pass'**
  String get analyticsNo;

  /// Settings switch that turns usage analytics on or off.
  ///
  /// In en, this message translates to:
  /// **'Help improve GRUP'**
  String get analyticsSetting;

  /// Subtitle of the usage analytics switch in settings.
  ///
  /// In en, this message translates to:
  /// **'We count taps, not secrets.'**
  String get analyticsSettingSubtitle;

  /// A group's spots are all taken (members with an account plus pending invites), so no one more can be invited.
  ///
  /// In en, this message translates to:
  /// **'Every spot in this group is taken.'**
  String get errorGroupFull;

  /// The group's paid plan doesn't include what the user tried to turn on.
  ///
  /// In en, this message translates to:
  /// **'This group\'s plan doesn\'t include this.'**
  String get errorFeatureLocked;

  /// A member tried to change an answer after the event's answer deadline.
  ///
  /// In en, this message translates to:
  /// **'Changes to this event have closed. Ask an admin.'**
  String get errorReplyLocked;

  /// Another admin already bought a plan for this group.
  ///
  /// In en, this message translates to:
  /// **'This group already has a plan.'**
  String get errorAlreadyFunded;

  /// Title of a group's plan page (paid plans), and the button that opens it.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planTitle;

  /// Name of the free plan.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get planFree;

  /// Name of a paid plan, by its code. Crew, Club and Crowd are product names: keep them in English in every language.
  ///
  /// In en, this message translates to:
  /// **'{plan, select, community_s{Crew} community_m{Club} community_l{Crowd} other{Plan}}'**
  String planName(String plan);

  /// Groups created before paid plans were announced get the paid features free until a date.
  ///
  /// In en, this message translates to:
  /// **'Founder perk: everything a plan includes, free until {date}'**
  String planFounderTrial(String date);

  /// Groups created before paid plans were announced never have a spot limit.
  ///
  /// In en, this message translates to:
  /// **'Founding group: no spot limit, ever'**
  String get planLegacy;

  /// A founding group tries a new paid feature for free until a date.
  ///
  /// In en, this message translates to:
  /// **'Early access to new features until {date}'**
  String planEarlyAccess(String date);

  /// Features the GRUP team gave the group for free, with no end.
  ///
  /// In en, this message translates to:
  /// **'Extra features from GRUP'**
  String get planExtra;

  /// Features the GRUP team gave the group for free, until a date.
  ///
  /// In en, this message translates to:
  /// **'Extra features from GRUP until {date}'**
  String planExtraUntil(String date);

  /// Who pays for the group's plan.
  ///
  /// In en, this message translates to:
  /// **'Paid by {payer}'**
  String planFundedBy(String payer);

  /// Who pays for the group's plan, and when it renews.
  ///
  /// In en, this message translates to:
  /// **'Paid by {payer} · renews on {date}'**
  String planFundedRenews(String payer, String date);

  /// Who pays for the group's plan, and when it ends (it was cancelled).
  ///
  /// In en, this message translates to:
  /// **'Paid by {payer} · ends on {date}'**
  String planFundedEnds(String payer, String date);

  /// The payer, when it's the user, inside 'Paid by {payer}'.
  ///
  /// In en, this message translates to:
  /// **'you'**
  String get planYou;

  /// The payer, when their name isn't known, inside 'Paid by {payer}'.
  ///
  /// In en, this message translates to:
  /// **'someone'**
  String get planSomeone;

  /// The payer's renewal failed and the store keeps retrying.
  ///
  /// In en, this message translates to:
  /// **'Payment issue: {payer} needs to update the payment method'**
  String planPaymentIssue(String payer);

  /// The user's renewal failed and the store keeps retrying.
  ///
  /// In en, this message translates to:
  /// **'Payment issue: update your payment method'**
  String get planPaymentIssueYou;

  /// Spots a group uses (members with an account or a pending invite) out of its plan's limit.
  ///
  /// In en, this message translates to:
  /// **'{seats} of {limit} spots taken'**
  String planSeats(int seats, int limit);

  /// The group may have any number of members.
  ///
  /// In en, this message translates to:
  /// **'No spot limit'**
  String get planNoSeatLimit;

  /// Every spot of the group is taken (on the plan page, where plans are sold).
  ///
  /// In en, this message translates to:
  /// **'Your group is full. To invite more people, pick a plan or free a spot.'**
  String get planSeatsFull;

  /// Spots a group without a limit uses (members with an account or a pending invite).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 spot taken} other{{count} spots taken}}'**
  String planSpotsTaken(int count);

  /// Every spot of a group with a paid plan is taken; the payer changes the size in Manage billing.
  ///
  /// In en, this message translates to:
  /// **'Your group is full. To invite more people, switch to a bigger size or free a spot.'**
  String get planSeatsFullPaid;

  /// Explains what takes a spot: an invite not yet accepted does; a guest without an account, whose answers an admin gives, doesn't.
  ///
  /// In en, this message translates to:
  /// **'Pending invites hold a spot too. Guests you answer for are free.'**
  String get planPendingInvites;

  /// Heading above the paid plans to choose from.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan'**
  String get planChoose;

  /// Billing interval toggle: pay every month.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get planMonthly;

  /// Billing interval toggle: pay every year.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get planYearly;

  /// A plan's spot limit, in people.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} people'**
  String planUpToSeats(int count);

  /// A plan's monthly price.
  ///
  /// In en, this message translates to:
  /// **'{price} a month'**
  String planPerMonth(String price);

  /// A plan's yearly price.
  ///
  /// In en, this message translates to:
  /// **'{price} a year'**
  String planPerYear(String price);

  /// Marks the smallest plan with a spot for everyone the group has.
  ///
  /// In en, this message translates to:
  /// **'Fits your group'**
  String get planRecommended;

  /// For groups bigger than the largest plan, which are invoiced by hand.
  ///
  /// In en, this message translates to:
  /// **'More than 80 people? Contact us'**
  String get planContactUs;

  /// Users who signed up before paid plans were announced get 30% off.
  ///
  /// In en, this message translates to:
  /// **'Your founder discount takes 30% off at checkout.'**
  String get planFounderDiscount;

  /// A founding group's free period runs until a date; buying now bills from then.
  ///
  /// In en, this message translates to:
  /// **'Nothing to pay until {date}, when your founder perk ends.'**
  String planBillingStarts(String date);

  /// Button that goes to the payment page for the chosen plan.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get planSubscribe;

  /// Back from paying, while the plan is being switched on.
  ///
  /// In en, this message translates to:
  /// **'Thanks! Switching on your plan…'**
  String get planActivating;

  /// Back from paying, when switching the plan on takes more than a minute.
  ///
  /// In en, this message translates to:
  /// **'Payment received. Activation is taking longer than usual; refresh in a minute.'**
  String get planActivationSlow;

  /// Opens the payment provider's page to change the plan, the payment method, see invoices or cancel.
  ///
  /// In en, this message translates to:
  /// **'Manage billing'**
  String get planManageBilling;

  /// Subtitle of 'Manage billing' in the settings.
  ///
  /// In en, this message translates to:
  /// **'Invoices, payment method and cancelling'**
  String get settingsBillingSubtitle;

  /// Name of a paid feature, by its key.
  ///
  /// In en, this message translates to:
  /// **'{feature, select, kitchen_view{Kitchen view} reply_cutoffs{Answer deadlines} export_csv{Spreadsheet export} other{Other}}'**
  String featureName(String feature);

  /// When the group is full, how an admin frees a spot (where plans can't be bought).
  ///
  /// In en, this message translates to:
  /// **'Remove members or pending invites to free a spot.'**
  String get seatsFullHint;

  /// Opens the group's plan page, from a full group's notice.
  ///
  /// In en, this message translates to:
  /// **'See plans'**
  String get seePlans;

  /// One plain sentence on what a paid feature does, by its key, under its name on the plan page.
  ///
  /// In en, this message translates to:
  /// **'{feature, select, kitchen_view{Each day\'s headcount with names, ready to print for the kitchen.} reply_cutoffs{Answers lock before the event, so your headcount holds.} export_csv{Download everyone\'s answers as a spreadsheet.} other{}}'**
  String featurePitch(String feature);

  /// On the plan page: paid plans fit more people than Free.
  ///
  /// In en, this message translates to:
  /// **'Room to grow'**
  String get planRoomTitle;

  /// Heading above what paid plans add, for a group without one.
  ///
  /// In en, this message translates to:
  /// **'Every plan includes'**
  String get planPerksEvery;

  /// Heading above what the group's paid plan includes.
  ///
  /// In en, this message translates to:
  /// **'Your plan includes'**
  String get planPerksYours;

  /// Under the button that opens the plans: the cheapest monthly price.
  ///
  /// In en, this message translates to:
  /// **'Plans from {price} a month'**
  String planFrom(String price);

  /// Title of the first step of buying a plan: how many people it fits.
  ///
  /// In en, this message translates to:
  /// **'Pick a size'**
  String get planSizeTitle;

  /// Under "Pick a size": the spots the group uses (members with an account or a pending invite); every size has the same features.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{You\'re using 1 spot now. Every size includes every perk.} other{You\'re using {count} spots now. Every size includes every perk.}}'**
  String planSizeHint(int count);

  /// A plan with fewer spots than the group already uses.
  ///
  /// In en, this message translates to:
  /// **'Too small for your group'**
  String get planTooSmall;

  /// Paying yearly costs 10 months.
  ///
  /// In en, this message translates to:
  /// **'2 months free'**
  String get planYearlySaving;

  /// Under a monthly price: the same plan paid yearly.
  ///
  /// In en, this message translates to:
  /// **'Or {price} a year: 2 months free'**
  String planYearlyNudge(String price);

  /// Under the button that goes to payment. The currency shown is a guess; the checkout page has the final price.
  ///
  /// In en, this message translates to:
  /// **'VAT included. You\'ll see the final price before you pay. Cancel anytime.'**
  String get planFinePrint;

  /// Under "Manage billing" on the plan page, for the payer.
  ///
  /// In en, this message translates to:
  /// **'Change size or payment method, get invoices, or cancel.'**
  String get planManageHint;

  /// On the plan card in Manage, for a group without a paid plan. Crew, Club and Crowd are plan names: keep them in English.
  ///
  /// In en, this message translates to:
  /// **'More spots and perks with Crew, Club or Crowd'**
  String get planCardUpsell;

  /// On the plan card in Manage, when every spot is taken.
  ///
  /// In en, this message translates to:
  /// **'Your group is full. Make room with a plan.'**
  String get planCardFull;

  /// On the plan card in Manage, for a group with a paid plan.
  ///
  /// In en, this message translates to:
  /// **'See your plan'**
  String get planCardSee;

  /// Back from paying, once the plan is on.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {plan}! Every perk is on.'**
  String planWelcome(String plan);

  /// Setting of an event: how long before it starts members can no longer change their answer.
  ///
  /// In en, this message translates to:
  /// **'Changes close'**
  String get cutoffLabel;

  /// Answers can change until the event starts: no deadline.
  ///
  /// In en, this message translates to:
  /// **'No deadline'**
  String get cutoffNone;

  /// How long before the event changes to answers close.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, =0{When it starts} =1{1 hour before} other{{hours} hours before}}'**
  String cutoffHours(int hours);

  /// Choose another number of hours for the answer deadline.
  ///
  /// In en, this message translates to:
  /// **'Custom…'**
  String get cutoffCustom;

  /// Field for a custom answer deadline, in hours before the event.
  ///
  /// In en, this message translates to:
  /// **'Hours before the start'**
  String get cutoffCustomTitle;

  /// Members can no longer change their answer to this event.
  ///
  /// In en, this message translates to:
  /// **'Changes closed at {time}'**
  String changesClosedAt(String time);

  /// Badge on a member who changed their answer after the deadline.
  ///
  /// In en, this message translates to:
  /// **'Late change'**
  String get lateChange;

  /// A day of the group's events as a kitchen needs it: headcounts and names, printable.
  ///
  /// In en, this message translates to:
  /// **'Kitchen view'**
  String get kitchenTitle;

  /// How many of those coming have an account.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String kitchenMembers(int count);

  /// How many of those coming are guests the admins answer for (no account).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 guest} other{{count} guests}}'**
  String kitchenGuests(int count);

  /// Heading of who changed their answer after the deadline.
  ///
  /// In en, this message translates to:
  /// **'Changed late'**
  String get kitchenLate;

  /// Prints the kitchen view of the day.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get kitchenPrint;

  /// No one is coming to the event yet.
  ///
  /// In en, this message translates to:
  /// **'Nobody\'s coming yet.'**
  String get kitchenNobody;

  /// A page for a feature the group doesn't have here.
  ///
  /// In en, this message translates to:
  /// **'This isn\'t available for this group.'**
  String get featureUnavailable;

  /// Menu item: download everyone's answers over a range of days as a spreadsheet (CSV).
  ///
  /// In en, this message translates to:
  /// **'Export answers'**
  String get exportAnswers;

  /// The export's range of days is longer than a year.
  ///
  /// In en, this message translates to:
  /// **'Choose at most a year.'**
  String get exportTooLong;

  /// How long before the event changes to answers close, when it isn't whole hours.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before'**
  String cutoffMinutes(int minutes);

  /// The custom answer deadline must be a whole number of hours up to a week.
  ///
  /// In en, this message translates to:
  /// **'Enter 0 to 168 hours.'**
  String get cutoffCustomInvalid;

  /// Creates an invite code for a member who hasn't joined, so they can join and answer for themselves.
  ///
  /// In en, this message translates to:
  /// **'Create an invite code'**
  String get inviteCreateCode;

  /// A member without an account or invite: admins answer for them.
  ///
  /// In en, this message translates to:
  /// **'{name} has no invite: admins answer for them.'**
  String guestNoInvite(String name);

  /// Withdraws a member's pending invites.
  ///
  /// In en, this message translates to:
  /// **'Cancel invites'**
  String get inviteCancel;

  /// What cancelling a member's pending invites does.
  ///
  /// In en, this message translates to:
  /// **'They stay in the group, answered for by admins, and free a spot.'**
  String get inviteCancelHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
