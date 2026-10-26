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
  String get defaultRulesExplanation =>
      'La tua risposta abituale vale per ogni evento che copre, così vieni contato senza rispondere ogni volta. Puoi comunque cambiare un singolo giorno.';

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
  String get groupEmptyEventsUser =>
      'Questo gruppo non ha ancora eventi.<br/>Quando un admin ne aggiunge uno, compare qui e rispondi con un tocco.';

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

  @override
  String get errorNetwork =>
      'Impossibile raggiungere GRUP. Controlla la connessione e riprova.';

  @override
  String get errorNotFound =>
      'Non è più disponibile. Potrebbe essere stato eliminato, o non hai più accesso.';

  @override
  String get errorNotAllowed => 'Non hai il permesso di farlo.';

  @override
  String get errorInvalidInviteCode =>
      'Questo codice di invito non è valido. Controllalo e riprova.';

  @override
  String get errorAlreadyMember => 'Sei già membro di questo gruppo.';

  @override
  String get errorNotSignedIn => 'Sei uscito. Accedi e riprova.';

  @override
  String get errorGeneric => 'Qualcosa è andato storto. Riprova.';

  @override
  String get retry => 'Riprova';

  @override
  String get joiningGroup => 'Ti stai unendo al gruppo…';

  @override
  String get joinedGroup => 'Ti sei unito al gruppo!';

  @override
  String get goToGroups => 'Vai ai tuoi gruppi';

  @override
  String get licenses => 'Licenze';

  @override
  String get recurrenceOnce => 'Una volta';

  @override
  String get recurrenceDaily => 'Ogni giorno';

  @override
  String get recurrenceWeekly => 'Ogni settimana';

  @override
  String get recurrenceMonthly => 'Ogni mese';

  @override
  String get recurrenceYearly => 'Ogni anno';

  @override
  String get recurrenceWeekdays => 'Nei giorni feriali';

  @override
  String get recurrenceWeekends => 'Nel fine settimana';

  @override
  String get recurrenceCustom => 'Personalizzata';

  @override
  String get authEnterEmail => 'Inserisci la tua email';

  @override
  String get authValidEmailError => 'Inserisci un indirizzo email valido';

  @override
  String get authEnterPassword => 'Inserisci la tua password';

  @override
  String get authPasswordLengthError =>
      'Inserisci una password di almeno 6 caratteri';

  @override
  String get authSignIn => 'Accedi';

  @override
  String get authSignUp => 'Registrati';

  @override
  String get authForgotPassword => 'Password dimenticata?';

  @override
  String get authDontHaveAccount => 'Non hai un account? Registrati';

  @override
  String get authHaveAccount => 'Hai già un account? Accedi';

  @override
  String get authSendPasswordReset =>
      'Invia l\'email per reimpostare la password';

  @override
  String get authPasswordResetSent =>
      'Ti abbiamo inviato l\'email per reimpostare la password';

  @override
  String get authBackToSignIn => 'Torna all\'accesso';

  @override
  String get authUnexpectedError => 'Si è verificato un errore imprevisto';

  @override
  String get authRequiredFieldError => 'Questo campo è obbligatorio';

  @override
  String get authConfirmPasswordError => 'Le password non corrispondono';

  @override
  String get authConfirmPassword => 'Conferma password';

  @override
  String get authEnterOtpCode => 'Inserisci il codice di verifica';

  @override
  String get authEnterNewPassword => 'Inserisci una nuova password';

  @override
  String get authChangePassword => 'Cambia password';

  @override
  String get authPasswordChangedSuccess => 'Password aggiornata';

  @override
  String get authOtpCodeError => 'Codice di verifica non valido';

  @override
  String get authOtpDisabledError => 'I codici di verifica sono disattivati';

  @override
  String get authEnterPhoneNumber => 'Inserisci il tuo numero di telefono';

  @override
  String get authValidPhoneNumberError =>
      'Inserisci un numero di telefono valido';

  @override
  String get authContinueWithMagicLink => 'Continua con link magico';

  @override
  String get authCheckYourEmail => 'Controlla la tua casella email!';

  @override
  String get authSuccessSignInMessage => 'Accesso effettuato!';

  @override
  String get authUpdatePassword => 'Aggiorna password';

  @override
  String get authEnterOneTimeCode =>
      'Inserisci il codice monouso che ti abbiamo inviato';

  @override
  String get authEnterCodeSent => 'Inserisci il codice inviato';

  @override
  String get authVerifyPhone => 'Verifica telefono';

  @override
  String authContinueWithProvider(String provider) {
    return 'Continua con $provider';
  }

  @override
  String get updateRequiredTitle => 'Aggiorna GRUP';

  @override
  String get updateRequiredBody =>
      'Questa versione di GRUP non è più supportata. Aggiorna l\'app per continuare a usarla.';

  @override
  String get updateRequiredAction => 'Aggiorna';

  @override
  String get notFoundTitle => 'Pagina non trovata';

  @override
  String get notFoundBody =>
      'Questo link non porta a nulla in GRUP. Forse è scritto male, o ciò a cui puntava non esiste più.';

  @override
  String get notFoundAction => 'Vai ai tuoi gruppi';

  @override
  String eventComing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count presenti',
      one: '1 presente',
    );
    return '$_temp0';
  }

  @override
  String eventUsually(int count) {
    return '+$count di solito';
  }

  @override
  String eventOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assenti',
      one: '1 assente',
    );
    return '$_temp0';
  }

  @override
  String eventNoReply(int count) {
    return '$count senza risposta';
  }

  @override
  String get noReplyYet => 'Nessuna risposta';

  @override
  String get previousDay => 'Giorno precedente';

  @override
  String get nextDay => 'Giorno successivo';

  @override
  String get noEventsThisDay => 'Nessun evento in questo giorno.';

  @override
  String nextEvent(String event, String date) {
    return 'Prossimo: $event, $date';
  }

  @override
  String get eventNotFound => 'Questo evento non c\'è in questo giorno.';

  @override
  String get usualAnswer => 'risposta abituale';

  @override
  String get answerComing => 'presente';

  @override
  String get answerNotComing => 'assente';

  @override
  String get answerUsuallyComing => 'di solito presente';

  @override
  String get answerUsuallyNotComing => 'di solito assente';

  @override
  String get answerNoReply => 'nessuna risposta';

  @override
  String get usualAnswerYours => 'La tua risposta abituale';

  @override
  String usualAnswerFor(String name) {
    return 'Risposta abituale di $name';
  }

  @override
  String get usualEveryTime => 'Ogni volta';

  @override
  String get usuallyIn => 'Di solito presente';

  @override
  String get usuallyOut => 'Di solito assente';

  @override
  String usuallyInWhen(String when) {
    return 'Di solito presente · $when';
  }

  @override
  String usuallyOutWhen(String when) {
    return 'Di solito assente · $when';
  }

  @override
  String get setUsualAnswer => 'Imposta la tua risposta abituale';

  @override
  String get usualAnswerSaved => 'Risposta abituale salvata';

  @override
  String get usualAnswerRemoved => 'Risposta abituale rimossa';

  @override
  String get undo => 'Annulla';

  @override
  String markedComing(String name) {
    return '$name segnato come presente';
  }

  @override
  String markedNotComing(String name) {
    return '$name segnato come assente';
  }

  @override
  String answerCleared(String name) {
    return 'Risposta di $name cancellata';
  }

  @override
  String get onboardingWelcome => 'Benvenuto in <title>GRUP</title>';

  @override
  String get onboardingTagline => 'Sai chi viene, senza chiedere in giro.';

  @override
  String get onboardingExampleEvent => 'Calcetto del martedì';

  @override
  String get onboardingExampleCaption =>
      'Ogni evento ti mostra chi viene. Le risposte abituali contano a parte finché non confermano.';

  @override
  String get onboardingStepGroup => 'Crea un gruppo';

  @override
  String get onboardingStepGroupHint =>
      'Per le persone con cui ti vedi: una squadra, un club, amici o famiglia.';

  @override
  String get onboardingStepEvent => 'Aggiungi i suoi eventi';

  @override
  String get onboardingStepEventHint =>
      'Fallo ripetere se vi vedete ogni settimana.';

  @override
  String get onboardingStepInvite => 'Invita la tua gente';

  @override
  String get onboardingStepInviteHint =>
      'Rispondono con un tocco, o scelgono una volta la loro risposta abituale.';

  @override
  String get onboardingJoin => 'Unisciti con un codice invito';

  @override
  String get groupSetupTitle => 'Fai partire il tuo gruppo';

  @override
  String get groupSetupBody =>
      'Qui compaiono i suoi eventi, con chi viene a ciascuno.';

  @override
  String get groupSetupEvent => 'Aggiungi il primo evento';

  @override
  String get profileNameHelper =>
      'I tuoi gruppi vedono questo nome accanto alle tue risposte.';

  @override
  String get signUpCheckEmail =>
      'Ci siamo quasi: apri il link nell’email che ti abbiamo inviato per completare la registrazione.';

  @override
  String get analyticsTitle => 'Aiutaci a non tirare a indovinare';

  @override
  String get analyticsBody =>
      'Condividi quali funzioni usi e costruiremo ciò che conta. Contiamo i tocchi, non i segreti. Niente pubblicità, mai.';

  @override
  String get analyticsYes => 'Ci sto';

  @override
  String get analyticsNo => 'Passo';

  @override
  String get analyticsSetting => 'Aiutaci a migliorare GRUP';

  @override
  String get analyticsSettingSubtitle => 'Contiamo i tocchi, non i segreti.';

  @override
  String get errorGroupFull => 'Tutti i posti di questo gruppo sono occupati.';

  @override
  String get errorFeatureLocked => 'Il piano di questo gruppo non lo include.';

  @override
  String get errorReplyLocked =>
      'Le modifiche per questo evento sono chiuse. Chiedi a un admin.';

  @override
  String get cutoffLabel => 'Chiusura modifiche';

  @override
  String get cutoffNone => 'Nessuna scadenza';

  @override
  String cutoffHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ore prima',
      one: '1 ora prima',
      zero: 'All\'inizio',
    );
    return '$_temp0';
  }

  @override
  String get cutoffCustom => 'Personalizzato…';

  @override
  String get cutoffCustomTitle => 'Ore prima dell\'inizio';

  @override
  String changesClosedAt(String time) {
    return 'Modifiche chiuse alle $time';
  }

  @override
  String get lateChange => 'Cambiata in ritardo';

  @override
  String get kitchenTitle => 'Vista cucina';

  @override
  String kitchenMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membri',
      one: '1 membro',
    );
    return '$_temp0';
  }

  @override
  String kitchenGuests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ospiti',
      one: '1 ospite',
    );
    return '$_temp0';
  }

  @override
  String get kitchenLate => 'Cambiato in ritardo';

  @override
  String get kitchenPrint => 'Stampa';

  @override
  String get kitchenNobody => 'Ancora nessuno.';

  @override
  String get featureUnavailable => 'Non è disponibile per questo gruppo.';

  @override
  String get exportAnswers => 'Esporta risposte';

  @override
  String get exportTooLong => 'Scegli al massimo un anno.';

  @override
  String cutoffMinutes(int minutes) {
    return '$minutes min prima';
  }

  @override
  String get cutoffCustomInvalid => 'Inserisci da 0 a 168 ore.';

  @override
  String get inviteCreateCode => 'Crea un codice d\'invito';

  @override
  String guestNoInvite(String name) {
    return '$name non ha un invito: rispondono gli admin.';
  }

  @override
  String get inviteCancel => 'Annulla gli inviti';

  @override
  String get inviteCancelHint =>
      'Resta nel gruppo, rispondono gli admin, e libera un posto.';
}
