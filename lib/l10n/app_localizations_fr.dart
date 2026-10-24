// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'GRUP';

  @override
  String get addContact => 'Ajoute un contact';

  @override
  String get addInvite => 'Ajoute une invitation';

  @override
  String get camera => 'Caméra';

  @override
  String get cancel => 'Annule';

  @override
  String get changeTheme => 'Thème';

  @override
  String get chooseNewProfilePicture => 'Choisis une nouvelle photo de profil';

  @override
  String get confirm => 'Confirme';

  @override
  String get contactEmail => 'Email';

  @override
  String get contactName => 'Nom';

  @override
  String get contactPhone => 'Téléphone';

  @override
  String get contacts => 'Contacts';

  @override
  String get contactNew => 'Nouveau contact';

  @override
  String get contactsPermission => 'Permission pour les contacts';

  @override
  String get contactsPermissionMessage =>
      'Pour inviter tes amis à des groupes, tu dois nous donner accès à tes contacts';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get copy => 'Copie';

  @override
  String get create => 'Crée';

  @override
  String get createNewEvent => 'Crée un nouvel événement';

  @override
  String get createNewGroup => 'Crée un nouveau groupe';

  @override
  String get createOrJoinGroup => 'Crée ou rejoins un groupe';

  @override
  String get defaultRulesExplanation =>
      'Ta réponse habituelle s\'applique à chaque occurrence concernée : tu es compté sans répondre à chaque fois. Tu peux toujours changer un jour précis.';

  @override
  String get defaultRulesWeekdays => 'Jours de semaine';

  @override
  String get defaultRulesWeekends => 'Week-ends';

  @override
  String get delete => 'Supprime';

  @override
  String get deleteGroup => 'Supprime le groupe';

  @override
  String get deleteGroupConfirmation =>
      'Es-tu sûr de vouloir supprimer ce groupe?';

  @override
  String get deleteProfile => 'Supprime le profil';

  @override
  String get deleteProfileConfirmation =>
      'Es-tu sûr de vouloir supprimer ton profil?';

  @override
  String get deleteSchedule => 'Supprime l\'événement';

  @override
  String get deleteScheduleConfirmation =>
      'Es-tu sûr de vouloir supprimer cet événement?';

  @override
  String get details => 'Détails';

  @override
  String get enterGroupDescription =>
      'Tu peux entrer une description de groupe si tu veux';

  @override
  String get enterGroupName => 'Entre un nom de groupe';

  @override
  String get enterGroupNamePlease => 'On a besoin d\'un nom pour le groupe';

  @override
  String get enterInviteCode => 'Entre un code d\'invitation';

  @override
  String get enterInviteCodePlease => 'On a besoin d\'un code d\'invitation';

  @override
  String get enterYourName => 'Entre ton nom';

  @override
  String get enterYourNamePlease => 'On a besoin d\'un nom';

  @override
  String get eventDatetime => 'Date et heure de l\'événement';

  @override
  String get eventName => 'Nom de l\'événement';

  @override
  String get events => 'Événements';

  @override
  String get eventsEmpty =>
      'Il est temps de donner vie à ton groupe!<br/>Appuie sur le bouton <newevent/> pour planifier ta première activité.<br/>Choisis une date, définis une heure et ajoute des détails pour que tout le monde soit excité de se retrouver.';

  @override
  String feedbackEmailCantSend(Object email) {
    return 'Impossible d\'ouvrir un client de messagerie. Tu peux nous envoyer un e-mail à $email';
  }

  @override
  String get feedbackEmailSubject => 'Feedback pour GRUP';

  @override
  String get feedbackEmailBody =>
      'Salut équipe GRUP,\n\nJ\'ai des commentaires pour vous:\n\n';

  @override
  String get feedbackPromptTitle => 'Comment nous débrouillons-nous?';

  @override
  String get feedbackPromptBody =>
      'Si tu aimes <title>GRUP</title>, laisse-nous un avis positif pour toucher plus de personnes!\nSi tu as des commentaires, fais-le nous savoir pour que nous puissions nous améliorer.';

  @override
  String feedbackStoreReview(Object store) {
    return 'Évalue-nous sur $store';
  }

  @override
  String get feedbackTellUs => 'Envoie-nous un message';

  @override
  String get gallery => 'Galerie';

  @override
  String get groupDismissAdmin => 'Révoque l\'admin';

  @override
  String get groupDismissAdminConfirmation =>
      'Es-tu sûr de vouloir révoquer ce membre comme admin?';

  @override
  String get groupEmptyEventsUser =>
      'Ce groupe n\'a pas encore d\'événements.<br/>Quand un admin en ajoute un, il s\'affiche ici et tu réponds d\'un geste.';

  @override
  String get groupLeave => 'Quitte le groupe';

  @override
  String get groupLeaveConfirmation =>
      'Es-tu sûr de vouloir quitter ce groupe? Tu perdras l\'accès à tous les événements et membres du groupe.';

  @override
  String get groupMakeAdmin => 'Rend admin du groupe';

  @override
  String get groupMakeAdminConfirmation =>
      'Es-tu sûr de vouloir rendre ce membre admin?';

  @override
  String get groupManage => 'Gérer le groupe';

  @override
  String get grantPermission => 'Donne la permission';

  @override
  String get groupRemoveMember => 'Retire du groupe';

  @override
  String get groupRemoveConfirmation =>
      'Es-tu sûr de vouloir retirer ce membre du groupe?';

  @override
  String groupRoles(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Admin',
      'member': 'Membre',
      'other': 'Inconnu',
    });
    return '$_temp0';
  }

  @override
  String get guest => 'Invité';

  @override
  String get invite => 'Invite des gens';

  @override
  String inviteCodeExplanation(String user) {
    return 'Partage ce code avec $user pour l\'inviter dans le groupe';
  }

  @override
  String inviteMessage(String code, String link) {
    return 'Hey, rejoins mon groupe sur GRUP! Utilise ce code $code ou clique ici: $link';
  }

  @override
  String get invites => 'Invitations';

  @override
  String get invitesEmpty =>
      'Il est temps d\'inviter tes amis à rejoindre tes groupes!<br/>Appuie sur le bouton <invite/> pour inviter tes amis à rejoindre tes groupes et commencer à organiser des événements ensemble.';

  @override
  String get inviteFromContacts => 'Invite depuis tes contacts';

  @override
  String get inviteManual => 'Invite manuellement';

  @override
  String get inviteMembersCTA => 'Invite quelques amis!';

  @override
  String get join => 'Rejoins';

  @override
  String get joinGroup => 'Rejoins un groupe';

  @override
  String get language => 'Langue';

  @override
  String get loading => 'Chargement...';

  @override
  String get members => 'Membres';

  @override
  String get newGroup => 'Nouveau groupe';

  @override
  String get no => 'Non';

  @override
  String get profile => 'Profil';

  @override
  String get recurrenceRule => 'Récurrence';

  @override
  String get save => 'Sauvegarde';

  @override
  String get selectContacts => 'Choisis des contacts';

  @override
  String get settings => 'Paramètres';

  @override
  String get settingsMoreInfo => 'Plus d\'infos';

  @override
  String get signOut => 'Déconnecte-toi';

  @override
  String get signOutConfirmation => 'Tu es sûr de vouloir te déconnecter?';

  @override
  String get systemLanguage => 'Langue du système';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeSystem => 'Système';

  @override
  String get unknown => 'Inconnu';

  @override
  String get yes => 'Oui';

  @override
  String get you => 'Toi';

  @override
  String get errorNetwork =>
      'Impossible de joindre GRUP. Vérifie ta connexion et réessaie.';

  @override
  String get errorNotFound =>
      'Ce n\'est plus disponible. Il a peut-être été supprimé, ou tu n\'y as plus accès.';

  @override
  String get errorNotAllowed => 'Tu n\'as pas le droit de faire ça.';

  @override
  String get errorInvalidInviteCode =>
      'Ce code d\'invitation n\'est pas valide. Vérifie-le et réessaie.';

  @override
  String get errorAlreadyMember => 'Tu es déjà membre de ce groupe.';

  @override
  String get errorNotSignedIn => 'Tu es déconnecté. Connecte-toi et réessaie.';

  @override
  String get errorGeneric => 'Une erreur s\'est produite. Réessaie.';

  @override
  String get retry => 'Réessayer';

  @override
  String get joiningGroup => 'Tu rejoins le groupe…';

  @override
  String get joinedGroup => 'Tu as rejoint le groupe !';

  @override
  String get goToGroups => 'Aller à tes groupes';

  @override
  String get licenses => 'Licences';

  @override
  String get recurrenceOnce => 'Une fois';

  @override
  String get recurrenceDaily => 'Tous les jours';

  @override
  String get recurrenceWeekly => 'Toutes les semaines';

  @override
  String get recurrenceMonthly => 'Tous les mois';

  @override
  String get recurrenceYearly => 'Tous les ans';

  @override
  String get recurrenceWeekdays => 'En semaine';

  @override
  String get recurrenceWeekends => 'Le week-end';

  @override
  String get recurrenceCustom => 'Personnalisée';

  @override
  String get authEnterEmail => 'Saisis ton adresse e-mail';

  @override
  String get authValidEmailError => 'Saisis une adresse e-mail valide';

  @override
  String get authEnterPassword => 'Saisis ton mot de passe';

  @override
  String get authPasswordLengthError =>
      'Saisis un mot de passe d\'au moins 6 caractères';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authSignUp => 'S\'inscrire';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authDontHaveAccount => 'Pas encore de compte ? Inscris-toi';

  @override
  String get authHaveAccount => 'Déjà un compte ? Connecte-toi';

  @override
  String get authSendPasswordReset => 'Envoyer l\'e-mail de réinitialisation';

  @override
  String get authPasswordResetSent =>
      'L\'e-mail de réinitialisation a été envoyé';

  @override
  String get authBackToSignIn => 'Retour à la connexion';

  @override
  String get authUnexpectedError => 'Une erreur inattendue s\'est produite';

  @override
  String get authRequiredFieldError => 'Ce champ est obligatoire';

  @override
  String get authConfirmPasswordError =>
      'Les mots de passe ne correspondent pas';

  @override
  String get authConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authEnterOtpCode => 'Saisis le code de vérification';

  @override
  String get authEnterNewPassword => 'Saisis un nouveau mot de passe';

  @override
  String get authChangePassword => 'Changer le mot de passe';

  @override
  String get authPasswordChangedSuccess => 'Mot de passe mis à jour';

  @override
  String get authOtpCodeError => 'Code de vérification invalide';

  @override
  String get authOtpDisabledError =>
      'Les codes de vérification sont désactivés';

  @override
  String get authEnterPhoneNumber => 'Saisis ton numéro de téléphone';

  @override
  String get authValidPhoneNumberError =>
      'Saisis un numéro de téléphone valide';

  @override
  String get authContinueWithMagicLink => 'Continuer avec un lien magique';

  @override
  String get authCheckYourEmail => 'Consulte ta boîte mail !';

  @override
  String get authSuccessSignInMessage => 'Connexion réussie !';

  @override
  String get authUpdatePassword => 'Mettre à jour le mot de passe';

  @override
  String get authEnterOneTimeCode => 'Saisis le code à usage unique envoyé';

  @override
  String get authEnterCodeSent => 'Saisis le code envoyé';

  @override
  String get authVerifyPhone => 'Vérifier le téléphone';

  @override
  String authContinueWithProvider(String provider) {
    return 'Continuer avec $provider';
  }

  @override
  String get updateRequiredTitle => 'Mets à jour GRUP';

  @override
  String get updateRequiredBody =>
      'Cette version de GRUP n\'est plus prise en charge. Mets à jour l\'appli pour continuer à l\'utiliser.';

  @override
  String get updateRequiredAction => 'Mettre à jour';

  @override
  String get notFoundTitle => 'Page introuvable';

  @override
  String get notFoundBody =>
      'Ce lien ne mène à rien dans GRUP. Il est peut-être mal saisi, ou ce vers quoi il pointait n\'existe plus.';

  @override
  String get notFoundAction => 'Aller à tes groupes';

  @override
  String eventComing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count présents',
      one: '1 présent',
    );
    return '$_temp0';
  }

  @override
  String eventUsually(int count) {
    return '+$count d\'habitude';
  }

  @override
  String eventOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count absents',
      one: '1 absent',
    );
    return '$_temp0';
  }

  @override
  String eventNoReply(int count) {
    return '$count sans réponse';
  }

  @override
  String get noReplyYet => 'Pas encore de réponse';

  @override
  String get previousDay => 'Jour précédent';

  @override
  String get nextDay => 'Jour suivant';

  @override
  String get noEventsThisDay => 'Aucun événement ce jour-là.';

  @override
  String nextEvent(String event, String date) {
    return 'Prochain : $event, $date';
  }

  @override
  String get eventNotFound => 'Cet événement n\'a pas lieu ce jour-là.';

  @override
  String get usualAnswer => 'réponse habituelle';

  @override
  String get answerComing => 'présent';

  @override
  String get answerNotComing => 'absent';

  @override
  String get answerUsuallyComing => 'présent d\'habitude';

  @override
  String get answerUsuallyNotComing => 'absent d\'habitude';

  @override
  String get answerNoReply => 'pas encore de réponse';

  @override
  String get usualAnswerYours => 'Ta réponse habituelle';

  @override
  String usualAnswerFor(String name) {
    return 'Réponse habituelle de $name';
  }

  @override
  String get usualEveryTime => 'À chaque fois';

  @override
  String get usuallyIn => 'Présent d\'habitude';

  @override
  String get usuallyOut => 'Absent d\'habitude';

  @override
  String usuallyInWhen(String when) {
    return 'Présent d\'habitude · $when';
  }

  @override
  String usuallyOutWhen(String when) {
    return 'Absent d\'habitude · $when';
  }

  @override
  String get setUsualAnswer => 'Choisis ta réponse habituelle';

  @override
  String get usualAnswerSaved => 'Réponse habituelle enregistrée';

  @override
  String get usualAnswerRemoved => 'Réponse habituelle supprimée';

  @override
  String get undo => 'Annuler';

  @override
  String markedComing(String name) {
    return '$name noté présent';
  }

  @override
  String markedNotComing(String name) {
    return '$name noté absent';
  }

  @override
  String answerCleared(String name) {
    return 'Réponse de $name effacée';
  }

  @override
  String get onboardingWelcome => 'Bienvenue sur <title>GRUP</title>';

  @override
  String get onboardingTagline => 'Sache qui vient, sans avoir à demander.';

  @override
  String get onboardingExampleEvent => 'Foot du mardi';

  @override
  String get onboardingExampleCaption =>
      'Chaque événement te montre qui vient. Les réponses habituelles comptent à part jusqu\'à confirmation.';

  @override
  String get onboardingStepGroup => 'Crée un groupe';

  @override
  String get onboardingStepGroupHint =>
      'Pour les gens que tu retrouves : une équipe, un club, des amis ou la famille.';

  @override
  String get onboardingStepEvent => 'Ajoute ses événements';

  @override
  String get onboardingStepEventHint =>
      'Fais-en répéter un si vous vous voyez chaque semaine.';

  @override
  String get onboardingStepInvite => 'Invite tes proches';

  @override
  String get onboardingStepInviteHint =>
      'Ils répondent d\'un geste, ou choisissent une fois leur réponse habituelle.';

  @override
  String get onboardingJoin => 'Rejoindre avec un code d\'invitation';

  @override
  String get groupSetupTitle => 'Lance ton groupe';

  @override
  String get groupSetupBody =>
      'Ses événements s\'affichent ici, avec qui vient à chacun.';

  @override
  String get groupSetupEvent => 'Ajoute le premier événement';

  @override
  String get profileNameHelper =>
      'Tes groupes voient ce nom à côté de tes réponses.';
}
