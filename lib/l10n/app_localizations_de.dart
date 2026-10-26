// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'GRUP';

  @override
  String get addContact => 'Kontakt hinzufügen';

  @override
  String get addInvite => 'Einladung hinzufügen';

  @override
  String get camera => 'Kamera';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get changeTheme => 'Thema';

  @override
  String get chooseNewProfilePicture => 'Wähl ein neues Profilbild aus';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get contactEmail => 'E-Mail';

  @override
  String get contactName => 'Name';

  @override
  String get contactPhone => 'Telefon';

  @override
  String get contacts => 'Kontakte';

  @override
  String get contactNew => 'Neuer Kontakt';

  @override
  String get contactsPermission => 'Zugriff auf Kontakte';

  @override
  String get contactsPermissionMessage =>
      'Um deine Freunde zu Gruppen einzuladen, musst du uns den Zugriff auf deine Kontakte erlauben';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get copy => 'Kopieren';

  @override
  String get create => 'Erstellen';

  @override
  String get createNewEvent => 'Neues Event erstellen';

  @override
  String get createNewGroup => 'Neue Gruppe erstellen';

  @override
  String get createOrJoinGroup => 'Gruppe erstellen oder beitreten';

  @override
  String get defaultRulesExplanation =>
      'Deine übliche Antwort gilt für jedes passende Event, so wirst du mitgezählt, ohne jedes Mal zu antworten. Einzelne Tage kannst du trotzdem ändern.';

  @override
  String get defaultRulesWeekdays => 'Wochentage';

  @override
  String get defaultRulesWeekends => 'Wochenende';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteGroup => 'Gruppe löschen';

  @override
  String get deleteGroupConfirmation =>
      'Bist du sicher, dass du diese Gruppe löschen möchtest?';

  @override
  String get deleteProfile => 'Profil löschen';

  @override
  String get deleteProfileConfirmation =>
      'Bist du sicher, dass du dein Profil löschen möchtest?';

  @override
  String get deleteSchedule => 'Event löschen';

  @override
  String get deleteScheduleConfirmation =>
      'Bist du sicher, dass du dieses Event löschen möchtest?';

  @override
  String get details => 'Einzelheiten';

  @override
  String get enterGroupDescription =>
      'Du kannst eine optionale Gruppenbeschreibung eingeben';

  @override
  String get enterGroupName => 'Gib einen Gruppennamen ein';

  @override
  String get enterGroupNamePlease => 'Ein Gruppenname ist nötig';

  @override
  String get enterInviteCode => 'Gib einen Einladungscode ein';

  @override
  String get enterInviteCodePlease => 'Ein Einladungscode ist nötig';

  @override
  String get enterYourName => 'Gib deinen Namen ein';

  @override
  String get enterYourNamePlease => 'Ein Name ist nötig';

  @override
  String get eventDatetime => 'Datum und Uhrzeit des Events';

  @override
  String get eventName => 'Name des Events';

  @override
  String get events => 'Events';

  @override
  String get eventsEmpty =>
      'Es ist Zeit, deiner Gruppe Leben einzuhauchen!<br/>Tippe auf die Schaltfläche <newevent/>, um deine erste Aktivität zu planen.<br/>Wähle ein Datum, setze eine Uhrzeit und füge Details hinzu, um alle begeistert zu machen, zusammenzukommen.';

  @override
  String feedbackEmailCantSend(Object email) {
    return 'Konnte keinen E-Mail-Client öffnen. Du kannst uns eine E-Mail an $email senden';
  }

  @override
  String get feedbackEmailSubject => 'Feedback für GRUP';

  @override
  String get feedbackEmailBody =>
      'Hallo GRUP-Team,\n\nIch habe ein Feedback für euch:\n\n';

  @override
  String get feedbackPromptTitle => 'Wie machen wir uns?';

  @override
  String get feedbackPromptBody =>
      'Wenn dir <title>GRUP</title> gefällt, hinterlasse uns bitte eine positive Bewertung, um mehr Menschen zu erreichen!\nWenn du Feedback hast, lass es uns wissen, damit wir uns verbessern können.';

  @override
  String feedbackStoreReview(Object store) {
    return 'Bewerte uns auf $store';
  }

  @override
  String get feedbackTellUs => 'Sende uns eine Nachricht';

  @override
  String get gallery => 'Galerie';

  @override
  String get groupDismissAdmin => 'Admin entfernen';

  @override
  String get groupDismissAdminConfirmation =>
      'Bist du sicher, dass du dieses Mitglied als Admin entfernen möchtest?';

  @override
  String get groupEmptyEventsUser =>
      'Diese Gruppe hat noch keine Events.<br/>Sobald ein Admin eins hinzufügt, erscheint es hier und du antwortest mit einem Tipp.';

  @override
  String get groupLeave => 'Gruppe verlassen';

  @override
  String get groupLeaveConfirmation =>
      'Bist du sicher, dass du diese Gruppe verlassen möchtest? Du wirst den Zugriff auf alle Gruppen-Events und Mitglieder verlieren.';

  @override
  String get groupMakeAdmin => 'Zum Gruppenadmin machen';

  @override
  String get groupMakeAdminConfirmation =>
      'Bist du sicher, dass du dieses Mitglied zum Admin machen möchtest?';

  @override
  String get groupManage => 'Gruppe verwalten';

  @override
  String get grantPermission => 'Berechtigung erteilen';

  @override
  String get groupRemoveMember => 'Aus Gruppe entfernen';

  @override
  String get groupRemoveConfirmation =>
      'Bist du sicher, dass du dieses Mitglied aus der Gruppe entfernen möchtest?';

  @override
  String groupRoles(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Admin',
      'member': 'Mitglied',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String get guest => 'Gast';

  @override
  String get invite => 'Mitglieder einladen';

  @override
  String inviteCodeExplanation(String user) {
    return 'Teile diesen Code mit $user, um ihn in die Gruppe einzuladen';
  }

  @override
  String inviteMessage(String code, String link) {
    return 'Hey, tritt meiner Gruppe auf GRUP bei! Benutze diesen Code $code oder klicke hier: $link';
  }

  @override
  String get invites => 'Einladungen';

  @override
  String get invitesEmpty =>
      'Es ist Zeit, deine Freunde einzuladen, deinen Gruppen beizutreten!<br/>Tippe auf die Schaltfläche <invite/>, um deine Freunde einzuladen, deinen Gruppen beizutreten und gemeinsam Events zu organisieren.';

  @override
  String get inviteFromContacts => 'Aus Kontakten einladen';

  @override
  String get inviteManual => 'Manuell einladen';

  @override
  String get inviteMembersCTA => 'Lad\' ein paar Freunde ein!';

  @override
  String get join => 'Tritt bei';

  @override
  String get joinGroup => 'Tritt der Gruppe bei';

  @override
  String get language => 'Sprache';

  @override
  String get loading => 'Laden...';

  @override
  String get members => 'Mitglieder';

  @override
  String get newGroup => 'Neue Gruppe';

  @override
  String get no => 'Nein';

  @override
  String get profile => 'Profil';

  @override
  String get recurrenceRule => 'Wiederholung';

  @override
  String get save => 'Speichern';

  @override
  String get selectContacts => 'Wähl Kontakte aus';

  @override
  String get settings => 'Einstellungen';

  @override
  String get settingsMoreInfo => 'Mehr Informationen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signOutConfirmation =>
      'Bist du sicher, dass du dich abmelden möchtest?';

  @override
  String get systemLanguage => 'Systemsprache';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeSystem => 'System';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get yes => 'Ja';

  @override
  String get you => 'Du';

  @override
  String get errorNetwork =>
      'GRUP ist nicht erreichbar. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String get errorNotFound =>
      'Das ist nicht mehr verfügbar. Vielleicht wurde es gelöscht, oder du hast keinen Zugriff mehr.';

  @override
  String get errorNotAllowed => 'Das darfst du nicht.';

  @override
  String get errorInvalidInviteCode =>
      'Dieser Einladungscode ist ungültig. Prüfe ihn und versuche es erneut.';

  @override
  String get errorAlreadyMember => 'Du bist bereits Mitglied dieser Gruppe.';

  @override
  String get errorNotSignedIn =>
      'Du bist abgemeldet. Melde dich an und versuche es erneut.';

  @override
  String get errorGeneric =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get joiningGroup => 'Du trittst der Gruppe bei…';

  @override
  String get joinedGroup => 'Du bist der Gruppe beigetreten!';

  @override
  String get goToGroups => 'Zu deinen Gruppen';

  @override
  String get licenses => 'Lizenzen';

  @override
  String get recurrenceOnce => 'Einmalig';

  @override
  String get recurrenceDaily => 'Täglich';

  @override
  String get recurrenceWeekly => 'Wöchentlich';

  @override
  String get recurrenceMonthly => 'Monatlich';

  @override
  String get recurrenceYearly => 'Jährlich';

  @override
  String get recurrenceWeekdays => 'An Wochentagen';

  @override
  String get recurrenceWeekends => 'Am Wochenende';

  @override
  String get recurrenceCustom => 'Benutzerdefiniert';

  @override
  String get authEnterEmail => 'Gib deine E-Mail-Adresse ein';

  @override
  String get authValidEmailError => 'Bitte gib eine gültige E-Mail-Adresse ein';

  @override
  String get authEnterPassword => 'Gib dein Passwort ein';

  @override
  String get authPasswordLengthError =>
      'Bitte gib ein Passwort mit mindestens 6 Zeichen ein';

  @override
  String get authSignIn => 'Anmelden';

  @override
  String get authSignUp => 'Registrieren';

  @override
  String get authForgotPassword => 'Passwort vergessen?';

  @override
  String get authDontHaveAccount => 'Noch kein Konto? Registrieren';

  @override
  String get authHaveAccount => 'Schon ein Konto? Anmelden';

  @override
  String get authSendPasswordReset => 'E-Mail zum Zurücksetzen senden';

  @override
  String get authPasswordResetSent =>
      'Die E-Mail zum Zurücksetzen wurde gesendet';

  @override
  String get authBackToSignIn => 'Zurück zur Anmeldung';

  @override
  String get authUnexpectedError => 'Ein unerwarteter Fehler ist aufgetreten';

  @override
  String get authRequiredFieldError => 'Dieses Feld ist erforderlich';

  @override
  String get authConfirmPasswordError => 'Die Passwörter stimmen nicht überein';

  @override
  String get authConfirmPassword => 'Passwort bestätigen';

  @override
  String get authEnterOtpCode => 'Gib den Bestätigungscode ein';

  @override
  String get authEnterNewPassword => 'Gib ein neues Passwort ein';

  @override
  String get authChangePassword => 'Passwort ändern';

  @override
  String get authPasswordChangedSuccess => 'Passwort erfolgreich geändert';

  @override
  String get authOtpCodeError => 'Ungültiger Bestätigungscode';

  @override
  String get authOtpDisabledError => 'Bestätigungscodes sind deaktiviert';

  @override
  String get authEnterPhoneNumber => 'Gib deine Telefonnummer ein';

  @override
  String get authValidPhoneNumberError =>
      'Bitte gib eine gültige Telefonnummer ein';

  @override
  String get authContinueWithMagicLink => 'Weiter mit Magic Link';

  @override
  String get authCheckYourEmail => 'Schau in dein E-Mail-Postfach!';

  @override
  String get authSuccessSignInMessage => 'Erfolgreich angemeldet!';

  @override
  String get authUpdatePassword => 'Passwort aktualisieren';

  @override
  String get authEnterOneTimeCode => 'Bitte gib den gesendeten Einmalcode ein';

  @override
  String get authEnterCodeSent => 'Gib den gesendeten Code ein';

  @override
  String get authVerifyPhone => 'Telefon bestätigen';

  @override
  String authContinueWithProvider(String provider) {
    return 'Weiter mit $provider';
  }

  @override
  String get updateRequiredTitle => 'GRUP aktualisieren';

  @override
  String get updateRequiredBody =>
      'Diese Version von GRUP wird nicht mehr unterstützt. Aktualisiere die App, um sie weiter zu nutzen.';

  @override
  String get updateRequiredAction => 'Aktualisieren';

  @override
  String get notFoundTitle => 'Seite nicht gefunden';

  @override
  String get notFoundBody =>
      'Dieser Link führt zu nichts in GRUP. Vielleicht ist er falsch geschrieben, oder das Ziel gibt es nicht mehr.';

  @override
  String get notFoundAction => 'Zu deinen Gruppen';

  @override
  String eventComing(int count) {
    return '$count dabei';
  }

  @override
  String eventUsually(int count) {
    return '+$count meistens';
  }

  @override
  String eventOut(int count) {
    return '$count nicht dabei';
  }

  @override
  String eventNoReply(int count) {
    return '$count ohne Antwort';
  }

  @override
  String get noReplyYet => 'Noch keine Antwort';

  @override
  String get previousDay => 'Vorheriger Tag';

  @override
  String get nextDay => 'Nächster Tag';

  @override
  String get noEventsThisDay => 'An diesem Tag gibt es keine Events.';

  @override
  String nextEvent(String event, String date) {
    return 'Nächstes: $event, $date';
  }

  @override
  String get eventNotFound => 'Dieses Event findet an diesem Tag nicht statt.';

  @override
  String get usualAnswer => 'übliche Antwort';

  @override
  String get answerComing => 'dabei';

  @override
  String get answerNotComing => 'nicht dabei';

  @override
  String get answerUsuallyComing => 'meistens dabei';

  @override
  String get answerUsuallyNotComing => 'meistens nicht dabei';

  @override
  String get answerNoReply => 'noch keine Antwort';

  @override
  String get usualAnswerYours => 'Deine übliche Antwort';

  @override
  String usualAnswerFor(String name) {
    return 'Übliche Antwort für $name';
  }

  @override
  String get usualEveryTime => 'Jedes Mal';

  @override
  String get usuallyIn => 'Meistens dabei';

  @override
  String get usuallyOut => 'Meistens nicht dabei';

  @override
  String usuallyInWhen(String when) {
    return 'Meistens dabei · $when';
  }

  @override
  String usuallyOutWhen(String when) {
    return 'Meistens nicht dabei · $when';
  }

  @override
  String get setUsualAnswer => 'Übliche Antwort festlegen';

  @override
  String get usualAnswerSaved => 'Übliche Antwort gespeichert';

  @override
  String get usualAnswerRemoved => 'Übliche Antwort entfernt';

  @override
  String get undo => 'Rückgängig';

  @override
  String markedComing(String name) {
    return '$name als dabei markiert';
  }

  @override
  String markedNotComing(String name) {
    return '$name als nicht dabei markiert';
  }

  @override
  String answerCleared(String name) {
    return 'Antwort von $name gelöscht';
  }

  @override
  String get onboardingWelcome => 'Willkommen bei <title>GRUP</title>';

  @override
  String get onboardingTagline => 'Wissen, wer dabei ist, ohne herumzufragen.';

  @override
  String get onboardingExampleEvent => 'Fußball am Dienstag';

  @override
  String get onboardingExampleCaption =>
      'Jedes Event zeigt dir, wer dabei ist. Übliche Antworten zählen getrennt, bis jemand bestätigt.';

  @override
  String get onboardingStepGroup => 'Gruppe starten';

  @override
  String get onboardingStepGroupHint =>
      'Für die Leute, mit denen du dich triffst: ein Team, ein Verein, Freunde oder Familie.';

  @override
  String get onboardingStepEvent => 'Events hinzufügen';

  @override
  String get onboardingStepEventHint =>
      'Lass eins wiederholen, wenn ihr euch jede Woche trefft.';

  @override
  String get onboardingStepInvite => 'Deine Leute einladen';

  @override
  String get onboardingStepInviteHint =>
      'Sie antworten mit einem Tipp oder legen einmal ihre übliche Antwort fest.';

  @override
  String get onboardingJoin => 'Mit Einladungscode beitreten';

  @override
  String get groupSetupTitle => 'Bring deine Gruppe in Gang';

  @override
  String get groupSetupBody =>
      'Hier erscheinen ihre Events, jeweils mit allen, die dabei sind.';

  @override
  String get groupSetupEvent => 'Erstes Event hinzufügen';

  @override
  String get profileNameHelper =>
      'Deine Gruppen sehen diesen Namen neben deinen Antworten.';

  @override
  String get signUpCheckEmail =>
      'Fast geschafft: Öffne den Link in der E-Mail, die wir dir geschickt haben, um die Registrierung abzuschließen.';

  @override
  String get analyticsTitle => 'Hilf uns, nicht mehr zu raten';

  @override
  String get analyticsBody =>
      'Teile, welche Funktionen du nutzt, und wir bauen, was zählt. Wir zählen Fingertipps, keine Geheimnisse. Niemals Werbung.';

  @override
  String get analyticsYes => 'Bin dabei';

  @override
  String get analyticsNo => 'Ich passe';

  @override
  String get analyticsSetting => 'Hilf, GRUP zu verbessern';

  @override
  String get analyticsSettingSubtitle =>
      'Wir zählen Fingertipps, keine Geheimnisse.';

  @override
  String get errorGroupFull => 'Alle Plätze in dieser Gruppe sind belegt.';

  @override
  String get errorFeatureLocked => 'Der Plan dieser Gruppe enthält das nicht.';

  @override
  String get errorReplyLocked =>
      'Änderungen für dieses Event sind geschlossen. Frag einen Admin.';

  @override
  String get inviteCreateCode => 'Einladungscode erstellen';

  @override
  String guestNoInvite(String name) {
    return '$name hat keine Einladung: Admins antworten stellvertretend.';
  }

  @override
  String get inviteCancel => 'Einladungen zurückziehen';

  @override
  String get inviteCancelHint =>
      'Bleibt in der Gruppe, Admins antworten stellvertretend, und gibt einen Platz frei.';
}
