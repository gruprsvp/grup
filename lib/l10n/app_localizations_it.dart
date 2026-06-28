// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'GRUP';

  @override
  String get addContact => 'Aggiungi contatto';

  @override
  String get addInvite => 'Aggiungi invito';

  @override
  String get camera => 'Fotocamera';

  @override
  String get cancel => 'Annulla';

  @override
  String get changeTheme => 'Tema';

  @override
  String get chooseNewProfilePicture => 'Scegli una nuova foto per il profilo';

  @override
  String get confirm => 'Conferma';

  @override
  String get contactEmail => 'Email';

  @override
  String get contactName => 'Nome';

  @override
  String get contactPhone => 'Telefono';

  @override
  String get contacts => 'Contatti';

  @override
  String get contactNew => 'Nuovo contatto';

  @override
  String get contactsPermission => 'Permesso per i contatti';

  @override
  String get contactsPermissionMessage =>
      'Per invitare i tuoi amici ai gruppi, devi darci accesso ai tuoi contatti';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get copy => 'Copia';

  @override
  String get create => 'Crea';

  @override
  String get createNewEvent => 'Crea un nuovo evento';

  @override
  String get createNewGroup => 'Crea un nuovo gruppo';

  @override
  String get createOrJoinGroup => 'Crea o unisciti a un gruppo';

  @override
  String get defaultRules => 'Risposte predefinite';

  @override
  String get defaultRulesDescription =>
      'Scegli una risposta predefinita per questo evento';

  @override
  String get defaultRulesDaily => 'Giornaliero';

  @override
  String get defaultRulesExplanation =>
      'Le risposte predefinite ti permettono di impostare risposte automatiche per eventi ricorrenti. Puoi scegliere tra opzioni giornaliere, nei giorni feriali o nei fine settimana.';

  @override
  String get defaultRulesWeekdays => 'Giorni feriali';

  @override
  String get defaultRulesWeekends => 'Fine settimana';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteGroup => 'Elimina gruppo';

  @override
  String get deleteGroupConfirmation =>
      'Sei sicuro di voler eliminare questo gruppo?';

  @override
  String get deleteProfile => 'Elimina il profilo';

  @override
  String get deleteProfileConfirmation =>
      'Sei sicuro di voler eliminare il tuo profilo?';

  @override
  String get deleteSchedule => 'Elimina evento';

  @override
  String get deleteScheduleConfirmation =>
      'Sei sicuro di voler eliminare questo evento?';

  @override
  String get details => 'Dettagli';

  @override
  String get enterGroupDescription =>
      'Puoi inserire una descrizione del gruppo se vuoi';

  @override
  String get enterGroupName => 'Inserisci il nome del gruppo';

  @override
  String get enterGroupNamePlease => 'Abbiamo bisogno di un nome per il gruppo';

  @override
  String get enterInviteCode => 'Inserisci il codice di invito';

  @override
  String get enterInviteCodePlease => 'Abbiamo bisogno di un codice di invito';

  @override
  String get enterYourName => 'Inserisci il tuo nome';

  @override
  String get enterYourNamePlease => 'Abbiamo bisogno di un nome';

  @override
  String get eventDatetime => 'Data e ora dell\'evento';

  @override
  String get eventName => 'Nome dell\'evento';

  @override
  String get events => 'Eventi';

  @override
  String get eventsEmpty =>
      'È il momento di dare vita al tuo gruppo!<br/>Tocca il pulsante <newevent/> per pianificare la tua prima attività.<br/>Scegli una data, imposta un orario e aggiungi dettagli per far sì che tutti siano entusiasti di riunirsi.';

  @override
  String feedbackEmailCantSend(Object email) {
    return 'Impossibile aprire e-mail. Puoi scriverci a $email';
  }

  @override
  String get feedbackEmailSubject => 'Feedback per GRUP';

  @override
  String get feedbackEmailBody =>
      'Ciao team GRUP,\n\nHo un feedback per voi:\n\n';

  @override
  String get feedbackPromptTitle => 'Come stiamo andando?';

  @override
  String get feedbackPromptBody =>
      'Se ti piace <title>GRUP</title>, lasciaci una recensione positiva per raggiungere più persone!\nSe hai qualche feedback, faccelo sapere così possiamo migliorare.';

  @override
  String feedbackStoreReview(Object store) {
    return 'Valutaci su $store';
  }

  @override
  String get feedbackTellUs => 'Inviaci un messaggio';

  @override
  String get gallery => 'Galleria';

  @override
  String get groupDismissAdmin => 'Rimuovi come amministratore';

  @override
  String get groupDismissAdminConfirmation =>
      'Sei sicuro di voler rimuovere questo membro come amministratore?';

  @override
  String get groupEmptyEventsAdmin =>
      'Il tuo calendario eventi è vuoto.<br/>Pronto a pianificare qualcosa di emozionante? Tocca il pulsante <manage/> per creare un nuovo evento e invitare i membri del gruppo!';

  @override
  String get groupEmptyEventsUser =>
      'Non ci sono eventi per questo giorno specifico, controlla un\'altra data!';

  @override
  String get groupLeave => 'Lascia il gruppo';

  @override
  String get groupLeaveConfirmation =>
      'Sei sicuro di voler lasciare questo gruppo? Perderai l\'accesso a tutti gli eventi e ai membri del gruppo.';

  @override
  String get groupMakeAdmin => 'Rendi amministratore del gruppo';

  @override
  String get groupMakeAdminConfirmation =>
      'Sei sicuro di voler rendere questo membro amministratore?';

  @override
  String get groupManage => 'Gestisci gruppo';

  @override
  String get grantPermission => 'Dai il permesso';

  @override
  String get groupRemoveMember => 'Rimuovi dal gruppo';

  @override
  String get groupRemoveConfirmation =>
      'Sei sicuro di voler rimuovere questo membro dal gruppo?';

  @override
  String groupRoles(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Admin',
      'member': 'Membro',
      'other': 'Sconosciuto',
    });
    return '$_temp0';
  }

  @override
  String get guest => 'Ospite';

  @override
  String get invite => 'Invita la gente';

  @override
  String inviteCodeExplanation(String user) {
    return 'Condividi questo codice con $user per invitarlo nel gruppo';
  }

  @override
  String inviteMessage(String code, String link) {
    return 'Ehi, unisciti al mio gruppo su GRUP! Usa questo codice $code o clicca qui: $link';
  }

  @override
  String get invites => 'Inviti';

  @override
  String get invitesEmpty =>
      'Non hai ancora inviti.<br/>Tocca il pulsante <invite/> per iniziare a invitare i tuoi amici a unirsi al gruppo.';

  @override
  String get inviteFromContacts => 'Invita dai tuoi contatti';

  @override
  String get inviteManual => 'Invita manualmente';

  @override
  String get inviteMembersCTA => 'Invita qualche amico!';

  @override
  String get join => 'Unisciti';

  @override
  String get joinGroup => 'Unisciti al gruppo';

  @override
  String get language => 'Lingua';

  @override
  String get loading => 'Caricamento...';

  @override
  String get members => 'Membri';

  @override
  String get newGroup => 'Nuovo gruppo';

  @override
  String get no => 'No';

  @override
  String get onboardingMessage =>
      'Benvenuto in <title>GRUP</title>!<br/>Non hai ancora creato gruppi. Inizia toccando il pulsante <plus/> per creare il tuo primo gruppo e inizia a organizzare eventi con amici, familiari o colleghi.';

  @override
  String get profile => 'Profilo';

  @override
  String get recurrenceRule => 'Ricorrenza';

  @override
  String get save => 'Salva';

  @override
  String get selectContacts => 'Seleziona i contatti';

  @override
  String get settings => 'Impostazioni';

  @override
  String get settingsMoreInfo => 'Altre informazioni';

  @override
  String get signOut => 'Esci';

  @override
  String get signOutConfirmation => 'Sei sicuro di voler uscire?';

  @override
  String get systemLanguage => 'Lingua del sistema';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get yes => 'Sì';

  @override
  String get you => 'Tu';
}
