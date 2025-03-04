// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'GRUP';

  @override
  String get addContact => 'Añade un contacto';

  @override
  String get addInvite => 'Añade una invitación';

  @override
  String get camera => 'Cámara';

  @override
  String get cancel => 'Cancela';

  @override
  String get changeTheme => 'Tema';

  @override
  String get chooseNewProfilePicture => 'Elige una nueva foto de perfil';

  @override
  String get confirm => 'Confirma';

  @override
  String get contactEmail => 'Email';

  @override
  String get contactName => 'Nombre';

  @override
  String get contactPhone => 'Teléfono';

  @override
  String get contacts => 'Contactos';

  @override
  String get contactNew => 'Nuevo contacto';

  @override
  String get contactsPermission => 'Permiso para los contactos';

  @override
  String get contactsPermissionMessage => 'Para invitar a tus amigos a grupos, necesitas darnos acceso a tus contactos';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get copy => 'Copia';

  @override
  String get create => 'Crea';

  @override
  String get createNewEvent => 'Crea un evento nuevo';

  @override
  String get createNewGroup => 'Crea un grupo nuevo';

  @override
  String get createOrJoinGroup => 'Crea o únete a un grupo';

  @override
  String get defaultRules => 'Respuestas predeterminadas';

  @override
  String get defaultRulesDescription => 'Elige una respuesta predeterminada para este evento';

  @override
  String get defaultRulesDaily => 'Diario';

  @override
  String get defaultRulesExplanation => 'Las respuestas predeterminadas te permiten establecer respuestas automáticas para eventos recurrentes. Puedes elegir entre opciones diarias, de días laborables o de fines de semana.';

  @override
  String get defaultRulesWeekdays => 'Días laborables';

  @override
  String get defaultRulesWeekends => 'Fines de semana';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteGroup => 'Eliminar grupo';

  @override
  String get deleteGroupConfirmation => '¿Estás seguro de que quieres eliminar este grupo?';

  @override
  String get deleteProfile => 'Eliminar perfil';

  @override
  String get deleteProfileConfirmation => '¿Estás seguro de que quieres eliminar tu perfil?';

  @override
  String get deleteSchedule => 'Eliminar evento';

  @override
  String get deleteScheduleConfirmation => '¿Estás seguro de que quieres eliminar este evento?';

  @override
  String get details => 'Detalles';

  @override
  String get enterGroupDescription => 'Puedes poner una descripción del grupo si quieres';

  @override
  String get enterGroupName => 'Ponle un nombre al grupo';

  @override
  String get enterGroupNamePlease => 'Necesitamos un nombre para el grupo';

  @override
  String get enterInviteCode => 'Pon el código de invitación';

  @override
  String get enterInviteCodePlease => 'Necesitamos un código de invitación';

  @override
  String get enterYourName => 'Pon tu nombre';

  @override
  String get enterYourNamePlease => 'Necesitamos un nombre';

  @override
  String get eventDatetime => 'Fecha y hora del evento';

  @override
  String get eventName => 'Nombre del evento';

  @override
  String get events => 'Eventos';

  @override
  String get eventsEmpty => '¡Es hora de dar vida a tu grupo!<br/>Toca el botón <newevent/> para programar tu primera actividad.<br/>Elige una fecha, establece una hora y añade detalles para que todos estén emocionados de reunirse.';

  @override
  String feedbackEmailCantSend(Object email) {
    return 'No se pudo abrir un cliente de correo electrónico. Puedes enviarnos un correo electrónico a $email';
  }

  @override
  String get feedbackEmailSubject => 'Feedback para GRUP';

  @override
  String get feedbackEmailBody => 'Hola equipo de GRUP,\n\nTengo algunos comentarios para vosotros:\n\n';

  @override
  String get feedbackPromptTitle => '¿Cómo lo estamos haciendo?';

  @override
  String get feedbackPromptBody => 'Si te gusta <title>GRUP</title>, por favor déjanos una reseña positiva para llegar a más personas.\nSi tienes algún comentario, por favor háznoslo saber para que podamos mejorar.';

  @override
  String feedbackStoreReview(Object store) {
    return 'Déjanos una reseña en $store';
  }

  @override
  String get feedbackTellUs => 'Envíanos un mensaje';

  @override
  String get gallery => 'Galería';

  @override
  String get groupDismissAdmin => 'Descarta como admin';

  @override
  String get groupDismissAdminConfirmation => '¿Seguro que quieres descartar a este miembro como admin?';

  @override
  String get groupEmptyEventsAdmin => 'Tu calendario de eventos está vacío.<br/>¿Listo para planear algo emocionante? Toca el botón <manage/> para crear un nuevo evento e invitar a los miembros del grupo.';

  @override
  String get groupEmptyEventsUser => 'No hay eventos para este día específico, ¡mira otra fecha!';

  @override
  String get groupLeave => 'Abandona el grupo';

  @override
  String get groupLeaveConfirmation => '¿Seguro que quieres abandonar este grupo? Perderás el acceso a todos los eventos y miembros del grupo.';

  @override
  String get groupMakeAdmin => 'Haz admin del grupo';

  @override
  String get groupMakeAdminConfirmation => '¿Seguro que quieres hacer a este miembro admin?';

  @override
  String get groupManage => 'Gestionar grupo';

  @override
  String get grantPermission => 'Da permiso';

  @override
  String get groupRemoveMember => 'Quita del grupo';

  @override
  String get groupRemoveConfirmation => '¿Seguro que quieres quitar a este miembro del grupo?';

  @override
  String groupRoles(String role) {
    String _temp0 = intl.Intl.selectLogic(
      role,
      {
        'admin': 'Admin',
        'member': 'Miembro',
        'other': 'Desconocido',
      },
    );
    return '$_temp0';
  }

  @override
  String get guest => 'Invitado';

  @override
  String get invite => 'Invita a la gente';

  @override
  String inviteCodeExplanation(String user) {
    return 'Comparte este código con $user para invitarlo al grupo';
  }

  @override
  String inviteMessage(String code, String link) {
    return '¡Ey, únete a mi grupo en GRUP! Usa este código $code o haz clic aquí: $link';
  }

  @override
  String get invites => 'Invitaciones';

  @override
  String get invitesEmpty => '¡Es hora de invitar a tus amigos a unirse a tus grupos!<br/>Toca el botón <invite/> para invitar a tus amigos a unirse a tus grupos y empezar a organizar eventos juntos.';

  @override
  String get inviteFromContacts => 'Invita desde tus contactos';

  @override
  String get inviteManual => 'Invita manualmente';

  @override
  String get inviteMembersCTA => '¡Invita a algunos amigos!';

  @override
  String get join => 'Únete';

  @override
  String get joinGroup => 'Únete al grupo';

  @override
  String get language => 'Idioma';

  @override
  String get loading => 'Cargando...';

  @override
  String get members => 'Miembros';

  @override
  String get newGroup => 'Grupo nuevo';

  @override
  String get no => 'No';

  @override
  String get onboardingMessage => '¡Bienvenido a <title>GRUP</title>!<br/>Aún no has creado grupos. Empieza tocando el botón <plus/> para crear tu primer grupo y empieza a organizar eventos con amigos, familiares o compañeros.';

  @override
  String get profile => 'Perfil';

  @override
  String get recurrenceRule => 'Recurrencia';

  @override
  String get save => 'Guarda';

  @override
  String get selectContacts => 'Elige contactos';

  @override
  String get settings => 'Configuraciones';

  @override
  String get settingsMoreInfo => 'Más información';

  @override
  String get signOut => 'Cierra sesión';

  @override
  String get signOutConfirmation => '¿Seguro que quieres cerrar sesión?';

  @override
  String get systemLanguage => 'Idioma del sistema';

  @override
  String get timezone => 'Zona horaria';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get unknown => 'Desconocido';

  @override
  String get yes => 'Sí';

  @override
  String get you => 'Tú';
}
