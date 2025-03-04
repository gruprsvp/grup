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
  String get contactsPermissionMessage => 'Um deine Freunde zu Gruppen einzuladen, musst du uns den Zugriff auf deine Kontakte erlauben';

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
  String get defaultRules => 'Standardantworten';

  @override
  String get defaultRulesDescription => 'Wähle eine Standardantwort für dieses Event';

  @override
  String get defaultRulesDaily => 'Täglich';

  @override
  String get defaultRulesExplanation => 'Standardantworten ermöglichen es dir, automatische Antworten für wiederkehrende Events festzulegen. Du kannst zwischen täglichen, wochentäglichen oder wochenendlichen Optionen wählen.';

  @override
  String get defaultRulesWeekdays => 'Wochentage';

  @override
  String get defaultRulesWeekends => 'Wochenende';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteGroup => 'Gruppe löschen';

  @override
  String get deleteGroupConfirmation => 'Bist du sicher, dass du diese Gruppe löschen möchtest?';

  @override
  String get deleteProfile => 'Profil löschen';

  @override
  String get deleteProfileConfirmation => 'Bist du sicher, dass du dein Profil löschen möchtest?';

  @override
  String get deleteSchedule => 'Event löschen';

  @override
  String get deleteScheduleConfirmation => 'Bist du sicher, dass du dieses Event löschen möchtest?';

  @override
  String get details => 'Einzelheiten';

  @override
  String get enterGroupDescription => 'Du kannst eine optionale Gruppenbeschreibung eingeben';

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
  String get eventsEmpty => 'Es ist Zeit, deiner Gruppe Leben einzuhauchen!<br/>Tippe auf die Schaltfläche <newevent/>, um deine erste Aktivität zu planen.<br/>Wähle ein Datum, setze eine Uhrzeit und füge Details hinzu, um alle begeistert zu machen, zusammenzukommen.';

  @override
  String feedbackEmailCantSend(Object email) {
    return 'Konnte keinen E-Mail-Client öffnen. Du kannst uns eine E-Mail an $email senden';
  }

  @override
  String get feedbackEmailSubject => 'Feedback für GRUP';

  @override
  String get feedbackEmailBody => 'Hallo GRUP-Team,\n\nIch habe ein Feedback für euch:\n\n';

  @override
  String get feedbackPromptTitle => 'Wie machen wir uns?';

  @override
  String get feedbackPromptBody => 'Wenn dir <title>GRUP</title> gefällt, hinterlasse uns bitte eine positive Bewertung, um mehr Menschen zu erreichen!\nWenn du Feedback hast, lass es uns wissen, damit wir uns verbessern können.';

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
  String get groupDismissAdminConfirmation => 'Bist du sicher, dass du dieses Mitglied als Admin entfernen möchtest?';

  @override
  String get groupEmptyEventsAdmin => 'Dein Eventkalender ist leer.<br/>Bereit, etwas Aufregendes zu planen? Tippe auf die Schaltfläche <manage/>, um ein neues Event zu erstellen und die Gruppenmitglieder einzuladen!';

  @override
  String get groupEmptyEventsUser => 'Für diesen speziellen Tag gibt es keine Events, schau an einem anderen Datum nach!';

  @override
  String get groupLeave => 'Gruppe verlassen';

  @override
  String get groupLeaveConfirmation => 'Bist du sicher, dass du diese Gruppe verlassen möchtest? Du wirst den Zugriff auf alle Gruppen-Events und Mitglieder verlieren.';

  @override
  String get groupMakeAdmin => 'Zum Gruppenadmin machen';

  @override
  String get groupMakeAdminConfirmation => 'Bist du sicher, dass du dieses Mitglied zum Admin machen möchtest?';

  @override
  String get groupManage => 'Gruppe verwalten';

  @override
  String get grantPermission => 'Berechtigung erteilen';

  @override
  String get groupRemoveMember => 'Aus Gruppe entfernen';

  @override
  String get groupRemoveConfirmation => 'Bist du sicher, dass du dieses Mitglied aus der Gruppe entfernen möchtest?';

  @override
  String groupRoles(String role) {
    String _temp0 = intl.Intl.selectLogic(
      role,
      {
        'admin': 'Admin',
        'member': 'Mitglied',
        'other': 'Unbekannt',
      },
    );
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
  String get invitesEmpty => 'Es ist Zeit, deine Freunde einzuladen, deinen Gruppen beizutreten!<br/>Tippe auf die Schaltfläche <invite/>, um deine Freunde einzuladen, deinen Gruppen beizutreten und gemeinsam Events zu organisieren.';

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
  String get no => 'Nee';

  @override
  String get onboardingMessage => 'Willkommen bei <title>GRUP</title>!<br/>Du hast noch keine Gruppen erstellt. Beginne, indem du auf die Schaltfläche <plus/> tippst, um deine erste Gruppe zu erstellen und mit Freunden, Familie oder Kollegen Events zu organisieren.';

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
  String get signOutConfirmation => 'Bist du sicher, dass du dich abmelden möchtest?';

  @override
  String get systemLanguage => 'Systemsprache';

  @override
  String get timezone => 'Zeitzone';

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
}
