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
  String get defaultRules => 'Réponses par défaut';

  @override
  String get defaultRulesDescription =>
      'Choisis une réponse par défaut pour cet événement';

  @override
  String get defaultRulesDaily => 'Quotidien';

  @override
  String get defaultRulesExplanation =>
      'Les réponses par défaut te permettent de définir des réponses automatiques pour les événements récurrents. Tu peux choisir entre des options quotidiennes, en semaine ou le week-end.';

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
  String get groupEmptyEventsAdmin =>
      'Ton calendrier d\'événements est vide.<br/>Prêt à planifier quelque chose d\'excitant? Appuie sur le bouton <manage/> pour créer un nouvel événement et inviter les membres du groupe!';

  @override
  String get groupEmptyEventsUser =>
      'Il n\'y a pas d\'événements pour ce jour spécifique, vérifie une autre date!';

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
  String get groupManage => 'Gère le groupe';

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
  String get onboardingMessage =>
      'Bienvenue sur <title>GRUP</title>!<br/>Tu n\'as pas encore créé de groupes. Commence en appuyant sur le bouton <plus/> pour créer ton premier groupe et commence à organiser des événements avec des amis, de la famille ou des collègues.';

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
}
